#! /bin/bash

/bin/su -s /bin/bash -c "postgres -D /var/lib/pgsql/data >/tmp/logfile 2>&1" postgres &

sleep_delay=5

if [ "$#" -ne 1 ]; then
    sleep_delay=$2
fi

sleep $sleep_delay

sql_command="CREATE DATABASE $1;";
psql -h localhost -U postgres  -c "$sql_command" || exit 1


exit 0