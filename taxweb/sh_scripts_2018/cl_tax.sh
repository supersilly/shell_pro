#!/bin/bash
if [ -f mking ]; then
  echo "taxno is already making"
  exit 1
fi
log=/mnt/storage/sh_scripts/log.txt
taxnos=/mnt/storage/ftp/CONFIG/taxno.txt
if [ ! -f $taxnos ]; then
  echo "cannot find taxno...,exit"
  exit 0
fi
num_no=`cat ${taxnos} | wc -l`
if [  $num_no -eq 0 ]; then
#  echo "cannot find taxno in the config...exit"
  exit 0
fi
if [ ! -f /mnt/storage/sh_scripts/mk_inv.sh ]; then
  exit 0
fi
while read line
do
p_date=`date +%Y%m%d_%H%M%S`
echo "${p_date} :  produce ${line} inv...."
/mnt/storage/sh_scripts/mk_inv.sh $line
done < $taxnos
rm -rf $taxnos
