# YOURLS for Railway: the official image, pinned by version and digest, plus a small start script
# and a first-start install hook.
FROM yourls:1.10.6-apache@sha256:3631239a8cc0f3911f0cdae00f5475f48a65b9f2c9f120ba137766bba28c945c

# The image's entrypoint runs /docker-entrypoint-init.d/*.sh after it copies YOURLS into the docroot
# and before Apache starts. This hook creates the database tables, so the installer is never public.
COPY 10-railway-install.sh /docker-entrypoint-init.d/10-railway-install.sh
COPY railway-start.sh /usr/local/bin/railway-start.sh
RUN chmod 755 /docker-entrypoint-init.d/10-railway-install.sh /usr/local/bin/railway-start.sh

# Apache listens on 8080 (set by the image). Railway's PORT defaults to 8080 too.
ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
CMD ["apache2-foreground"]
