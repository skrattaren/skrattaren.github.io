If your *\`/etc/init.d/postgresql-8.4 start\`* fails after timeout, but
server runs in the background unharnessed, and
*\`/etc/init.d/postgresql-8.4 restart\`* fails with *"Socket conflict"*,
make sure you haven't deleted *"postgres"* database and recreate it in
that case.
