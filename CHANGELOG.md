# Changelog

Each entry is one version of this Railway template. Breaking changes are listed first.
Read the entry before you apply an update in Railway.

## 1.10.6-1 (2026-11-12)

- First version: YOURLS 1.10.6 (`yourls:1.10.6-apache@sha256:3631239a8cc0f3911f0cdae00f5475f48a65b9f2c9f120ba137766bba28c945c`).
- Creates the database tables on the first start, before Apache starts, so the installer page is never public.
- Admin user `admin` (override with `YOURLS_USER`), password from the generated `YOURLS_PASS`.
- `/` redirects to `/admin/`.
- The template's MySQL service runs `mysql:8.4.13@sha256:a81d043930e51745522bd5c430961cf8286f0a23f0a9a2a6e0108f7ea71b0902` directly; it is not built from this repo.

## Unreleased

- README: Deploy on Railway button. No change to the running service.
