# Security & Trust Boundaries

The software factory operates across a strict boundary dividing the untrusted coding agent from the trusted workflow orchestrator.

---

## 1. Cleanroom Isolation (`env -i`)

The agent is an untrusted autonomous process. To prevent credential exfiltration, prompt injection exploits, or unauthorized mutations:

- **Token Stripping**: The agent environment is explicitly sanitized using `env -i`.
- **No GitHub Access**: Neither `GITHUB_TOKEN` nor `GH_TOKEN` is passed into the agent subshell. The agent cannot query GitHub APIs, modify issues, push branches, or alter releases.
- **Minimal Whitelist**: Only non-sensitive execution variables are exposed:
  ```bash
  env -i HOME="$HOME" PATH="$PATH" TERM=dumb CI=true \
    OPENCODE_API_KEY="$OPENCODE_API_KEY" MODEL="$MODEL" \
    bash -lc 'opencode run ...'
  ```

---

## 2. Orchestrator Privileges

All mutations outside the local filesystem are executed by the GitHub Actions runner (the orchestrator) after the agent process terminates:

| Task | Owned By | Mechanism |
| :--- | :--- | :--- |
| Code editing & local testing | Agent | Subshell |
| Rationale generation | Agent | `/tmp/factory-pr-body.md` |
| Catch-all git commits | Orchestrator | `git commit -m "Part of #N: ..."` |
| Upstream rebase & branch push | Orchestrator | `git rebase origin/main && git push --force` |
| Pull request creation | Orchestrator | GitHub REST API with runner `GITHUB_TOKEN` |
| Label updates & comments | Orchestrator | GitHub CLI (`gh issue edit`, `gh issue comment`) |

---

## 3. Pull Request Protection & Keyword Neutralization

The agent is never permitted to close issues directly or claim final authority:

1. **Orchestrator Owns `Closes #N`**:
   The `Closes #N` line is prepended solely by the `build-pr-body.sh` script on the first line of the pull request body.
2. **Closing Keyword Neutralization**:
   If an agent writes prose like `"This fixes #12 and closes #15"`, merging the PR would inadvertently close unrelated issues. The sanitization layer transforms these patterns:
   ```bash
   sed -E 's/(^|[^[:alnum:]_])([Cc]loses|[Ff]ixes|[Rr]esolves)([[:space:]]+:?[[:space:]]*)#([0-9]+)/\1\2 ~~#\4~~/g'
   ```
   Result: `"This fixes ~~#12~~ and closes ~~#15~~"`. The reference remains readable to humans but ignored by GitHub's auto-close parser.
3. **Draft Pull Requests**:
   All pull requests are created with `draft: true`. Draft PRs do not notify code owners for review until a human inspects the diff and marks the PR ready for review.
4. **Mandatory Human Merge**:
   Under no circumstances does the factory merge PRs into `main`. The default branch can only be modified by human approval.

---

## 4. Deterministic Branches & Force Pushes

Work is scoped to deterministic, reproducible branch names:
```text
agent/issue-<ISSUE_NUMBER>-<SLUG>
```

- If an issue is re-run, the factory checks out the same branch name, rebases on `origin/main`, and force-pushes (`git push --force origin HEAD:refs/heads/$BRANCH`).
- Existing open PRs for that branch are updated via `PATCH` rather than opening duplicate pull requests.
- The pushed branch is the primary deliverable. If GitHub's PR API fails or returns 500, the code remains safe on the remote branch, and instructions for manual PR opening are posted to the issue.
