# Troubleshooting & Operational Playbook

This reference provides root-cause diagnosis and remediation procedures for software factory execution failures.

---

## 1. Failure Modes & Resolutions

### A. Zero Commits Produced (`diffcheck` Failure)
**Symptom:** The workflow step `diffcheck` fails with `commits ahead of main: 0`, and the issue receives `agent:blocked`.

**Causes & Fixes:**
- **Agent became blocked:** Check if `.factory-blocked.txt` was output in the comment. If the agent encountered missing specifications or conflicting requirements, update the issue description with explicit instructions and re-apply `agent:implement`.
- **Check failure:** The agent produced code but discarded changes because local tests or linters failed. Inspect runner logs (`gh run view <ID> --log-failed`) to identify test errors.

### B. Pull Request Creation Refused (403 Forbidden)
**Symptom:** Step `pr` fails with:
```text
GitHub Actions is not permitted to create or approve pull requests.
```

**Cause:** The repository's default workflow permissions restrict `GITHUB_TOKEN` from opening pull requests.

**Fix:** Enable PR creation permissions on the repository:
```bash
gh api --method PUT "repos/{owner}/{repo}/actions/permissions/workflow" \
  -F default_workflow_permissions=write \
  -F can_approve_pull_request_reviews=true
```
Alternatively, navigate in GitHub web to **Settings $\to$ Actions $\to$ General $\to$ Workflow permissions** and check **"Allow GitHub Actions to create and approve pull requests"**.

### C. GraphQL 500 Internal Server Error
**Symptom:** `gh pr create` fails with intermittent GraphQL 500 errors.

**Cause:** GitHub's GraphQL endpoint occasionally returns 500 during high traffic or complex repository schema checks.

**Fix:** The factory uses the GitHub REST API (`POST /repos/{owner}/{repo}/pulls`) with `draft=true`. Never replace the REST implementation with `gh pr create` in automated runners. Furthermore, PR creation runs with `continue-on-error: true` so that even if the API hiccups, the pushed branch is preserved.

### D. Model Exhaustion or Runner IP Rate Limiting
**Symptom:** Agent step fails immediately with:
```text
Free usage limit reached.
```

**Cause:** Anonymous free-tier API endpoints frequently hit rate limits from shared cloud runner IP ranges (e.g., Azure IPs used by `ubuntu-latest`).

**Fix:** Authenticate free-tier models using an explicit account API key stored as a repository secret (`OPENCODE_API_KEY`). Account authentication bypasses shared IP quota throttling.

### E. Stale Locks (`agent:in-progress` Hang)
**Symptom:** An issue cannot be triggered because `agent:in-progress` remains attached, but no active GitHub Actions run exists.

**Cause:** A runner was manually cancelled or hit an ungraceful runner-level SIGKILL before the `always()` cleanup step finished.

**Fix:** Manually clear the lock via GitHub CLI:
```bash
gh issue edit <N> --remove-label "agent:in-progress"
```

---

## 2. Recovery Commands Cheat Sheet

```bash
# View recent workflow runs
gh run list --workflow=agent-implement.yml --limit 5

# View failed step logs for a run
gh run view <RUN_ID> --log-failed

# Re-trigger an issue manually via CLI
gh workflow run agent-implement.yml -f issue_number=<N>

# Promote all queued issues manually
gh workflow run agent-promote-queued.yml

# Clear failure state and re-queue an issue
gh issue edit <N> --remove-label "agent:blocked" --add-label "agent:implement"
```
