#!/usr/bin/env bash
# Scaffold and initialize the Software Factory in a target repository.
#
# Creates labels, configures workflow PR permissions, and copies
# workflow and script assets into .github/.
#
# Usage:
#   init-factory.sh [options]
#
# Options:
#   --target-dir <dir>    Target repository root (default: current directory)
#   --dry-run             Simulate actions without making changes
#   --skip-labels         Skip creating GitHub labels
#   --skip-permissions    Skip configuring GitHub Actions workflow permissions
#   --help, -h            Show this help message

set -euo pipefail

TARGET_DIR="."
DRY_RUN=false
SKIP_LABELS=false
SKIP_PERMS=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target-dir|--install-to)
      TARGET_DIR="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --skip-labels)
      SKIP_LABELS=true
      shift
      ;;
    --skip-permissions)
      SKIP_PERMS=true
      shift
      ;;
    -h|--help)
      grep -E '^#( |$)' "$0" | sed 's/^# \?//'
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo "=== Software Factory Initializer ==="
echo "Target directory: $TARGET_DIR"
echo "Dry run:          $DRY_RUN"

for cmd in git gh jq; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: Required command '$cmd' is not installed." >&2
    exit 1
  fi
done

cd "$TARGET_DIR"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: $TARGET_DIR is not a git repository." >&2
  exit 1
fi

REPO_SLUG=$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null || true)
if [ -z "$REPO_SLUG" ]; then
  echo "Warning: Could not determine GitHub repository slug. Are you authenticated with 'gh auth login'?" >&2
else
  echo "Detected GitHub repository: $REPO_SLUG"
fi

# 1. Install Assets
echo ""
echo "--> Installing factory assets into $TARGET_DIR/.github/..."
WORKFLOW_DIR="$TARGET_DIR/.github/workflows"
SCRIPTS_DIR="$TARGET_DIR/.github/scripts"

if [ "$DRY_RUN" = true ]; then
  echo "[DRY RUN] Would create $WORKFLOW_DIR and $SCRIPTS_DIR"
  echo "[DRY RUN] Would copy agent-implement.yml and agent-promote-queued.yml"
  echo "[DRY RUN] Would copy and chmod +x build-pr-body.sh"
else
  mkdir -p "$WORKFLOW_DIR" "$SCRIPTS_DIR"
  cp -f "$SKILL_ROOT/assets/workflows/agent-implement.yml" "$WORKFLOW_DIR/"
  cp -f "$SKILL_ROOT/assets/workflows/agent-promote-queued.yml" "$WORKFLOW_DIR/"
  cp -f "$SKILL_ROOT/assets/scripts/build-pr-body.sh" "$SCRIPTS_DIR/"
  chmod +x "$SCRIPTS_DIR/build-pr-body.sh"
  echo "Successfully copied workflow and script assets."
fi

# 2. Create State Machine Labels
if [ "$SKIP_LABELS" = false ] && [ -n "$REPO_SLUG" ]; then
  echo ""
  echo "--> Creating state machine labels on $REPO_SLUG..."
  
  create_label() {
    local name="$1"
    local color="$2"
    local desc="$3"
    if [ "$DRY_RUN" = true ]; then
      echo "[DRY RUN] Would create label '$name' ($color) - '$desc'"
    else
      gh label create "$name" --repo "$REPO_SLUG" --color "$color" --description "$desc" --force 2>/dev/null || \
      gh label edit "$name" --repo "$REPO_SLUG" --color "$color" --description "$desc"
      echo "  ✓ Label '$name' configured"
    fi
  }

  create_label "ready-for-agent"  "0E8A16" "Fully specified; triage signal"
  create_label "agent:implement"   "1D76DB" "The trigger: factory implements this issue"
  create_label "agent:queued"      "FBCA04" "Promote when all blockers close"
  create_label "agent:in-progress" "D93F0B" "Lock: active factory run holds this issue"
  create_label "agent:blocked"     "B60205" "Needs human triage before retry"
fi

# 3. Configure Workflow Permissions
if [ "$SKIP_PERMS" = false ] && [ -n "$REPO_SLUG" ]; then
  echo ""
  echo "--> Configuring GitHub Actions workflow permissions..."
  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would set default_workflow_permissions=write and can_approve_pull_request_reviews=true"
  else
    if gh api --method PUT "repos/${REPO_SLUG}/actions/permissions/workflow" \
      -F default_workflow_permissions=write \
      -F can_approve_pull_request_reviews=true >/dev/null 2>&1; then
      echo "  ✓ Workflow write permissions and PR creation enabled."
    else
      echo "  ⚠ Could not set permissions automatically. Please verify repository admin rights."
      echo "    Ensure Settings -> Actions -> General -> Workflow permissions is set to Read/Write"
      echo "    and 'Allow GitHub Actions to create and approve pull requests' is checked."
    fi
  fi
fi

# 4. Check API Key Secret
if [ -n "$REPO_SLUG" ]; then
  echo ""
  echo "--> Checking repository secrets..."
  if gh secret list --repo "$REPO_SLUG" 2>/dev/null | grep -q "OPENCODE_API_KEY"; then
    echo "  ✓ OPENCODE_API_KEY secret is present."
  else
    echo "  ℹ OPENCODE_API_KEY is not yet set in repository secrets."
    echo "    To set it, run: gh secret set OPENCODE_API_KEY --repo $REPO_SLUG"
  fi
fi

echo ""
echo "=== Software Factory Setup Complete ==="
echo "To trigger your first run:"
echo "  1. Create or open an issue on GitHub"
echo "  2. Apply the label 'agent:implement':"
echo "     gh issue edit <N> --add-label agent:implement"
