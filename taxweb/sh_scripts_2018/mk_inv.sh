#!/bin/bash
#set -x
if [ $# -ne 1 ]; then
  echo "you must hava a param as taxno!"
  exit 0
fi
mk_flag=mking
bak_dir=/mnt/storage/bak/
file_dir=/mnt/storage/ftp/INV/S/WORK/C/
bak_inv=${bak_dir}inv_all.txt
mk_flag=mking
log=/mnt/storage/sh_scripts/taxnolog.txt
if [ -f $mk_flag ]; then
   echo "mking"
   exit 1
fi
touch $mk_flag 
if [ ! -d ${file_dir} ]; then
  mkdir -p ${file_dir}
fi
if [ ! -d ${bak_dir} ]; then
  mkdir -p ${bak_dir}
fi

tax_no=$1
date=`date +%Y%m%d`
inv_date=`date -d "3 day ago" +%Y%m%d`
month=`date +%Y%m`
inv_dm_pre=`date +%s%N`
inv_dm=5${inv_dm_pre:0-9}
inv_num=2${inv_dm:0-7}
sn=`cat /proc/sys/kernel/random/uuid | sed 's/-//g'`
filename="${date}_${tax_no}_${sn}_VAT_S_Inv.xml"
pieces_ran=$[RANDOM%100]
inv_time=`date +%Y%m%d-%H:%M:%S`
echo "inv amount: ${inv_time} $tax_no $pieces_ran">>$log
let inv_pieces=${pieces_ran}
cl_inv_head='<?xml version="1.0" encoding="UTF-8"?><DATA><HEAD><TAXNO>'${tax_no}'</TAXNO><DATE>'${date}'</DATE><SN>'${sn}'</SN><TYPE>11</TYPE><TOTAL>'${inv_pieces}'</TOTAL><DQSKSSQ>'${month}'</DQSKSSQ><GXJZR>'$(date -d "-1 month ago" +%Y%m15)'</GXJZR><GXFW>'$(date -d "360 day ago `date +%Y%m01`" +%Y%m%d)'-'$(date -d"$(date -d"1 month" +"%Y%m01") -1 day" +"%Y%m%d")'</GXFW></HEAD><BODY>'
cl_inv_body=''
echo ${cl_inv_head}>>${bak_inv}
for((i=0;i<${inv_pieces};i++))
do
let pic_no=${i}+1
inv_body='<INV><NO>'${pic_no}'</NO><FPLX>01</FPLX><FPDM>'${inv_dm}'</FPDM><FPHM>'${inv_num}'</FPHM><KPRQ>'${inv_date}'</KPRQ><GFSBH>'${tax_no}'</GFSBH><XFMC>测试数据有限公司</XFMC><XFSBH>8888888888888888</XFSBH><FPJE>471.7</FPJE><FPSE>28.3</FPSE><FPZT>0</FPZT><SFYGX>0</SFYGX><SFRZ>0</SFRZ><RZRQ></RZRQ><SKSSQ></SKSSQ></INV>'
((inv_num=$inv_num+1))
echo ${inv_body}>>${bak_inv}
cl_inv_body="${cl_inv_body}""${inv_body}"
done
cl_inv_end='</BODY></DATA>'
echo ${cl_inv_end}>>${bak_inv}
#echo ${cl_inv_head}${cl_inv_body}${cl_inv_end}
echo ${cl_inv_head}${cl_inv_body}${cl_inv_end} >${file_dir}${filename}
rm -rf $mk_flag
