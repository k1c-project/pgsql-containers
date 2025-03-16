#! /bin/bash

rm -rf /var/lib/pgsql/data/* || exit 1

command="/bin/su -s /bin/bash -c \"pg_basebackup -D /var/lib/pgsql/data --checkpoint=fast "$@"\" postgres";
/bin/bash -c "$command" || exit 1

exit 0