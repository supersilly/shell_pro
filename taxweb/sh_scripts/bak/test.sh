#!/bin/bash
#set -x
taxno="91440300715295906K"
mysqlsh="mysql -h rm-2ze0sqz4c983ome2q.mysql.rds.aliyuncs.com -uroot -p5QDXBquW"
rel=`cat home`
key3=`echo $rel | sed 's/\(.*\)"key3":"\(.*\)","key4".*/\2/g'`
key6=`echo $rel | sed 's/\(.*\)"key6":"\(.*\)".*/\2/g'`
#echo "rq_q $rq_q  rq_z $rq_z"
#echo "key3"$key3
if [  ! -n "$key3" ]; then
  echo "token is out of date!"
  exit 1
fi
#echo $key3
#echo $key6
rq_q=${key6:0:4}"-"${key6:4:2}"-"${key6:6:2}
rq_z=${key6:9:4}"-"${key6:13:2}"-"${key6:15:2}
echo "可勾选日期范围:${rq_q}到${rq_z}"
sqltax='"'${taxno}'"'
invdate_q='"'${rq_q}'"'
invdate_z='"'${rq_z}'"'
#rel_all=`echo $key3 | sed 's/=/  /g' | sed 's/[0-9];/ /g'` 
#rel_all=(`echo $key3 | sed 's/=[0-9];/\n/g' | sed 's/=/  /g'`)
rel_all=(`echo $key3 | egrep -o "2017[^;]*;"`)

#echo "$taxno all info(税局数据):"
for rel in "${rel_all[@]}"
do
#echo "${rel}"
inv_month=`echo ${rel} | awk -F"=" '{print $1}'`
inv_web_amount=`echo ${rel} | awk -F"=" '{print $2}'`
inv_web_vat=`echo ${rel} | awk -F"=" '{print $3}'`
#echo ${inv_month}"---"${inv_web_amount}"---"${inv_web_vat}
sql1="SELECT income_month,COUNT(1),SUM(inv_vat) FROM scm.t_scm_vat_main WHERE buyer_taxno=${sqltax} AND income_month=${inv_month} GROUP BY income_month;"
rel1=`$mysqlsh -s -e "${sql1}" 2>/dev/null`
#echo ${rel1}
inv_sql_amount=`echo ${rel1} | awk -F" " '{print $2}'`
inv_sql_vat=`echo ${rel1} | awk -F" " '{print $3}'`
echo -n "${inv_month} taxweb ${inv_web_amount} ${inv_web_vat} mysql ${inv_sql_amount} ${inv_sql_vat}"
if [ `echo "${inv_web_amount}" - "${inv_sql_amount}" | bc ` = 0 ]; then echo -n " amount_same"; else echo -n " amount_different"; fi
if [ `echo "${inv_web_vat}" - "${inv_sql_vat}" | bc ` = 0 ]; then echo " vat_same"; else echo  " vat_different"; fi
done
