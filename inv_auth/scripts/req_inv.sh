#!/bin/bash
#cd /var/ftp/scripts
rm -rf inv.txt
rm -rf this.xml
rm -rf *_au.txt
#set -x
bak_dir=/var/ftp/bak/
bak_inv=${bak_dir}inv_all.txt
req_bak_dir=/var/ftp/bak/req/
log_dir=/var/ftp/scripts/
log=${log_dir}log.txt
to_dir=/var/ftp/taxtest/INV/A/WORK/C/
au_dir=/var/ftp/bak/au/
inv_src_dir=/var/ftp/taxtest/INV_CONFIRM_5/A/WORK/B/
#au_dir=/var/ftp/taxtest/INV/R/WORK/C/
if [ ! -d $bak_dir ]; then
  mkdir $bak_dir
fi
if [ ! -d $au_dir ]; then
  mkdir $au_dir
fi
if [ ! -d $to_dir ]; then
  mkdir $to_dir
fi
if [ ! -d $log_dir ]; then
  mkdir $log_dir
fi
if [ ! -d ${inv_src_dir} ]; then
  echo "cannot find inv_src...exit!">>$log
  exit 0
fi
arr=`find ${inv_src_dir} -name "*.xml" -printf "%p\n"`
arr_len=`find ${inv_src_dir} -name "*.xml" -printf "%p\n" | wc -l`
if [ $arr_len -eq 0 ]; then
  exit 0
else
  lg_date=`date +%Y%m%d_%H%M%S`
  echo $ln_date":  find taxno,begin to product invs...">>$log
fi
for ar in ${arr[@]}
do
  req_full_name=${ar##*/}
  req_file_name=${req_full_name%.*}
  to_req_file=${to_dir}${req_file_name}"_Result.xml"
  tax_no=`echo ${req_file_name} | cut -d "_" -f 2`
  date=`date +%Y%m%d`
#  echo "req_full_name: ${req_full_name} req_file_name: ${req_file_name} to_req_file: ${to_req_file} tax_no: ${tax_no}"
#  read -p "press enter to continue...."
  cat "${ar}" | grep -e "<NO" -e "FPDM" -e "FPHM" | sed 's/<FPDM>//g' | sed 's/<FPHM>//g' | sed 's/<\/FPDM>//g' | sed 's/<\/FPHM>//g' | sed 's/	//g' | sed 's/ //g' >this.xml
  dos2unix this.xml>/dev/null 2>&1
  ch_line=`cat this.xml | wc -l`
  if [  $ch_line -eq 0 ]; then
    echo "cannot find inv in  req...exit">>$log
    break
  fi
  ((ch_flag=$ch_line%3))
  if [ $ch_flag -ne 0 ]; then
    echo "tha param is wrong!">>$log
    rm -rf this.xml
    #mv
    break 1
  fi
  awk '/^<NO/{print "";next} {printf $0","}' this.xml | sed 's/,$/\n/g' | sed '/^$/d' >inv.txt
  inv_pieces=`cat inv.txt | wc -l`
#  echo "${inv_pieces}"
#  read -p "inv_pieces is not null? and press enter to continue...."
  
  req_sn=`date +%s | md5sum | cut -d " " -f 1`
  req_inv_head='<?xml version="1.0" encoding="UTF-8"?><DATA><HEAD><TAXNO>'${tax_no}'</TAXNO><DATE>'${date}'</DATE><SN>'${req_sn}'</SN><TYPE>22</TYPE><TOTAL>'${inv_pieces}'</TOTAL><RESULT>1</RESULT><CODE>0</CODE></HEAD><BODY>'
  req_inv_body=''
  req_num=0
# 处理结果 CLJG:  1-成功 2-无此票 3-该票异常无法认证 4-该票已经认证 5-该票已经逾期无法认证 6-该票已经申请认证 7-申请认证月份已过期 8-其它异常
# return the result of the selection!
  while read line
  do
  inv_kind=`echo $line | cut -d "," -f 1`
  inv_num=`echo $line | cut -d "," -f 2`
  inv_cj=${inv_num:0-1:1}
  case ${inv_cj} in
    2)
      cljg=2
      ;;
    3)
      cljg=3
      ;;
    4)
      cljg=4
      ;;
    5)
      cljg=5
      ;;
    6)
      cljg=6
      ;;
    7)
      cljg=7
      ;;
    8)
      cljg=8
      ;;
    *)
      cljg=1
      echo "${inv_kind},${inv_num}">>"${req_file_name}_au.txt"
      ;;
  esac
  ((req_num=${req_num}+1))
  req_body='<INV><NO>'${req_num}'</NO><FPDM>'${inv_kind}'</FPDM><FPHM>'${inv_num}'</FPHM><CLJG>'${cljg}'</CLJG></INV>'
  req_inv_body="${req_inv_body}""${req_body}"
  done <inv.txt
  rm -rf inv.txt
  rm -rf this.xml
  req_inv_end='</BODY></DATA>'
#  echo "save file to"${to_req_file}
  echo ${req_inv_head}${req_inv_body}${req_inv_end} >${to_req_file}
  mv $ar "${req_bak_dir}"${req_full_name}

  if [ -f "${req_file_name}_au.txt" ]; then
  #    echo "cannot find au.txt...exit" 
    au_pieces=`cat "${req_file_name}_au.txt" | wc -l`
    if [ $inv_pieces -eq 0 ]; then
      echo "cannot find inv to authrize...exit">>$log
      break
    fi
    au_sn=`echo -n ${req_file_name} | md5sum | cut -d " " -f 1`
    au_inv_head='<?xml version="1.0" encoding="UTF-8"?><DATA><HEAD><TAXNO>'${tax_no}'</TAXNO><DATE>'${date}'</DATE><SN>'${au_sn}'</SN><TYPE>31</TYPE><TOTAL>'${au_pieces}'</TOTAL></HEAD><BODY>'
    au_inv_body=''
    month=`date +%Y%m`
    au_pic_num=0
    while read line
    do
    au_kind=`echo $line | cut -d "," -f 1`
    au_num=`echo $line | cut -d "," -f 2`
    if [ -f $bak_inv ]; then
      wc_bakinv=`cat $bak_inv | grep ${au_num} | wc -l`
      if [ $wc_bakinv -eq 1 ]; then
        inv_date=`cat $bak_inv | grep ${au_num} | sed 's/.*<KPRQ>\([0-9]*\)<\/KPRQ>.*/\1/g'`
      fi
    else
      inv_date=`date -d "3 day ago" +%Y%m%d`
    fi
   ((au_pic_num=${au_pic_num}+1))
  #  echo "num is "${num}
   # au_body='<INV><NO>'${num}'</NO><FPLX>01</FPLX><FPDM>'${inv_kind}'</FPDM><FPHM>'${inv_num}'</FPHM><KPRQ>'${inv_date}'</KPRQ><GFSBH>'${tax_no}'</GFSBH><XFSBH>8888888888888888</XFSBH><FPJE>471.7</FPJE><FPSE>28.3</FPSE><FPZT>0</FPZT><SFRZ>1</SFRZ><RZRQ>'${date}'</RZRQ><SKSSQ>'${date +%Y%m}'</SKSSQ><RZFS>1</RZFS></INV>'
    au_body='<INV><NO>'${au_pic_num}'</NO><FPLX>01</FPLX><FPDM>'${au_kind}'</FPDM><FPHM>'${au_num}'</FPHM><KPRQ>'${inv_date}'</KPRQ><GFSBH>'${tax_no}'</GFSBH><XFSBH>8888888888888888</XFSBH><FPJE>471.7</FPJE><FPSE>28.3</FPSE><FPZT>0</FPZT><SFRZ>1</SFRZ><RZRQ>'${date}'</RZRQ><SKSSQ>'${month}'</SKSSQ><RZFS>1</RZFS></INV>'
    au_inv_body="${au_inv_body}${au_body}"
    done < ${req_file_name}_au.txt
    #rm -rf au.txt
    au_inv_end='</BODY></DATA>'
    to_au_file="${au_dir}""${date}_${tax_no}_${au_sn}_VAT_R_Inv.xml"
  #  echo "save the aufile to "${to_au_file}
    echo ${au_inv_head}${au_inv_body}${au_inv_end} >${to_au_file}
  fi
done
rm -rf *_au.txt
