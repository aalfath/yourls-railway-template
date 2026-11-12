#!/usr/bin/env bash
# Start script for the YOURLS Railway template.
set -Eeuo pipefail

# Fixed settings with defaults, so the template needs no variables for them.
# Set any of these as a Railway variable to override it.
export YOURLS_DB_USER="${YOURLS_DB_USER:-yourls}"
export YOURLS_DB_NAME="${YOURLS_DB_NAME:-yourls}"
export YOURLS_USER="${YOURLS_USER:-admin}"

# Never start without a password and a cookie key.
: "${YOURLS_PASS:?YOURLS_PASS must be set (the template generates it)}"
: "${YOURLS_COOKIEKEY:?YOURLS_COOKIEKEY must be set (the template generates it)}"
: "${YOURLS_SITE:?YOURLS_SITE must be set, for example https://your-domain}"
: "${YOURLS_DB_HOST:?YOURLS_DB_HOST must be set}"

# On Railway, php:*-apache images can end up with more than one Apache MPM enabled
# ("AH00534: More than one MPM loaded"), although the image itself enables only prefork.
# mod_php needs prefork, so remove every other MPM before Apache starts.
for f in /etc/apache2/mods-enabled/mpm_*; do
  case "$f" in
    */mpm_prefork.*) ;;
    *) rm -f "$f" ;;
  esac
done
[ -e /etc/apache2/mods-enabled/mpm_prefork.load ] || a2enmod -q mpm_prefork

cd /var/www/html
exec container-entrypoint.sh "$@"
