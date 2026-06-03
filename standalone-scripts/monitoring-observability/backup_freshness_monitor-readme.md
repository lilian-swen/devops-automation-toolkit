## Overview

The Backup Freshness Monitor is a Bash-based operational script used in DevOps environments to verify the health and freshness of backup files. It ensures that backups are being generated within expected time intervals and triggers alerts when backups are missing, outdated, or invalid.

This script is designed for use in:
- Cron jobs
- Monitoring agents
- Lightweight server health checks
- CI/CD maintenance pipelines

### Purpose
To automatically detect backup failures by checking:
- Whether backups exist
- Whether backups are recent enough
- Whether backup files are valid and non-empty

### Use Cases
- Detect failed database backup jobs
- Monitor file-based backup systems (tar, zip, dumps)
- Trigger early warning before data loss risk
- Integrate with email or logging systems for alerts
- Use in lightweight server monitoring without external tools

## Prerequisites
Before using this script, ensure the following tools are available:

**Required**
- Bash (v4+ recommended)
- stat command (GNU or BSD compatible)
- find, sort, tail

**Optional (for alerting)**
- mail or mailx (for email notifications)
- logger (usually pre-installed on Linux systems)

**Supported OS**
- Linux (Fedora, Ubuntu, RHEL, Debian)
- macOS (with BSD stat fallback)

## Usage Examples
### Default Execution
```bash
./backup_freshness_monitor.sh
```

### Custom Backup Directory
```bash
./backup_freshness_monitor.sh /mnt/backups
```

### Custom Thresholds
```bash
./backup_freshness_monitor.sh /mnt/backups 12 24
```

### Expected Output
OK state: 
```
OK: Backup is healthy (5 hours old)
```

WARNING state: 
```
WARNING: Backup is 22 hours old on server-01
```

CRITICAL state: 
```
CRITICAL: Backup is 35 hours old on server-01
```

Syslog output example:
```
backup-freshness-monitor[INFO] Latest backup: /var/backups/db/backup.tar | size=12345 bytes | age=5h
backup-freshness-monitor[WARNING] Backup is 22h old...
```
## References
GNU Coreutils Documentation: https://www.gnu.org/software/coreutils/

Bash Manual: https://www.gnu.org/software/bash/manual/

Linux stat command: https://man7.org/linux/man-pages/man1/stat.1.html

Syslog / logger: https://man7.org/linux/man-pages/man1/logger.1.html

Systemd journal: https://www.freedesktop.org/software/systemd/man/journalctl.html