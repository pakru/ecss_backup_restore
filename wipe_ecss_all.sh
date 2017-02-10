#!/bin/bash

CURRENT_FOLDER=$(pwd)

## Check if root
if [[ $EUID -ne 0 ]]; then
  echo "You must be root to run wipe ECSS" 2>&1
  exit 1
fi

read -p "DO you really want to erase all your ECSS-10 stuff??? [type 'YES' to confirm] " RESP

case "$RESP" in
  YES ) echo "Ok... I'll do it. But dont blame at me after that.";;
  * ) echo "You didn't want it." && exit 1 && echo "Yeah baby!";;  
esac



# echo "Current folder is $CURRENT_FOLDER"

#echo "Creating folders:"

#mkdir -pv etc/ecss/
#mkdir -pv etc/default/
#mkdir -pv etc/init.d/
#mkdir -pv usr/lib/ecss/
#mkdir -pv var/lib/ecss/
#mkdir -pv run/ecss/
#mkdir -pv mysql_all/


#cp /etc/ecss 



# echo "_________________________________"
# echo ""
# echo "Coping all files:"
# 
# echo "Coping /etc/ecss/ folder..."
# cp -a /etc/ecss/. etc/ecss/
# echo "Coping /etc/default/ecss* files..."
# cp -a /etc/default/ecss* etc/default/
# echo "Coping /etc/init.d/ecss* files..."
# cp -a /etc/init.d/ecss* etc/init.d/

rm -rf /var/lib/ecss/
# echo "Coping /var/lib/ecss/ folder..."
# cp -a /var/lib/ecss/. var/lib/ecss/
# echo "Coping /usr/lib/ecss/ folder..."
# cp -a /usr/lib/ecss/. usr/lib/ecss/
# echo "Coping /run/ecss/ folder..."
# rm -rf /run/ecss/
# cp -a /run/ecss/. run/ecss/
# echo ""
# 
# echo "Dump all mysql DBs..."
# #mysqldump -uroot -pssw -A > mysql_all/all_data.sql
# 
 echo ""
 echo "All done!"

exit 0
