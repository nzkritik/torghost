#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   sudo ./remove_docker_nat_output.sh        # show offending nat OUTPUT rules and proposed deletions
#   sudo ./remove_docker_nat_output.sh --apply  # backup nat table and execute deletions
#
# This script:
# - enumerates iptables nat OUTPUT rules
# - finds rules that reference the DOCKER target or contain ADDRTYPE/LOCAL
# - prints the iptables -t nat -D ... commands to remove them
# - if --apply: backs up nat table and executes the deletes

APPLY=0
if [[ "${1:-}" == "--apply" ]]; then
  APPLY=1
fi

TS=$(date +%s)
BACKUP="/root/iptables-nat-backup-${TS}.rules"

echo "=== Current nat OUTPUT (line-numbered) ==="
iptables -t nat -L OUTPUT -n --line-numbers || true
echo

echo "=== nat OUTPUT rules (-S) containing DOCKER or ADDRTYPE/LOCAL ==="
mapfile -t FOUND < <(iptables -t nat -S OUTPUT 2>/dev/null | grep -Ei -- 'DOCKER|ADDRTYPE|LOCAL' || true)

if [ "${#FOUND[@]}" -eq 0 ]; then
  echo "No DOCKER/ADDRTYPE/LOCAL rules found in nat OUTPUT."
  exit 0
fi

echo "Found offending rules (exact -S form):"
for r in "${FOUND[@]}"; do
  echo "  $r"
done
echo

echo "Proposed delete commands (preview):"
for r in "${FOUND[@]}"; do
  # Convert "-A OUTPUT ..." to "-D OUTPUT ..."
  del="${r/-A /-D }"
  echo "iptables -t nat $del"
done
echo

if [ "$APPLY" -eq 0 ]; then
  echo "To actually remove these rules run:"
  echo "  sudo $0 --apply"
  exit 0
fi

# APPLY: backup and delete
echo "Backing up current nat table to $BACKUP ..."
iptables-save -t nat > "$BACKUP" || { echo "Failed to save nat table to $BACKUP"; exit 1; }
echo "Backup written."

echo "Applying deletions..."
for r in "${FOUND[@]}"; do
  del="${r/-A /-D }"
  echo "+ iptables -t nat $del"
  if ! iptables -t nat $del 2>/dev/null; then
    echo "  (delete failed for: iptables -t nat $del) — it may have changed; inspect manually"
  fi
done

echo
echo "=== nat OUTPUT after deletion ==="
iptables -t nat -L OUTPUT -n --line-numbers || true

echo "Done. Now restart Tor and monitor its journal:"
echo "  sudo systemctl restart tor"
echo "  sudo journalctl -u tor -f"
