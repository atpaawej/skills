#!/usr/bin/env bash
# Render the draft PR body for a software factory run.
#
# The agent writes /tmp/factory-pr-body.md before it finishes — that is where the
# reasoning lives that a diff cannot show. This script turns it into the PR body.
#
# Three things are deliberately NOT the agent's:
#   - the `Closes #N` line, so only the orchestrator can close an issue;
#   - closing keywords in agent prose, which are neutralised ("fixes #12" would
#     close #12 on merge);
#   - the factual sections (files changed, model, run link), which are generated.
#
# If the agent left no usable description, the body falls back to a mechanical
# summary built from the commits and the diffstat. A PR never arrives with a
# silently empty description.
#
# Usage: build-pr-body.sh <issue-number> <model> [run-url]
#   stdout : the body source, "agent" or "fallback"
#   file   : the rendered body, at $PR_BODY_OUT

set -uo pipefail

N=${1:?usage: build-pr-body.sh <issue-number> <model> [run-url]}
MODEL=${2:-unknown}
RUN_URL=${3:-}

SRC=${PR_BODY_SRC:-/tmp/factory-pr-body.md}
OUT=${PR_BODY_OUT:-/tmp/factory-pr-body.out.md}
MIN_CHARS=300
MAX_CHARS=4000
MAX_LINES=40

# "closes #12" / "Closes: #12" / "fixes #12" -> "closes ~~#12~~". The number stays
# readable, but GitHub no longer reads it as a closing reference.
sanitize() {
  sed -E 's/(^|[^[:alnum:]_])([Cc]loses|[Ff]ixes|[Rr]esolves)([[:space:]]+:?[[:space:]]*)#([0-9]+)/\1\2 ~~#\4~~/g'
}

usable() {
  [ -s "$SRC" ] || return 1
  grep -qiE '^##[[:space:]]+summary' "$SRC" || return 1
  [ "$(wc -c <"$SRC")" -ge "$MIN_CHARS" ] || return 1
  return 0
}

# Hard cap, but land on a boundary and say it was cut, so a long description
# never ends mid-word. A line break is only preferred when it keeps most of the
# text; otherwise one long paragraph would be cut down to its first heading.
clip() {
  local text cut byline wordcut floor
  text=$(cat)
  if [ "${#text}" -le "$MAX_CHARS" ]; then
    printf '%s' "$text"
    return
  fi
  cut=${text:0:$MAX_CHARS}
  floor=$((MAX_CHARS * 3 / 5))
  byline=${cut%$'\n'*}
  wordcut=${cut% *}
  if [ "${#byline}" -ge "$floor" ]; then
    text=$byline
  elif [ "${#wordcut}" -ge "$floor" ]; then
    text=$wordcut
  else
    # No usable boundary (one enormous token): cut hard rather than keep a
    # fragment that lost the content.
    text=${cut:0:$floor}
  fi
  printf '%s\n\n_(Truncated at %s characters — read the diff for the rest.)' "$text" "$MAX_CHARS"
}

MODE=fallback
usable && MODE=agent

COMMITS=$(git log --oneline origin/main..HEAD 2>/dev/null | head -n "$MAX_LINES")
STAT=$(git diff --stat=100 origin/main...HEAD 2>/dev/null | sed '/^$/d')
STAT_LINES=$(printf '%s\n' "$STAT" | wc -l)

{
  printf 'Closes #%s\n\n' "$N"

  if [ "$MODE" = agent ]; then
    sanitize <"$SRC" | clip
    printf '\n\n'
  else
    printf '## Summary\n\n'
    printf '_The agent left no description for this run — review the diff._\n\n'
    printf '## Commits\n\n```\n%s\n```\n\n' "$COMMITS"
  fi

  printf '## Files changed\n\n```\n'
  printf '%s\n' "$STAT" | head -n "$MAX_LINES"
  if [ "$STAT_LINES" -gt "$MAX_LINES" ]; then
    printf '… (%s more lines)\n' "$((STAT_LINES - MAX_LINES))"
  fi
  printf '```\n\n'

  printf -- '---\n\nDraft PR opened by the software factory (%s). Read the diff before merging — a human merge is mandatory.' "$MODEL"
  [ -n "$RUN_URL" ] && printf ' Run: %s' "$RUN_URL"
  printf '\n'
} >"$OUT"

echo "$MODE"
