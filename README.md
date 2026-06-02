# DevOps Automation Collection

A production-oriented collection of automation scripts, operational tools, and infrastructure utilities built from real-world backend engineering and DevOps practices.

This repository serves as a personal knowledge base and portfolio showcasing automation techniques used to improve `system reliability`, `deployment efficiency`, `monitoring`, `security`, and `day-to-day operational workflows`.

## Overview
As a Backend Software Engineer with years of experience, I frequently automate repetitive operational tasks to improve **system stability** and **developer productivity**.

This repository contains reusable automation solutions covering:
- Linux system administration
- Infrastructure maintenance
- Monitoring and alerting
- Log management
- CI/CD automation
- Cloud operations
- Security and compliance checks
- Container and deployment utilities

The goal is to build a growing collection of production-ready scripts and operational tooling that can be reused across different environments and projects.


## Key Principles
### Reliability First

Scripts follow defensive programming practices: `set -euo pipefail`
- Strict error handling
- Input validation
- Meaningful exit codes
- Logging and diagnostics

### Automation First
Designed to eliminate repetitive manual work and integrate seamlessly with:
- Cron jobs
- CI/CD pipelines
- GitHub Actions
- Jenkins
- GitLab CI
- Cloud automation workflows

### Reusability
Scripts are built as modular components with:
- Consistent command-line interfaces
- Shared utility functions
- Standardized logging
- Configuration-driven behavior

### Production Mindset
Inspired by Site Reliability Engineering (SRE) and DevOps best practices:
- Observability
- Operational excellence
- Infrastructure automation
- Failure recovery
- Security awareness

## Repository Structure
```

devops-automation-collection/
│
├── scripts/
│   ├── monitoring/
│   ├── maintenance/
│   ├── backup/
│   ├── security/
│   ├── deployment/
│   └── cloud/
│
├── shared/
│   ├── logging.sh
│   ├── notifications.sh
│   └── common.sh
│
├── examples/
│
├── docs/
│
└── README.md
```


## Technologies
### Operating Systems
- Linux
- Fedora 43
- Amazon Linux

###  Scripting
- Bash
- Shell Scripting

### DevOps & Infrastructure
- Docker
- Terraform
- GitHub Actions
- Jenkins
- AWS

### Monitoring
- Cron
- Systemd
- Prometheus (future)
- Grafana (future)

### Utilities
- awk
- sed
- grep
- find
- tar
- curl
- jq

## Getting Started

- Clone the repository to your local machine or server:

```bash
git clone https://github.com/lilian-swen/devops-automation-toolkit.git

cd devops-automation-toolkit
```

- Make Scripts Executable
```bash
chmod +x scripts/**/*.sh
```

- Execute a Script
```bash
./scripts/monitoring/system-health.sh
```

- View Help
```bash
./scripts/monitoring/system-health.sh --help
```

## Why This Repository Exists

Modern backend engineering extends beyond writing application code.

Reliable software systems require automation around infrastructure, deployment, monitoring, security, and operations.

This repository documents practical DevOps solutions and operational tooling that help bridge software development and infrastructure management.

# Contributing

Contributions are welcome! If you have a script that solves a real-life infrastructure problem, feel free to submit a pull request. Please ensure all new scripts follow the established coding standards, including error handling and help documentation.

# License

MIT License
