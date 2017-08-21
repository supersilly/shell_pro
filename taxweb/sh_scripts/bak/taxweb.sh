#!/bin/bash
#set -x
taxno=$1
zone=$2
token=`sh getToken.sh $1 $2`
da=`date +%s%N`
rand=${da:0:13}
mysqlsh="mysql -h rm-2ze0sqz4c983ome2q.mysql.rds.aliyuncs.com -uroot -p5QDXBquW"
#mysqlsh="mysql -h 127.0.0.1 -uhuawei -pBwHua##2017"

case $2 in

  1100)
      url='https://fpdk.bjsat.gov.cn/'
    ;;
  1200)
      url='https://fpdk.tjsat.gov.cn/'
    ;;
  1300)
      url='https://fpdk.he-n-tax.gov.cn:81/'
    ;;
  1400)
      url='https://fpdk.tax.sx.cn/'
    ;;
  1500)
      url='https://fpdk.nm-n-tax.gov.cn/'
    ;;
  2100)
      url='https://fpdk.tax.ln.cn/'
    ;;
  2102)
      url='https://fpdk.dlntax.gov.cn/'
    ;;
  2200)
      url='https://fpdk.jl-n-tax.gov.cn:4431/'
    ;;
  2300)
      url='https://fpdk.hl-n-tax.gov.cn/'
    ;;
  3100)
      url='https://fpdk.tax.sh.gov.cn/'
    ;;
  3200)
      url='https://fpdk.jsgs.gov.cn:81/'
    ;;
  3300)
      url='https://fpdk.zjtax.gov.cn/'
    ;;
  3302)
      url='https://fpdk.nb-n-tax.gov.cn/'
    ;;
  3400)
      url='https://fpdk.ah-n-tax.gov.cn/'
    ;;
  3500)
      url='https://fpdk.fj-n-tax.gov.cn/'
    ;;
  3502)
      url='https://fpdk.xm-n-tax.gov.cn/'
    ;;
  3600)
      url='https://fpdk.jxgs.gov.cn/'
    ;;
  3700)
      url='https://fpdk.sd-n-tax.gov.cn/'
    ;;
  3702)
      url='https://fpdk.qd-n-tax.gov.cn/'
    ;;
  4100)
      url='https://fpdk.ha-n-tax.gov.cn/'
    ;;
  4200)
      url='https://fpdk.hb-n-tax.gov.cn/'
    ;;
  4300)
      url='https://fpdk.hntax.gov.cn/'
    ;;
  4400)
      url='https://fpdk.gd-n-tax.gov.cn/'
    ;;
  4403)
      url='https://fpdk.szgs.gov.cn/'
    ;;
  4500)
      url='https://fpdk.gxgs.gov.cn/'
    ;;
  4600)
      url='https://fpdk.hitax.gov.cn/'
    ;;
  5000)
      url='https://fpdk.cqsw.gov.cn/'
    ;;
  5100)
      url='https://fpdk.sc-n-tax.gov.cn/'
    ;;
  5200)
      url='https://fpdk.gz-n-tax.gov.cn/'
    ;;
  5300)
      url='https://fpdk.yngs.gov.cn/'
    ;;
  5400)
      url='https://fpdk.xztax.gov.cn/'
    ;;
  6100)
      url='https://fprzweb.sn-n-tax.gov.cn/'
    ;;
  6200)
      url='https://fpdk.gs-n-tax.gov.cn/'
    ;;
  6300)
      url='http://fpdk.qh-n-tax.gov.cn/'
    ;;
  6400)
      url='https://fpdk.nxgs.gov.cn/'
    ;;
  6500)
      url='https://fpdk.xj-n-tax.gov.cn/'
    ;;
  *)
      echo "error zone code!"
      exit
    ;;
esac



rel=`curl -s -k "${url}/SbsqWW/qrgycx.do?callback=jQuery110206540922571677747_1495246360383&cert=${taxno}&token=${token}&ymbb=3.0.09&rznf=&_=${rand}"`
#echo $rel
key3=`echo $rel | sed 's/\(.*\)"key3":"\(.*\)","key4".*/\2/g'`
key6=`echo $rel | sed 's/\(.*\)"key6":"\(.*\)".*/\2/g'`

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
rel_all=(`echo $key3 | egrep -o "2017[^;]*;" | sed 's/;//g'`)
#echo "--------------"
#echo "rel_all:""${rel_all[@]}"
#echo "--------------"
echo "已抵扣数据："
for rel in "${rel_all[@]}"
do
#echo "rel: ${rel}"
inv_month=`echo ${rel} | awk -F"=" '{print $1}'`
inv_web_amount=`echo ${rel} | awk -F"=" '{print $2}'`
inv_web_vat=`echo ${rel} | awk -F"=" '{print $3}'`
#echo ${inv_month}"---"${inv_web_amount}"---"${inv_web_vat}
sql_old="SELECT income_month,COUNT(1),SUM(inv_vat) FROM scm.t_scm_vat_main WHERE buyer_taxno=${sqltax} AND income_month=${inv_month};"
rel_old=`${mysqlsh} -s -e "${sql_old}" 2>/dev/null | grep -v "COUNT"`
#echo ${rel_old}
inv_sql_amount=`echo ${rel_old} | awk -F" " '{print $2}'`
inv_sql_vat=`echo ${rel_old} | awk -F" " '{print $3}'`
echo -n "${inv_month} taxweb ${inv_web_amount} ${inv_web_vat} mysql ${inv_sql_amount} ${inv_sql_vat}"
if [ "${inv_web_amount}" = "" ]; then echo ""; continue; fi
#if [ "${inv_sql_amount}" = "" ]; then inv_sql_amount=0; inv_sql_vat=0; fi
#if [[ ${inv_sql_amount} = 0 ]]; then inv_sql_amount=0; inv_sql_vat=0; fi
#echo "inv_web_amount  ${inv_web_amount}"
#echo "inv_web_vat ${inv_web_vat}"
#echo "inv_sql_amount ${inv_sql_amount}"
#echo "inv_sql_vat  ${inv_sql_vat}"
if [ `echo "${inv_web_amount}" - "${inv_sql_amount}" | bc ` = 0 ]; then echo -n " amount_same"; else echo -n " amount_different"; fi
if [ `echo "${inv_web_vat}" - "${inv_sql_vat}" | bc ` = 0 ]; then echo " vat_same"; else echo  " vat_different"; fi
done
sql_ok="SELECT COUNT(1) FROM scm.t_scm_vat_main WHERE buyer_taxno=${sqltax}"' AND inv_type="0" AND inv_dedu_result="0" and inv_status ="0" and inv_date >= '"${invdate_q}  and inv_date <= ${invdate_z};"
sql_loseCtl="SELECT COUNT(1) FROM scm.t_scm_vat_main WHERE buyer_taxno=${sqltax}"' AND inv_type="0" AND inv_dedu_result="0" and inv_status ="1" and inv_date >= '"${invdate_q}  and inv_date <= ${invdate_z};"
sql_cancel="SELECT COUNT(1) FROM scm.t_scm_vat_main WHERE buyer_taxno=${sqltax}"' AND inv_type="0" AND inv_dedu_result="0" and inv_status ="2" and inv_date >= '"${invdate_q}  and inv_date <= ${invdate_z};"
sql_red="SELECT COUNT(1) FROM scm.t_scm_vat_main WHERE buyer_taxno=${sqltax}"' AND inv_type="0" AND inv_dedu_result="0" and inv_status ="3" and inv_date >= '"${invdate_q}  and inv_date <= ${invdate_z};"
sql_except="SELECT COUNT(1) FROM scm.t_scm_vat_main WHERE buyer_taxno=${sqltax}"' AND inv_type="0" AND inv_dedu_result="0" and inv_status ="4" and inv_date >= '"${invdate_q}  and inv_date <= ${invdate_z};"

rel_ok=`${mysqlsh} -s -e "${sql_ok}" 2>/dev/null | grep -v "COUNT"`
#echo "rel_ok${rel_ok}"
rel_loseCtl=`${mysqlsh} -s -e "${sql_loseCtl}" 2>/dev/null | grep -v "COUNT"`
#echo "rel_loseCtl${rel_loseCtl}"
rel_cancel=`${mysqlsh} -s -e "${sql_cancel}" 2>/dev/null | grep -v "COUNT"`
#echo "rel_cancel${rel_cancel}"
rel_red=`${mysqlsh} -s -e "${sql_red}" 2>/dev/null | grep -v "COUNT"`
#echo "rel_red${rel_red}"
rel_except=`${mysqlsh} -s -e "${sql_except}" 2>/dev/null | grep -v "COUNT"`
#echo "rel_except${rel_except}"
((rel_sum=${rel_ok}+${rel_loseCtl}+${rel_red}+${rel_except}))
#echo "rel_sum${rel_sum}"

echo "可勾选数据： "
for s in "-1" 0 1 2 3 4
do
  case $s in
    "-1")
      new_data=`curl -s -k -d 'callback=jQuery110207221137385636902_1495251706357&fpdm=&fphm=&rq_q='${rq_q}'&rq_z='${rq_z}'&xfsbh=&rzfs=&rzzt=0&gxzt=-1&fpzt='${s}'&fplx=-1&cert='${taxno}'&token='${token}'&aoData=[{"name":"sEcho","value":1},{"name":"iColumns","value":14},{"name":"sColumns","value":",,,,,,,,,,,,,"},{"name":"iDisplayStart","value":0},{"name":"iDisplayLength","value":5},{"name":"mDataProp_0","value":0},{"name":"mDataProp_1","value":1},{"name":"mDataProp_2","value":2},{"name":"mDataProp_3","value":3},{"name":"mDataProp_4","value":4},{"name":"mDataProp_5","value":5},{"name":"mDataProp_6","value":6},{"name":"mDataProp_7","value":7},{"name":"mDataProp_8","value":8},{"name":"mDataProp_9","value":9},{"name":"mDataProp_10","value":10},{"name":"mDataProp_11","value":11},{"name":"mDataProp_12","value":12},{"name":"mDataProp_13","value":13}]&ymbb=3.0.09&_=1495251706358' "${url}/SbsqWW/gxcx.do" | iconv -f GBK -t UTF-8`
      all_num=`echo $new_data | awk -F '"iTotalRecords":' '{print $2}' | cut -d"," -f 1`
      if [ ! -n "$all_num" ]; then
        echo "token is out of date!"
        exit 1
      fi
      if [ `echo "${all_num}-${rel_sum}" | bc` -eq 0 ]; then
        echo "全部 $all_num  same!";
      else
        echo "全部 webtax : ${all_num}  mysql : ${rel_sum} different!";  
      fi
    ;;
    0)
      new_data=`curl -s -k -d 'callback=jQuery110207221137385636902_1495251706357&fpdm=&fphm=&rq_q='${rq_q}'&rq_z='${rq_z}'&xfsbh=&rzfs=&rzzt=0&gxzt=-1&fpzt='${s}'&fplx=-1&cert='${taxno}'&token='${token}'&aoData=[{"name":"sEcho","value":1},{"name":"iColumns","value":14},{"name":"sColumns","value":",,,,,,,,,,,,,"},{"name":"iDisplayStart","value":0},{"name":"iDisplayLength","value":5},{"name":"mDataProp_0","value":0},{"name":"mDataProp_1","value":1},{"name":"mDataProp_2","value":2},{"name":"mDataProp_3","value":3},{"name":"mDataProp_4","value":4},{"name":"mDataProp_5","value":5},{"name":"mDataProp_6","value":6},{"name":"mDataProp_7","value":7},{"name":"mDataProp_8","value":8},{"name":"mDataProp_9","value":9},{"name":"mDataProp_10","value":10},{"name":"mDataProp_11","value":11},{"name":"mDataProp_12","value":12},{"name":"mDataProp_13","value":13}]&ymbb=3.0.09&_=1495251706358' "${url}/SbsqWW/gxcx.do" | iconv -f GBK -t UTF-8`
      ok_num=`echo $new_data | awk -F '"iTotalRecords":' '{print $2}' | cut -d"," -f 1`
      if [ ! -n "$ok_num" ]; then
        echo "token is out of date!"
        exit 1
      fi
      if [ `echo "${ok_num}-${rel_ok}" | bc ` -eq 0 ]; then
        echo "正常 $ok_num  same!";
      else
        echo "正常 webtax : ${ok_num}  mysql : ${rel_ok} different!";
      fi
    ;;
    1)
      new_data=`curl -s -k -d 'callback=jQuery110207221137385636902_1495251706357&fpdm=&fphm=&rq_q='${rq_q}'&rq_z='${rq_z}'&xfsbh=&rzfs=&rzzt=0&gxzt=-1&fpzt='${s}'&fplx=-1&cert='${taxno}'&token='${token}'&aoData=[{"name":"sEcho","value":1},{"name":"iColumns","value":14},{"name":"sColumns","value":",,,,,,,,,,,,,"},{"name":"iDisplayStart","value":0},{"name":"iDisplayLength","value":5},{"name":"mDataProp_0","value":0},{"name":"mDataProp_1","value":1},{"name":"mDataProp_2","value":2},{"name":"mDataProp_3","value":3},{"name":"mDataProp_4","value":4},{"name":"mDataProp_5","value":5},{"name":"mDataProp_6","value":6},{"name":"mDataProp_7","value":7},{"name":"mDataProp_8","value":8},{"name":"mDataProp_9","value":9},{"name":"mDataProp_10","value":10},{"name":"mDataProp_11","value":11},{"name":"mDataProp_12","value":12},{"name":"mDataProp_13","value":13}]&ymbb=3.0.09&_=1495251706358' "${url}/SbsqWW/gxcx.do" | iconv -f GBK -t UTF-8`
      nc_num=`echo $new_data | awk -F '"iTotalRecords":' '{print $2}' | cut -d"," -f 1`
      if [ ! -n "$nc_num" ]; then
        echo "token is out of date!"
        exit 1
      fi
      if [ `echo "${nc_num} - ${rel_loseCtl}" | bc ` -eq 0 ]; then
        echo "正常 $nc_num  same!";
      else
        echo "正常 webtax : ${nc_num}  mysql : ${rel_loseCtl} different!";
      fi
    ;;   
   2)
      new_data=`curl -s -k -d 'callback=jQuery110207221137385636902_1495251706357&fpdm=&fphm=&rq_q=2016-11-02&rq_z=2017-05-31&xfsbh=&rzfs=&rzzt=0&gxzt=-1&fpzt='${s}'&fplx=-1&cert='${taxno}'&token='${token}'&aoData=[{"name":"sEcho","value":1},{"name":"iColumns","value":14},{"name":"sColumns","value":",,,,,,,,,,,,,"},{"name":"iDisplayStart","value":0},{"name":"iDisplayLength","value":5},{"name":"mDataProp_0","value":0},{"name":"mDataProp_1","value":1},{"name":"mDataProp_2","value":2},{"name":"mDataProp_3","value":3},{"name":"mDataProp_4","value":4},{"name":"mDataProp_5","value":5},{"name":"mDataProp_6","value":6},{"name":"mDataProp_7","value":7},{"name":"mDataProp_8","value":8},{"name":"mDataProp_9","value":9},{"name":"mDataProp_10","value":10},{"name":"mDataProp_11","value":11},{"name":"mDataProp_12","value":12},{"name":"mDataProp_13","value":13}]&ymbb=3.0.09&_=1495251706358' "${url}/SbsqWW/gxcx.do" | iconv -f GBK -t UTF-8`
      cc_num=`echo $new_data | awk -F '"iTotalRecords":' '{print $2}' | cut -d"," -f 1`
      if [ ! -n "$cc_num" ]; then
        echo "token is out of date!"
        exit 1
      fi
      if [ `echo "${cc_num} - ${rel_cancel}" | bc ` -eq 0 ]; then
        echo "作废  $cc_num  same!";
      else
        echo "作废 webtax : ${cc_num}  mysql : ${rel_cancel} different!";
      fi
    ;;
    3)
      new_data=`curl -s -k -d 'callback=jQuery110207221137385636902_1495251706357&fpdm=&fphm=&rq_q=2016-11-02&rq_z=2017-05-31&xfsbh=&rzfs=&rzzt=0&gxzt=-1&fpzt='${s}'&fplx=-1&cert='${taxno}'&token='${token}'&aoData=[{"name":"sEcho","value":1},{"name":"iColumns","value":14},{"name":"sColumns","value":",,,,,,,,,,,,,"},{"name":"iDisplayStart","value":0},{"name":"iDisplayLength","value":5},{"name":"mDataProp_0","value":0},{"name":"mDataProp_1","value":1},{"name":"mDataProp_2","value":2},{"name":"mDataProp_3","value":3},{"name":"mDataProp_4","value":4},{"name":"mDataProp_5","value":5},{"name":"mDataProp_6","value":6},{"name":"mDataProp_7","value":7},{"name":"mDataProp_8","value":8},{"name":"mDataProp_9","value":9},{"name":"mDataProp_10","value":10},{"name":"mDataProp_11","value":11},{"name":"mDataProp_12","value":12},{"name":"mDataProp_13","value":13}]&ymbb=3.0.09&_=1495251706358' "${url}/SbsqWW/gxcx.do" | iconv -f GBK -t UTF-8`
      red_num=`echo $new_data | awk -F '"iTotalRecords":' '{print $2}' | cut -d"," -f 1`
      if [ ! -n "$red_num" ]; then
        echo "token is out of date!"
        exit 1
      fi
      if [ `echo "${red_num} - ${rel_red}" | bc ` -eq 0 ]; then
        echo "红冲 $red_num  same!";
      else
        echo "红冲 webtax : ${red_num}  mysql : ${rel_red} different!";
      fi
    ;;
   4)
      new_data=`curl -s -k -d 'callback=jQuery110207221137385636902_1495251706357&fpdm=&fphm=&rq_q=2016-11-02&rq_z=2017-05-31&xfsbh=&rzfs=&rzzt=0&gxzt=-1&fpzt='${s}'&fplx=-1&cert='${taxno}'&token='${token}'&aoData=[{"name":"sEcho","value":1},{"name":"iColumns","value":14},{"name":"sColumns","value":",,,,,,,,,,,,,"},{"name":"iDisplayStart","value":0},{"name":"iDisplayLength","value":5},{"name":"mDataProp_0","value":0},{"name":"mDataProp_1","value":1},{"name":"mDataProp_2","value":2},{"name":"mDataProp_3","value":3},{"name":"mDataProp_4","value":4},{"name":"mDataProp_5","value":5},{"name":"mDataProp_6","value":6},{"name":"mDataProp_7","value":7},{"name":"mDataProp_8","value":8},{"name":"mDataProp_9","value":9},{"name":"mDataProp_10","value":10},{"name":"mDataProp_11","value":11},{"name":"mDataProp_12","value":12},{"name":"mDataProp_13","value":13}]&ymbb=3.0.09&_=1495251706358' "${url}/SbsqWW/gxcx.do" | iconv -f GBK -t UTF-8`
      ept_num=`echo $new_data | awk -F '"iTotalRecords":' '{print $2}' | cut -d"," -f 1`
      if [ ! -n "$ept_num" ]; then
        echo "token is out of date!"
        exit 1
      fi
      if [ `echo "${ept_num} - ${rel_except}" | bc ` -eq 0 ]; then
        echo "异常 $ept_num  same!";
      else
        echo "异常 webtax : ${ept_num}  mysql : ${rel_except} different!";
      fi
  ;;
    *)
      echo "error param"
    ;;
   esac
done
exit
