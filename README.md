# YOURLS on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/Z5PZxH?utm_medium=integration&utm_source=button&utm_campaign=yourls)

Railway template for [YOURLS](https://github.com/YOURLS/YOURLS) (Your Own URL Shortener): short links with your own keywords, click statistics and an API.

## What it deploys

Two services:

- **YOURLS**, built from this repo's `Dockerfile`:
  - YOURLS **1.10.6**, the official Apache image pinned by digest: `yourls:1.10.6-apache@sha256:3631239a8cc0f3911f0cdae00f5475f48a65b9f2c9f120ba137766bba28c945c`.
  - A Railway domain on port 8080, health check `/admin/` and restart on failure (up to 10 times). These settings are part of the template itself. The repo has no `railway.json`, because Railway stops reading it on 2026-12-01.
- **MySQL** 8.4 LTS, the official image `mysql:8.4.13@sha256:a81d043930e51745522bd5c430961cf8286f0a23f0a9a2a6e0108f7ea71b0902`, with its data on a Railway volume at `/var/lib/mysql`. On its first start it creates the `yourls` database and user. It runs the image directly and is not built from this repo.

On every start, `10-railway-install.sh` waits for MySQL and, if the YOURLS tables don't exist yet, creates them before Apache starts. So the public URL never shows the "Install YOURLS" page. `railway-start.sh` sets the defaults below, refuses to start without a password and cookie key, and makes sure Apache runs with only the `prefork` MPM.

## Variables (YOURLS service)

| Variable | Default in the template | Description |
|---|---|---|
| `YOURLS_PASS` | `${{secret(24, "…")}}` (generated) | Password of the admin user. To change it, set a new value and redeploy. |
| `YOURLS_COOKIEKEY` | `${{secret(64, "…")}}` (generated) | Secret that signs login cookies and the API signature token. |
| `YOURLS_SITE` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Public URL of YOURLS. After adding a custom domain, set it to `https://<custom-domain>` (lowercase, no trailing slash). |
| `YOURLS_DB_HOST` | `${{MySQL.RAILWAY_PRIVATE_DOMAIN}}` | MySQL host on Railway's private network. |
| `YOURLS_DB_PASS` | `${{MySQL.MYSQL_PASSWORD}}` | Password of the `yourls` database user. |

Optional, with defaults in `railway-start.sh`: `YOURLS_USER` (`admin`), `YOURLS_DB_USER` (`yourls`), `YOURLS_DB_NAME` (`yourls`). The official image reads more settings, such as `YOURLS_URL_CONVERT`, `YOURLS_HOURS_OFFSET` and `YOURLS_LANG`.

**Signing in:** open `https://<your-domain>/admin/` and sign in as `admin` with the `YOURLS_PASS` value. The API signature token is under Tools.

## Updates

Projects deployed from the template build the YOURLS service from this repo's `main` branch. When a new version is merged to `main`, Railway shows those projects an "update available" notice, and each owner chooses when to apply it. Every version is listed in [CHANGELOG.md](CHANGELOG.md), with breaking changes first.
