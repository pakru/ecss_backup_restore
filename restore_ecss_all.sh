#!/bin/bash

CURRENT_FOLDER=$(pwd)
TEMP_FOLDER="backups_tmp"
MYSQL_ROOT_PASS="root"

## Check if archive is linked as option
if [[ $1 == "" ]]; then
  echo "tar.gz backup archive file is required as option" 2>&1
  echo "Usage: $0 <tar.gz backup archive file>" 2>&1
  exit 1
fi

## Check if root
if [[ $EUID -ne 0 ]]; then
  echo "You must be root user to run restore ECSS" 2>&1
  exit 1
fi

read -p "DO you really want to restore from backup all your ECSS-10 stuff??? [type 'YES' to confirm] " RESP

case "$RESP" in
  YES ) echo "Ok... I'll do it. But don't blame at me after that!";;
  * ) echo "You didn't want it." && exit 1 && echo "Yeah baby!";;  
esac

echo "Current folder is $CURRENT_FOLDER"

echo "Creating temp folder:"
mkdir -pv $TEMP_FOLDER/

echo "Extracting backup archive file..."
tar -zxpf $1 -C $TEMP_FOLDER
if [[ $? -ne 0 ]]; then
  echo "Failed to extract files from archive" 2>&1
  exit 1
fi
echo "done"
#mkdir -pv etc/ecss/
#mkdir -pv etc/default/
#mkdir -pv etc/init.d/
#mkdir -pv usr/lib/ecss/
#mkdir -pv var/lib/ecss/
#mkdir -pv run/ecss/
#mkdir -pv mysql_all/


#cp /etc/ecss 



echo "_________________________________"
echo ""
echo "     Restoring ECSS files"
echo "_________________________________"
# 
echo "Restoring ECSS configs..."
cp -a $TEMP_FOLDER/etc/ecss/.  /etc/ecss/
if [[ $? -ne 0 ]]; then
  echo "Failed to copy config files from backup" 2>&1
  exit 1
fi
# echo "Coping /etc/default/ecss* files..."
# cp -a /etc/default/ecss* etc/default/
# echo "Coping /etc/init.d/ecss* files..."
# cp -a /etc/init.d/ecss* etc/init.d/

echo "Restoring ECSS domains data..."
cp -a $TEMP_FOLDER/var/lib/ecss/. /var/lib/ecss/
if [[ $? -ne 0 ]]; then
  echo "Failed to copy files to /var/lib/ecss/ from backup" 2>&1
  exit 1
fi

# echo "Coping /usr/lib/ecss/ folder..."
# cp -a /usr/lib/ecss/. usr/lib/ecss/
# echo "Coping /run/ecss/ folder..."
# rm -rf /run/ecss/
# cp -a /run/ecss/. run/ecss/
# echo ""

echo "_________________________________"
echo ""
echo "       Restore MySQL DBs"
echo "_________________________________"
echo
echo "Restoring ECSS TC history DB..."
mysql -D history_db -o -uroot -p$MYSQL_ROOT_PASS < $TEMP_FOLDER/mysql_all/all_data.sql
if [[ $? -ne 0 ]]; then
  echo "Failed to restore this DB from backup" 2>&1
  exit 1
fi

echo "Restoring ECSS call trace DB..."
mysql -D ecss_call_trace -o -uroot -p$MYSQL_ROOT_PASS < $TEMP_FOLDER/mysql_all/all_data.sql
if [[ $? -ne 0 ]]; then
  echo "Failed to restore this DB from backup" 2>&1
  exit 1
fi

echo "Restoring ECSS statistics DB..."
mysql -D ecss_statistics -o -uroot -p$MYSQL_ROOT_PASS < $TEMP_FOLDER/mysql_all/all_data.sql
if [[ $? -ne 0 ]]; then
  echo "Failed to restore this DB from backup" 2>&1
  exit 1
fi

echo "Restoring ECSS call history DB..."
mysql -D ecss_calls_db -o -uroot -p$MYSQL_ROOT_PASS < $TEMP_FOLDER/mysql_all/all_data.sql
if [[ $? -ne 0 ]]; then
  echo "Failed to restore this DB from backup" 2>&1
  exit 1
fi

echo "Restoring ECSS subscribers DB..."
mysql -D ecss_subscribers -o -uroot -p$MYSQL_ROOT_PASS < $TEMP_FOLDER/mysql_all/all_data.sql
if [[ $? -ne 0 ]]; then
  echo "Failed to restore this DB from backup" 2>&1
  exit 1
fi

echo "Removing backup temp files..."
rm -rf $TEMP_FOLDER/

# ssw@ecss1:~/backups/3.7.0/mysql_all$ mysql -D history_db -o -uroot -proot < all_data.sql 
# mysql: [Warning] Using a password on the command line interface can be insecure.
# ssw@ecss1:~/backups/3.7.0/mysql_all$ mysql -D ecss_call_trace -o -uroot -proot < all_data.sql 
# mysql: [Warning] Using a password on the command line interface can be insecure.
# ssw@ecss1:~/backups/3.7.0/mysql_all$ mysql -D ecss_calls_db -o -uroot -proot < all_data.sql 
# mysql: [Warning] Using a password on the command line interface can be insecure.
# ssw@ecss1:~/backups/3.7.0/mysql_all$ mysql -D ecss_statistics -o -uroot -proot < all_data.sql 
# mysql: [Warning] Using a password on the command line interface can be insecure.
# ssw@ecss1:~/backups/3.7.0/mysql_all$ mysql -D ecss_statistics -o -uroot -proot < all_data.sql

#mysqldump -uroot -pssw -A < mysql_all/all_data.sql
# 
 echo ""
 echo "All done!"

exit 0
