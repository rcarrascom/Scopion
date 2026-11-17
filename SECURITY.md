# Security Policy

Scopion is a **demo application running on synthetic data**. It is designed to run locally on `127.0.0.1` and is not intended to be exposed to a network or the internet.

## What is and isn't in scope

- There is **no real authentication**. The "Connect to Salesforce" screen is a simulation; any visitor to the local port can read and edit the in-memory dataset. Do not add real customer data or deploy it publicly without adding authentication and authorization first.
- All data lives in memory and resets on restart. No external services are called.

## Built-in controls

- Loopback-only bind, plus a `Host` allowlist (DNS-rebinding defence) and same-origin check on state-changing requests (CSRF defence)
- Server-side type, range and allowlist validation on every write; request sizes are capped
- Content-Security-Policy and other security headers; interactive API docs disabled
- All third-party JavaScript is vendored under `static/vendor/` (no runtime CDN requests)
- Output escaping in the UI; spreadsheet-formula neutralization in CSV export
- Pinned dependencies (`requirements.txt`), monitored by Dependabot and `pip-audit` in CI

## Known limitations

- The CSP still allows `'unsafe-inline'` scripts and styles (inline event handlers and the Tailwind Play script require it).
- The vendored Tailwind Play script is intended for prototyping; a production build would compile CSS ahead of time.

## Reporting a vulnerability

Please open a private security advisory on this repository (Security tab > "Report a vulnerability") rather than a public issue. I'll respond as soon as I can.
