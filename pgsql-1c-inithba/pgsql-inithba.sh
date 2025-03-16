#! /bin/bash

key_read=0
hba_type=""
hba_database=""
hba_user=""
hba_address=""
hba_method=""

operation=1

hba_conf="/var/lib/pgsql/data/pg_hba.conf"
#hba_conf="/root/pg_hba.conf"

for i
do
    if [ $i = "--add" ]; then
	operation=1;
	key_read=0;
	echo "add";
	continue;
    fi
    
    if [ $i = "--del" ]; then
	operation=0;
	key_read=0;
	echo "del"
	continue;
    fi
	
    if [ $key_read -eq 0 ]; then
	hba_type=$i;
	key_read=`expr $key_read + 1`;
	continue;
    fi
	
    if [ $key_read -eq 1 ]; then
	hba_database=$i;
	key_read=`expr $key_read + 1`;
	continue;
    fi
	
    if [ $key_read -eq 2 ]; then
        hba_user=$i;
        key_read=`expr $key_read + 1`;
        continue;
    fi
	
    if [ $key_read -eq 3 ]; then
        hba_address=$i;
        key_read=`expr $key_read + 1`;
        continue;
    fi
	
    if [ $key_read -eq 4 ]; then
        hba_method=$i;
        key_read=0;

        if [ $hba_address = "--any-address" ]; then
	    search_string="^$hba_type.*$hba_database.*$hba_user.*$hba_method";
	else
	    search_string="^$hba_type.*$hba_database.*$hba_user.*$hba_address.*$hba_method";
	fi
	echo "$search_string"
	if [ $operation -eq 1 ]; then

	    if grep "$search_string" $hba_conf ; then
		continue;
	    else
		tab="	"
		if [ $hba_address = "--any-address" ]; then
		    echo "$hba_type""$tab""$tab""$hba_database""$tab""$hba_user""$tab""$tab""$tab""$tab""$tab$hba_method" >> $hba_conf
		else
		    echo "$hba_type""$tab""$tab""$hba_database""$tab""$hba_user""$tab""$tab""$hba_address""$tab""$tab""$hba_method" >> $hba_conf
		fi
	    fi
	    continue;
	fi
    
	if [ $operation -eq 0 ]; then
	    echo "comment"
	    sed -i "s/\($search_string\)/#\1/g" $hba_conf
	    continue;
	fi
    fi
done

exit 0