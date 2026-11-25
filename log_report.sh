#!/usr/bin/env bash
# log_report.sh - summarise an Apache/Nginx access log
# Usage: ./log_report.sh <logfile>

set -euo pipefail

usage() {
    echo "Usage: $0 <logfile>"
    echo "Example: $0 sample_access.log"
    exit 1
}

[[ $# -lt 1 ]] && usage
LOG="$1"
[[ -f "$LOG" ]] || { echo "Error: file '$LOG' not found"; exit 2; }

total=$(grep -c . "$LOG" || true)
# field 9 is the HTTP status code in common/combined log format
not_found=$(awk '$9 == 404' "$LOG" | wc -l)

echo "========== LOG REPORT: $LOG =========="
echo "Total requests : $total"
echo "404 errors     : $not_found"
echo
echo "Top 3 IP addresses:"
awk '{print $1}' "$LOG" | sort | uniq -c | sort -rn | head -n 3 \
    | awk '{printf "  %-16s %s requests\n", $2, $1}'
echo "======================================"
