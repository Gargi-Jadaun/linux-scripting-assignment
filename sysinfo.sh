#!/usr/bin/env bash
# sysinfo.sh - print a quick system summary
# Usage: ./sysinfo.sh            -> print to screen and save to sysinfo_YYYY-MM-DD.log
#        ./sysinfo.sh --no-save  -> print to screen only

set -euo pipefail

OUT_DIR="${OUT_DIR:-$(dirname "$(readlink -f "$0")")/reports}"
OUT_FILE="$OUT_DIR/sysinfo_$(date +%F).log"

report() {
    echo "==================== SYSTEM INFO ===================="
    echo "Hostname       : $(hostname)"
    echo "Date & Time    : $(date '+%Y-%m-%d %H:%M:%S %Z')"
    echo "Logged-in user : $(whoami)"
    echo
    echo "---- Disk usage of / ----"
    df -h /
    echo
    echo "---- Memory usage ----"
    free -h
    echo
    echo "---- Top 5 processes by memory ----"
    ps -eo pid,user,%mem,%cpu,comm --sort=-%mem | head -n 6
    echo "====================================================="
}

if [[ "${1:-}" == "--no-save" ]]; then
    report
else
    mkdir -p "$OUT_DIR"
    report | tee -a "$OUT_FILE"
    echo "Saved to: $OUT_FILE"
fi
