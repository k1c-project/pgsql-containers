#! /bin/bash

rm -rf /var/lib/pgsql/data/* || exit 1

/bin/su -s /bin/bash -c "initdb -D /var/lib/pgsql/data/ --locale=ru_RU.UTF-8 --lc-collate=ru_RU.UTF-8 --lc-ctype=ru_RU.UTF-8 --encoding=UTF8" postgres || exit 1

exit 0