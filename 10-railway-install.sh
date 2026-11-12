#!/bin/sh
# Railway template: create the YOURLS tables before Apache starts,
# so the public URL never shows the "Install YOURLS" page.
# Runs on every start; once the tables exist it only checks and moves on.
cat > /tmp/yourls-install.php <<'PHP'
<?php
define('YOURLS_ADMIN', true);
define('YOURLS_INSTALLING', true);
require '/var/www/html/includes/load-yourls.php';
if (yourls_is_installed()) { echo "YOURLS_READY already installed\n"; exit(0); }
$r = yourls_create_sql_tables();
if (!empty($r['error'])) { fwrite(STDERR, strip_tags(implode("\n", $r['error'])) . "\n"); exit(1); }
echo "YOURLS_READY tables created\n";
PHP
# php's exit code is not reliable here (yourls_die() on a DB error exits 0), so look for the marker.
i=0
while :; do
  out=$(php /tmp/yourls-install.php 2>&1)
  case "$out" in *YOURLS_READY*) echo "$out" | grep YOURLS_READY; break;; esac
  i=$((i+1))
  if [ "$i" -ge 60 ]; then
    echo "YOURLS install failed:" >&2
    echo "$out" | sed 's/<[^>]*>//g' | grep -v '^\s*$' | tail -5 >&2
    exit 1
  fi
  echo "Waiting for MySQL ($i)..."; sleep 5
done
rm -f /tmp/yourls-install.php
# The docroot has no index page, so "/" would answer 403. Send visitors to the admin area instead.
[ -e /var/www/html/index.php ] || printf '%s\n' '<?php header("Location: admin/", true, 302);' > /var/www/html/index.php
