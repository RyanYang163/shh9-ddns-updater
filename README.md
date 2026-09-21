# DDNS Updater

> TOS 7 application package for **DDNS Updater** — platform integration only.
> The application itself is provided by the upstream project, unmodified.

## Overview

Periodically updates DNS records with your current public IP across many DNS providers.

上游项目 / Upstream: <https://github.com/qdm12/ddns-updater>
上游许可证 / License: **MIT**

## Features

- Supports dozens of DNS providers (Cloudflare, DNSPod, DuckDNS, Route53, ...)
- Periodic public-IP detection and record update
- Web UI for configuration and status
- Single static binary, zero dependencies

## Installation

1. Requirements: TOS 7.0+ and systemd + nginx
2. Install from the TOS App Center
3. Open the app and complete initial configuration

## Usage

1. Access URL: `http://${ip}:18809`
2. Default credentials: see upstream documentation
3. Key settings: see upstream documentation

## Permissions

| Permission | Rationale |
|---|---|
| Network: port 18809 | Web UI access |
| File system: `/Volume*/DockerAppData/shh9-ddns-updater/` | Application data persistence |
| User: shh9ddnsupdater | Isolated non-root service execution |

## Configuration

See `config.ini` for platform metadata; see `docker-compose.yml` for runtime configuration.

## Ports

| Port | Protocol | Purpose |
|---|---|---|
| 18809 | TCP | Web UI (DDNS Updater) |

## Support

- Documentation: https://github.com/qdm12/ddns-updater
- Issue tracker: https://github.com/qdm12/ddns-updater/issues
- Community: https://github.com/qdm12/ddns-updater

## Security & Compliance

- **License**: MIT — full text in [`LICENSE`](./LICENSE)
- **Attribution**: see [`NOTICE`](./NOTICE)
- **Privacy Policy**: see [`PRIVACY.md`](./PRIVACY.md)
- **Vulnerability scan**: `trivy-report.txt` attached to each Release (HIGH/CRITICAL must be 0)
- Runs as a non-root dedicated user; no privileged mode, no host network

## Changelog

### v1.0.1 (2026-09-20)
- Compliance update: added LICENSE / NOTICE / PRIVACY materials,
  declared upstream license inside the package, added container healthcheck

### v1.0.0
- Initial release

## License

**MIT** — this packaging repository is distributed under the same license as the
upstream project. Full text: [`LICENSE`](./LICENSE).
