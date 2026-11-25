# Linux Shell Scripting & Git – Assignment 1

Two Bash scripts:

| Script | What it does |
|---|---|
| `sysinfo.sh` | Prints hostname, current date/time, logged-in user, disk usage of `/`, memory usage and the top 5 processes by memory. Also saves the report to `reports/sysinfo_YYYY-MM-DD.log`. |
| `log_report.sh` | Takes an access-log file and prints total requests, number of 404 errors and the top 3 IP addresses. Prints a usage message if no file is given. |

## Requirements
Any Linux machine with Bash and the standard tools (`df`, `free`, `ps`, `awk`, `sort`, `uniq`).

## How to run

```bash
git clone https://github.com/<your-username>/linux-scripting-assignment.git
cd linux-scripting-assignment
chmod +x sysinfo.sh log_report.sh      # already executable in the repo

./sysinfo.sh                 # print + save to reports/sysinfo_<today>.log
./sysinfo.sh --no-save       # print only

./log_report.sh sample_access.log
./log_report.sh              # no argument -> usage message
```

## Sample output

### `./log_report.sh sample_access.log`
```
========== LOG REPORT: sample_access.log ==========
Total requests : 15
404 errors     : 5

Top 3 IP addresses:
  192.168.1.10     6 requests
  192.168.1.11     4 requests
  10.0.0.5         3 requests
======================================
```

### `./log_report.sh` (no file given)
```
Usage: ./log_report.sh <logfile>
Example: ./log_report.sh sample_access.log
```

### `./sysinfo.sh`
```
==================== SYSTEM INFO ====================
Hostname       : vm
Date & Time    : 2026-11-25 20:58:22 IST
Logged-in user : root

---- Disk usage of / ----
Filesystem      Size  Used Avail Use% Mounted on
/dev/vda        252G   13G   31G  29% /

---- Memory usage ----
               total        used        free      shared  buff/cache   available
Mem:           7.8Gi       427Mi       7.1Gi        12Mi       524Mi       7.4Gi
Swap:             0B          0B          0B

---- Top 5 processes by memory ----
  PID USER     %MEM %CPU COMMAND
  204 root      2.4  3.7 claude
  304 root      1.0  0.9 dockerd
  311 root      0.4  0.2 containerd
  101 root      0.4  0.0 environment-man
   90 root      0.3  0.0 rclone-filestor
=====================================================
Saved to: /home/ujjawal/linux-scripting-assignment/reports/sysinfo_2026-11-25.log
```

## How `log_report.sh` works
The log is in Apache/Nginx common log format, so field 1 is the client IP and field 9 is the HTTP status.

* Total requests: `grep -c . file` (counts non-empty lines)
* 404 errors: `awk '$9 == 404' file | wc -l`
* Top 3 IPs: `awk '{print $1}' file | sort | uniq -c | sort -rn | head -3`

## Bonus

* **Usage message** – `log_report.sh` prints usage and exits with code 1 if no file is given, and code 2 if the file does not exist.
* **Dated output file** – `sysinfo.sh` appends each run to `reports/sysinfo_$(date +%F).log`, e.g. `reports/sysinfo_2026-11-25.log`.
* **Hourly cron job** – run `crontab -e` and add the line from `crontab.txt` (change the path to where you cloned the repo):

```cron
0 * * * * /home/ujjawal/linux-scripting-assignment/sysinfo.sh >> /home/ujjawal/linux-scripting-assignment/reports/cron.log 2>&1
```

`0 * * * *` means minute 0 of every hour. Check it with `crontab -l`.

## Files
```
.
├── sysinfo.sh
├── log_report.sh
├── sample_access.log
├── crontab.txt
└── README.md
```
