#!/bin/bash
#set -x
if [ $# -ne 1 ]; then
  echo "you must hava a param as taxno!"
  exit 0
fi
bak_dir=/var/ftp/bak/
file_dir=/var/ftp/taxtest/S/WORK/OUT/
bak_inv=${bak_dir}inv_all.txt
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
inv_dm=`date +%s`
inv_num=${inv_dm:0-8}
sn=`date +%s | md5sum | cut -d " " -f 1`
#20170105_91511000671418192F_402880bd5938fa3a01596c6d06ee3671_VAT_S_Inv.xml
filename="${date}_${tax_no}_${sn}_VAT_S_Inv.xml"
pieces_ran=${RANDOM:0-2:2}
let inv_pieces=${pieces_ran}
cl_inv_head='<?xml version="1.0" encoding="UTF-8"?><DATA><HEAD><TAXNO>'${tax_no}'</TAXNO><DATE>'${date}'</DATE><SN>'${sn}'</SN><TYPE>11</TYPE><TOTAL>'${inv_pieces}'</TOTAL><DQSKSSQ>'${month}'</DQSKSSQ><GXJZR>'$(date -d "-1 month ago" +%Y%m18)'</GXJZR><GXFW>'$(date -d "180 day ago `date +%Y%m01`" +%Y%m%d)'-'${month}"31"'</GXFW></HEAD><BODY>'
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
