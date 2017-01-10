#!/bin/bash
log=/var/ftp/scripts/log.txt
taxnos=/var/ftp/taxtest/CONFIG/taxno.txt
if [ ! -f $taxnos ]; then
  echo "cannot find taxno...,exit"
  exit 0
fi
num_no=`cat /var/ftp/taxtest/CONFIG/taxno.txt | wc -l`
if [  $num_no -eq 0 ]; then
#  echo "cannot find taxno in the config...exit"
  exit 0
fi
if [ ! -f /var/ftp/scripts/mk_inv.sh ]; then
  exit 0
fi
while read line
do
p_date=`date +%Y%m%d_%H%M%S`
echo "${p_date} :  produce ${line} inv...."
/var/ftp/scripts/mk_inv.sh $line
done < $taxnos
rm -rf $taxnos
