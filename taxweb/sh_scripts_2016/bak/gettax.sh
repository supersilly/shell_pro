#!/bin/bash
set -x
taxno=$1
token=$2
da=`date +%s%N`
rand=${da:0:13}
mysqlsh="mysql -h rm-2ze0sqz4c983ome2q.mysql.rds.aliyuncs.com -uroot -p5QDXBquW"

case $3 in

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



rel=`curl -s -k "${url}/SbsqWW/qrgycx.do?callback=jQuery110206540922571677747_1495246360383&cert=$taxno&token=$token&ymbb=3.0.09&rznf=&_=$rand"`
#echo $rel
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
#rel_all=`echo $key3 | sed 's/=/  /g' | sed 's/[0-9];/ /g'` 
rel_all=`echo $key3 | sed 's/=[0-9];/\n/g' | sed 's/=/  /g'` 
echo "$taxno all info(税局数据):"
echo "${rel_all}"
echo "可勾选数据： "
for s in "-1" 0 1 2 3 4
do
  case $s in
    "-1")
      new_data=`curl -s -k -d 'callback=jQuery110207221137385636902_1495251706357&fpdm=&fphm=&rq_q='${rq_q}'&rq_z='${rq_z}'&xfsbh=&rzfs=&rzzt=0&gxzt=-1&fpzt='${s}'&fplx=-1&cert='${taxno}'&token='${token}'&aoData=[{"name":"sEcho","value":1},{"name":"iColumns","value":14},{"name":"sColumns","value":",,,,,,,,,,,,,"},{"name":"iDisplayStart","value":0},{"name":"iDisplayLength","value":50},{"name":"mDataProp_0","value":0},{"name":"mDataProp_1","value":1},{"name":"mDataProp_2","value":2},{"name":"mDataProp_3","value":3},{"name":"mDataProp_4","value":4},{"name":"mDataProp_5","value":5},{"name":"mDataProp_6","value":6},{"name":"mDataProp_7","value":7},{"name":"mDataProp_8","value":8},{"name":"mDataProp_9","value":9},{"name":"mDataProp_10","value":10},{"name":"mDataProp_11","value":11},{"name":"mDataProp_12","value":12},{"name":"mDataProp_13","value":13}]&ymbb=3.0.09&_=1495251706358' "${url}/SbsqWW/gxcx.do" | iconv -f GBK -t UTF-8`
      num=`echo $new_data | awk -F '"iTotalRecords":' '{print $2}' | cut -d"," -f 1`
      if [ ! -n "$num" ]; then
        echo "token is out of date!"
        exit 1
      fi
      echo "全部 $num"
    ;;
    0)
      new_data=`curl -s -k -d 'callback=jQuery110207221137385636902_1495251706357&fpdm=&fphm=&rq_q='${rq_q}'&rq_z='${rq_z}'&xfsbh=&rzfs=&rzzt=0&gxzt=-1&fpzt='${s}'&fplx=-1&cert='${taxno}'&token='${token}'&aoData=[{"name":"sEcho","value":1},{"name":"iColumns","value":14},{"name":"sColumns","value":",,,,,,,,,,,,,"},{"name":"iDisplayStart","value":0},{"name":"iDisplayLength","value":50},{"name":"mDataProp_0","value":0},{"name":"mDataProp_1","value":1},{"name":"mDataProp_2","value":2},{"name":"mDataProp_3","value":3},{"name":"mDataProp_4","value":4},{"name":"mDataProp_5","value":5},{"name":"mDataProp_6","value":6},{"name":"mDataProp_7","value":7},{"name":"mDataProp_8","value":8},{"name":"mDataProp_9","value":9},{"name":"mDataProp_10","value":10},{"name":"mDataProp_11","value":11},{"name":"mDataProp_12","value":12},{"name":"mDataProp_13","value":13}]&ymbb=3.0.09&_=1495251706358' "${url}/SbsqWW/gxcx.do" | iconv -f GBK -t UTF-8`
      num=`echo $new_data | awk -F '"iTotalRecords":' '{print $2}' | cut -d"," -f 1`
      if [ ! -n "$num" ]; then
        echo "token is out of date!"
        exit 1
      fi
      echo "正常 $num"
    ;;
    1)
      new_data=`curl -s -k -d 'callback=jQuery110207221137385636902_1495251706357&fpdm=&fphm=&rq_q='${rq_q}'&rq_z='${rq_z}'&xfsbh=&rzfs=&rzzt=0&gxzt=-1&fpzt='${s}'&fplx=-1&cert='${taxno}'&token='${token}'&aoData=[{"name":"sEcho","value":1},{"name":"iColumns","value":14},{"name":"sColumns","value":",,,,,,,,,,,,,"},{"name":"iDisplayStart","value":0},{"name":"iDisplayLength","value":50},{"name":"mDataProp_0","value":0},{"name":"mDataProp_1","value":1},{"name":"mDataProp_2","value":2},{"name":"mDataProp_3","value":3},{"name":"mDataProp_4","value":4},{"name":"mDataProp_5","value":5},{"name":"mDataProp_6","value":6},{"name":"mDataProp_7","value":7},{"name":"mDataProp_8","value":8},{"name":"mDataProp_9","value":9},{"name":"mDataProp_10","value":10},{"name":"mDataProp_11","value":11},{"name":"mDataProp_12","value":12},{"name":"mDataProp_13","value":13}]&ymbb=3.0.09&_=1495251706358' "${url}/SbsqWW/gxcx.do" | iconv -f GBK -t UTF-8`
      num=`echo $new_data | awk -F '"iTotalRecords":' '{print $2}' | cut -d"," -f 1`
      if [ ! -n "$num" ]; then
        echo "token is out of date!"
        exit 1
      fi
      echo "失控 $num"
    ;;   
   2)
      new_data=`curl -s -k -d 'callback=jQuery110207221137385636902_1495251706357&fpdm=&fphm=&rq_q=2016-11-02&rq_z=2017-05-31&xfsbh=&rzfs=&rzzt=0&gxzt=-1&fpzt='${s}'&fplx=-1&cert='${taxno}'&token='${token}'&aoData=[{"name":"sEcho","value":1},{"name":"iColumns","value":14},{"name":"sColumns","value":",,,,,,,,,,,,,"},{"name":"iDisplayStart","value":0},{"name":"iDisplayLength","value":50},{"name":"mDataProp_0","value":0},{"name":"mDataProp_1","value":1},{"name":"mDataProp_2","value":2},{"name":"mDataProp_3","value":3},{"name":"mDataProp_4","value":4},{"name":"mDataProp_5","value":5},{"name":"mDataProp_6","value":6},{"name":"mDataProp_7","value":7},{"name":"mDataProp_8","value":8},{"name":"mDataProp_9","value":9},{"name":"mDataProp_10","value":10},{"name":"mDataProp_11","value":11},{"name":"mDataProp_12","value":12},{"name":"mDataProp_13","value":13}]&ymbb=3.0.09&_=1495251706358' "${url}/SbsqWW/gxcx.do" | iconv -f GBK -t UTF-8`
      num=`echo $new_data | awk -F '"iTotalRecords":' '{print $2}' | cut -d"," -f 1`
      if [ ! -n "$num" ]; then
        echo "token is out of date!"
        exit 1
      fi
      echo "作废 $num"
    ;;
    3)
      new_data=`curl -s -k -d 'callback=jQuery110207221137385636902_1495251706357&fpdm=&fphm=&rq_q=2016-11-02&rq_z=2017-05-31&xfsbh=&rzfs=&rzzt=0&gxzt=-1&fpzt='${s}'&fplx=-1&cert='${taxno}'&token='${token}'&aoData=[{"name":"sEcho","value":1},{"name":"iColumns","value":14},{"name":"sColumns","value":",,,,,,,,,,,,,"},{"name":"iDisplayStart","value":0},{"name":"iDisplayLength","value":50},{"name":"mDataProp_0","value":0},{"name":"mDataProp_1","value":1},{"name":"mDataProp_2","value":2},{"name":"mDataProp_3","value":3},{"name":"mDataProp_4","value":4},{"name":"mDataProp_5","value":5},{"name":"mDataProp_6","value":6},{"name":"mDataProp_7","value":7},{"name":"mDataProp_8","value":8},{"name":"mDataProp_9","value":9},{"name":"mDataProp_10","value":10},{"name":"mDataProp_11","value":11},{"name":"mDataProp_12","value":12},{"name":"mDataProp_13","value":13}]&ymbb=3.0.09&_=1495251706358' "${url}/SbsqWW/gxcx.do" | iconv -f GBK -t UTF-8`
      num=`echo $new_data | awk -F '"iTotalRecords":' '{print $2}' | cut -d"," -f 1`
      if [ ! -n "$num" ]; then
        echo "token is out of date!"
        exit 1
      fi
      echo "红冲 $num"
    ;;
   4)
      new_data=`curl -s -k -d 'callback=jQuery110207221137385636902_1495251706357&fpdm=&fphm=&rq_q=2016-11-02&rq_z=2017-05-31&xfsbh=&rzfs=&rzzt=0&gxzt=-1&fpzt='${s}'&fplx=-1&cert='${taxno}'&token='${token}'&aoData=[{"name":"sEcho","value":1},{"name":"iColumns","value":14},{"name":"sColumns","value":",,,,,,,,,,,,,"},{"name":"iDisplayStart","value":0},{"name":"iDisplayLength","value":50},{"name":"mDataProp_0","value":0},{"name":"mDataProp_1","value":1},{"name":"mDataProp_2","value":2},{"name":"mDataProp_3","value":3},{"name":"mDataProp_4","value":4},{"name":"mDataProp_5","value":5},{"name":"mDataProp_6","value":6},{"name":"mDataProp_7","value":7},{"name":"mDataProp_8","value":8},{"name":"mDataProp_9","value":9},{"name":"mDataProp_10","value":10},{"name":"mDataProp_11","value":11},{"name":"mDataProp_12","value":12},{"name":"mDataProp_13","value":13}]&ymbb=3.0.09&_=1495251706358' "${url}/SbsqWW/gxcx.do" | iconv -f GBK -t UTF-8`
      num=`echo $new_data | awk -F '"iTotalRecords":' '{print $2}' | cut -d"," -f 1`
      if [ ! -n "$num" ]; then
        echo "token is out of date!"
        exit 1
      fi
      echo "异常 $num"
  ;;
    *)
      echo "error param"
    ;;
   esac
done
exit
