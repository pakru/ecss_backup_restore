#!/bin/bash

CURRENT_FOLDER=$(pwd)

## Check if root
if [[ $EUID -ne 0 ]]; then
  echo "You must be root to backup ECSS" 2>&1
  exit 1
fi

DATE=$(date --rfc-3339='seconds' | cut -d ' ' -f 1)
TIME_H=$(date --rfc-3339='seconds' | cut -d ' ' -f 2 | cut -d '+' -f 1 | cut -d ':' -f 1)
TIME_M=$(date --rfc-3339='seconds' | cut -d ' ' -f 2 | cut -d '+' -f 1 | cut -d ':' -f 2)
TIME=$TIME_H-$TIME_M
BACKUP_FILENAME=${DATE}_${TIME}.tar.gz   # The name of backup archive


echo "Current folder is $CURRENT_FOLDER"

echo "Creating folders:"

# mkdir -pv etc/ecss/
# mkdir -pv etc/default/
# mkdir -pv etc/init.d/
# mkdir -pv usr/lib/ecss/
# mkdir -pv var/lib/ecss/
# mkdir -pv run/ecss/
mkdir -pv mysql_all/


#cp /etc/ecss 

echo "_________________________________"
echo ""
echo "Dump all mysql DBs..."
mysqldump -uroot -pssw -A > mysql_all/all_data.sql

echo "Coping all files:"
#tar -czf $BACKUP_FILENAME /etc/ecss /etc/default/ecss* /etc/init.d/ecss* /var/lib/ecss /usr/lib/ecss mysql_all
tar -czf $BACKUP_FILENAME /etc/ecss /etc/default/ecss* /etc/init.d/ecss* /var/lib/ecss /usr/lib/ecss mysql_all

# echo "Coping /etc/ecss/ folder..."
# cp -a /etc/ecss/. etc/ecss/
# echo "Coping /etc/default/ecss* files..."
# cp -a /etc/default/ecss* etc/default/
# echo "Coping /etc/init.d/ecss* files..."
# cp -a /etc/init.d/ecss* etc/init.d/
# echo "Coping /var/lib/ecss/ folder..."
# cp -a /var/lib/ecss/. var/lib/ecss/
# echo "Coping /usr/lib/ecss/ folder..."
# cp -a /usr/lib/ecss/. usr/lib/ecss/
# echo "Coping /run/ecss/ folder..."
# cp -a /run/ecss/. run/ecss/
# echo ""
# 
echo "Removing temp files..."
rm -rf mysql_all/

echo ""
echo "All done!"

exit 0
