#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./remove_conflicting_iptables.sh         # show offending REDIRECT rules and proposed delete commands
#   ./remove_conflicting_iptables.sh --apply # backup nat table and execute deletions
#
# Note: run as root (sudo). This edits the nat table; a backup is created before any changes.

APPLY=0
if [[ "${1:-}" == "--apply" ]]; then
  APPLY=1
fi

TS=$(date +%s)
BACKUP="/root/iptables-nat-backup-${TS}.rules"

echo "=== Current nat OUTPUT (line-numbered) ==="
iptables -t nat -L OUTPUT -n --line-numbers || true
echo

echo "=== Scanning nat OUTPUT (-S) for REDIRECT rules ==="
mapfile -t REDIRECT_RULES < <(iptables -t nat -S OUTPUT 2>/dev/null | grep -i -- 'REDIRECT' || true)

if [ "${#REDIRECT_RULES[@]}" -eq 0 ]; then
  echo "No REDIRECT rules found in nat OUTPUT. Nothing to do."
  exit 0
fi

echo "Found REDIRECT rules:"
for r in "${REDIRECT_RULES[@]}"; do
  echo "  $r"
done
echo

echo "Proposed delete commands (no changes will be made unless --apply is passed):"
for r in "${REDIRECT_RULES[@]}"; do
  # Convert "-A OUTPUT ..." to "-D OUTPUT ..."
  delcmd="${r/-A /-D }"
  # Prepend 'iptables -t nat'
  echo "iptables -t nat $delcmd"
done
echo

if [ "$APPLY" -eq 0 ]; then
  echo "To actually remove these rules run:"
  echo "  sudo $0 --apply"
  exit 0
fi

# APPLY == 1: perform backup then delete
echo "Backing up current nat table to $BACKUP ..."
iptables-save -t nat > "$BACKUP" || { echo "Failed to save nat table to $BACKUP"; exit 1; }
echo "Backup written."

echo "Applying deletions..."
for r in "${REDIRECT_RULES[@]}"; do
  delcmd="${r/-A /-D }"
  echo "+ iptables -t nat $delcmd"
  # Execute deletion; ignore errors for rules that might not match exactly
  if ! iptables -t nat $delcmd 2>/dev/null; then
    echo "  (delete failed for: iptables -t nat $delcmd) — try manual inspection"
  fi
done

echo
echo "=== nat OUTPUT after deletion ==="
iptables -t nat -L OUTPUT -n --line-numbers || true

echo "Done. If Tor still logs NAT loop errors, share the updated 'iptables -t nat -L OUTPUT -n --line-numbers' and 'journalctl -u tor -n 200 --no-pager'."
