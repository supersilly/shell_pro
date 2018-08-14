#!/bin/bash
#set -x
au_from_dir=/mnt/storage/bak/au/
au_to_dir=/mnt/storage/ftp/INV/R/WORK/C/
req_fb_dir=/mnt/storage/ftp/INV/A/WORK/C/
log_dir=/mnt/storage/sh_scripts/
log=${log_dir}log.txt
if [ ! -d ${log_dir}  ]; then
  mkdir ${log_dir}
fi
if [ ! -d ${au_from_dir}  ]; then
  echo "no authrized inv to move,exit...">>$log
  exit 0
fi
if [ ! -d ${au_to_dir}  ]; then
  echo "wrong authrized inv_dir place,please verify!exit...">>$log
  exit
fi
fd=`find ${au_from_dir} -name "*.xml" -printf "%p\n" | cut -d "_" -f 2 | sort | uniq`
len_fd=`find ${au_from_dir} -name "*.xml" -printf "%p\n" | cut -d "_" -f 2 | sort | uniq | wc -l`
#echo "len_fd is "${len_fd}
if [ $len_fd -eq 0 ]; then
  exit 0
else
  echo "taxno ${fd}  ready to move...">>$log
#  echo "${fd[@]}"
fi
#echo "length of fd is "${len_fd}
for td in ${fd[@]}
do
is_tomv=`find ${req_fb_dir} -name "*.xml" -printf "%p\n" | grep ${td} | wc -l`
if [ ${is_tomv} -eq 0 ]; then
  echo "move taxno ${td} file to ${au_to_dir}">>$log
  mvfile=${au_from_dir}"*"${td}"*.xml"
  mv $mvfile  ${au_to_dir}
fi
done
