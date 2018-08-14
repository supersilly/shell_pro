#!/bin/bash
#set -x
taxno=$1
zone=$2
token=`sh getToken.sh ${taxno} ${zone}`
ymbb="3.0.10"
da=`date +%s%N`
rand=${da:0:13}

case ${zone} in

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


for ((h=0;h<3;h++))
do
  rel=`curl -s -k "${url}/SbsqWW/nsrcx.do?callback=jQuery1102031669351755015445_1501148459860&cert=${taxno}&token=${token}&ymbb=${ymbb}&_=${rand}" | iconv -f GBK -t UTF-8`
  #echo $rel
  echo "token is ${token}"
  key2=`echo $rel | grep key2 | grep -v grep | sed 's/\(.*\)"key2":"\(.*\)","key3.*/\2/g'`
  if [ -z "$key2" ]; then
    echo "token is out of date,get it again!"
    token=`sh getToken.sh ${taxno} ${zone}`
  else
    h=11
    echo "key2 is ${key2}"
    buyname=`echo ${key2} | awk -F '=' '{print $1}'`
    oldtax=`echo ${key2} | awk -F '=' '{print $8}'`
    taxlevel=`echo ${key2} | awk -F '=' '{print $9}'`
    echo "buyname is ${buyname}"
    echo "oldtax is ${oldtax}"
    echo "taxlevel is ${taxlevel}"
  fi
done
if [ "$h" -eq 3 ]; then
  echo "Cannot get Token,exit!"
  exit 1
fi
