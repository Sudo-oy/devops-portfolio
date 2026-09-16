# Security Policy

## Supported versions

Only the latest release (or the `main` branch before the first release) receives security fixes.

## Reporting a vulnerability

**Please do not open a public issue for security problems.**

Report vulnerabilities privately through GitHub:

1. Go to the **Security** tab of [Sudo-oy/devops-portfolio](https://github.com/Sudo-oy/devops-portfolio/security).
2. Click **Report a vulnerability** and describe the issue, the affected version or commit, and the steps to reproduce.

You can expect:

- an acknowledgement within **5 business days**;
- an assessment and, if confirmed, a fix or mitigation plan within **30 days**;
- credit in the release notes unless you prefer to stay anonymous.

## Scope

In scope: the code, configuration defaults and CI workflows in this repository.

Out of scope: vulnerabilities in third-party dependencies (please report them upstream), and issues that require an already-compromised host or cloud account.

## Handling secrets

This project never needs secrets committed to the repository. If you find a credential in the code or the git history, report it privately as described above.
