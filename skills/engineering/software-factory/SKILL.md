---
name: software-factory
description: Scaffold, configure, and operate an autonomous, issue-driven software factory for any repository. Sets up token-scrubbed AFK implementation workflows, dependency-aware queue promotion, state-machine labels, and PR description synthesis.
license: MIT
compatibility: Linux/macOS with git, GitHub CLI (gh), jq, and GitHub Actions
metadata:
  version: "1.0.0"
  author: "aawej"
---

# Software Factory

Scaffold, configure, and operate an **autonomous software factory** for a software repository. The software factory turns GitHub issues into draft pull requests via unattended, token-scrubbed agent runs triggered by issue labels.

Humans triage, authorize, and merge. The factory implements, validates, and reports. Nothing in this system merges to the default branch on its own.

## Core Concepts & Leading Words

- **Leash**: CI checks (`typecheck`, `test`, `build`, linter) define the leash. An agent must run and satisfy all local checks before concluding; remote CI displays red/green status on the draft PR prior to human review.
- **Scrubbed Environment**: The agent executes inside a stripped shell (`env -i`) with zero access to `GITHUB_TOKEN` or repository secrets.
- **Lock**: The `agent:in-progress` label functions as a mutual exclusion lock to prevent duplicate concurrent runs on the same issue.
- **Deterministic Branch**: Work is committed to a per-issue branch named `agent/issue-<N>-<slug>`. The orchestrator rebases on `origin/main` and force-pushes to guarantee idempotent recovery.
- **Native Blockers**: Automatic queue progression uses GitHub's native issue dependencies (`dependencies/blocked_by`).
- **PR Reflection**: Before stopping, the agent writes its rationale to `/tmp/factory-pr-body.md`. The orchestrator wraps this file, neutralizes closing keywords, appends git diffstats, and opens a draft PR.

Consult deep reference documents when working on specific subsystems:
- State machine & label transitions: [`references/state-machine.md`](references/state-machine.md)
- Security boundaries & sandboxing: [`references/trust-boundaries.md`](references/trust-boundaries.md)
- Diagnosing failures & rate limits: [`references/troubleshooting.md`](references/troubleshooting.md)

---

## Steps

### 1. Inspect the Target Repository

Examine the target repository to determine configuration parameters before scaffolding:

1. **Remote and Tracking**: Verify the repository has a GitHub origin remote:
   ```bash
   git remote get-url origin
   gh repo view --json nameWithOwner,defaultBranchRef
   ```
2. **Verification Commands**: Identify the project's canonical test, build, and typecheck commands from configuration files (`package.json`, `Cargo.toml`, `pyproject.toml`, `Makefile`, etc.).
3. **Existing Workflows**: Check whether `.github/workflows/agent-implement.yml` or `.github/workflows/agent-promote-queued.yml` already exist.

**Done when:** The repository slug, default branch, and test/build commands are recorded.

---

### 2. Scaffold Workflow and Script Assets

Copy the factory templates into the target repository:

1. **Workflow Directory**: Ensure `.github/workflows` and `.github/scripts` exist:
   ```bash
   mkdir -p .github/workflows .github/scripts
   ```
2. **Install Workflows**:
   - Copy `assets/workflows/agent-implement.yml` to `.github/workflows/agent-implement.yml`.
   - Copy `assets/workflows/agent-promote-queued.yml` to `.github/workflows/agent-promote-queued.yml`.
   - Adapt the verification commands in `agent-implement.yml` to match the target repository's stack (e.g. `npm test`, `cargo test`, `pytest`).
3. **Install PR Body Renderer**:
   - Copy `assets/scripts/build-pr-body.sh` to `.github/scripts/build-pr-body.sh`.
   - Ensure executable permissions: `chmod +x .github/scripts/build-pr-body.sh`.

You can perform this step automatically by running the bundled setup script:
```bash
./scripts/init-factory.sh --install-to /path/to/target-repo
```

**Done when:** Both workflows and `build-pr-body.sh` exist in the target repository and pass `bash -n .github/scripts/build-pr-body.sh`.

---

### 3. Create Labels and Configure GitHub Permissions

The factory requires five state-machine labels and GitHub Actions write permissions to open pull requests:

1. **Create Labels**:
   ```bash
   gh label create "ready-for-agent"  --color "0E8A16" --description "Fully specified; triage signal" --force
   gh label create "agent:implement"   --color "1D76DB" --description "The trigger: factory implements this issue" --force
   gh label create "agent:queued"      --color "FBCA04" --description "Promote when all blockers close" --force
   gh label create "agent:in-progress" --color "D93F0B" --description "Lock: active factory run holds this issue" --force
   gh label create "agent:blocked"     --color "B60205" --description "Needs human triage before retry" --force
   ```
2. **Grant Workflow PR Permissions**:
   GitHub Actions requires explicit write permissions to create pull requests with `GITHUB_TOKEN`. Enable this via the GitHub CLI:
   ```bash
   gh api --method PUT "repos/{owner}/{repo}/actions/permissions/workflow" \
     -F default_workflow_permissions=write \
     -F can_approve_pull_request_reviews=true
   ```
3. **Set Agent API Secret**:
   Configure the LLM runner API key as a repository secret (e.g., `OPENCODE_API_KEY`, `ANTHROPIC_API_KEY`):
   ```bash
   gh secret set OPENCODE_API_KEY
   ```

**Done when:** All five labels exist in `gh label list`, workflow permissions return write access, and the model secret is stored.

---

### 4. Operate the Factory Loop

Manage day-to-day issue implementation using the state machine:

#### A. Triage and Queue an Issue
When an issue is specified with clear acceptance criteria and verification commands:
- **Immediate implementation**: Apply `agent:implement` to trigger the factory immediately:
  ```bash
  gh issue edit <N> --add-label "agent:implement"
  ```
- **Dependent implementation**: If an issue depends on unfinished work, link blockers and apply `agent:queued`:
  ```bash
  gh issue edit <N> --add-label "agent:queued"
  ```
  Link blockers using GitHub's native issue dependencies API:
  ```bash
  BLOCKER_ID=$(gh api "repos/{owner}/{repo}/issues/<BLOCKER_N>" --jq .id)
  gh api --method POST "repos/{owner}/{repo}/issues/<N>/dependencies/blocked_by" -F issue_id="$BLOCKER_ID"
  ```

#### B. Monitor Execution
Track running jobs via GitHub CLI:
```bash
gh run list --workflow=agent-implement.yml
gh run watch <RUN_ID>
```

#### C. Review and Merge
When a run completes:
1. Locate the draft PR linked in the issue comments.
2. Verify CI test passes on the PR branch.
3. Review the code diff and the agent's six-section summary in the PR description.
4. Convert from draft to ready-for-review and merge using a human account.

**Done when:** The issue is labeled `agent:in-progress` during execution, followed by a draft PR opening with `Closes #N`.

---

### 5. Diagnose and Recover from Failures

When a factory run exits without opening a PR:

1. **Check Failure Label**: A failed run automatically removes `agent:implement` and applies `agent:blocked`.
2. **Inspect Run Logs**:
   ```bash
   gh run view <RUN_ID> --log-failed
   ```
3. **Diagnose Common Causes**:
   - **0 commits produced**: Check the run comment for `.factory-blocked.txt` output. The agent encountered an ambiguous specification or unmet dependency.
   - **Check failure**: The agent could not pass local test/typecheck suites within the timeout.
   - **Stale lock**: If a runner was killed mid-flight, manually release the lock:
     ```bash
     gh issue edit <N> --remove-label "agent:in-progress"
     ```
4. **Retry**: Fix the root cause in the issue description or codebase, then re-add `agent:implement`:
   ```bash
   gh issue edit <N> --remove-label "agent:blocked" --add-label "agent:implement"
   ```

**Done when:** Stale locks are removed, blocking issues are resolved, and the retry run completes or logs a clear impediment.
