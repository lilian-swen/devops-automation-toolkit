# Roadmap & Improvement Opportunities

This document tracks planned improvements, refactoring tasks, and technical debt to keep the `devops-automation-toolkit` efficient and maintainable.

## Planned Improvements
- [ ] **Modularization:** Move shared helper functions (logging, validation) into a standalone `lib/utils.sh` to reduce code duplication across scripts.

- [ ] **Config Files:** Migrate hardcoded variables (paths, thresholds) into external `.conf` or `.env` files for better portability.

- [ ] **Unit Testing:** Implement a testing framework (e.g., `bats-core`) to validate script logic before deployment.

- [ ] **Centralized Logging:** Integrate scripts to send logs to a centralized server (e.g., ELK stack or Graylog) rather than just local files.

## Technical Debt
- [ ] Refactor `bin/old-script.sh` to follow the new `template.sh` standards.

- [ ] Improve error handling for edge cases in `monitoring-observability/` scripts.

## Ideas for Future Scripts
- [ ] Automated backup of database dumps to S3.
- [ ] Script to check for expired SSL certificates on local servers.
- [ ] Automated cleanup of dangling Docker containers and images.

---

*If you see an opportunity for optimization, please feel free to open a feature request or submit a pull request!*