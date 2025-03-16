#! /bin/bash

#cp -rfp /var/lib/pgsql/data/postgresql.conf /data/postgresql.conf || exit 1
#cp -rfp /root/postgresql.conf.orig /root/postgresql.conf

key_read=0
key=""
operation=1

postgresql_conf="/var/lib/pgsql/data/postgresql.conf"
#postgresql_conf="/root/postgresql.conf"

for i
do
    if [ $i = "--add" ]; then
	operation=1;
	key_read=0;
	continue;
    fi
    
    if [ $i = "--del" ]; then
	operation=0;
	key_read=0;
	continue;
    fi
	
    if [ $operation -eq 1 ]; then
    
	if [ $key_read -eq 0 ]; then
	    key=$i;
	    key_read=1;
	    continue;
	fi
    
	if [ $key_read -eq 1 ]; then
	    sed -i "s/^$key/#$key/g" $postgresql_conf
	    #sed -i "/^#$key/a $key = $i" $postgresql_conf
	    if grep "^#$key" $postgresql_conf ; then
		sed -i "0,/^#$key/s//$key = $i\n&/" $postgresql_conf
	    else
		echo "$key = $i" >> $postgresql_conf
	    fi
	
	    key_read=0;
	    continue;
	fi
    fi
    
    if [ $operation -eq 0 ]; then
	key=$i
	sed -i "s/^$key/#$key/g" $postgresql_conf
	continue;
    fi
done

exit 0