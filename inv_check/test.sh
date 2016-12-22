#!/bin/bash
#set -x
fpdm=$1
fphm=$2
fpje=$3
fprq=$4
jym=$6
echo "-------------------------------------------------"
echo "发票类型 $5"
echo "发票号码 $1 发票代码 $2 发票金额 $3 发票日期 $4"
#fpdm=4400161130
#fphm=15419540
#20160909
#fprq=20160817
#fpje=12054.30
#echo -n "caoxh${1}2016-08-26 16:55:40caoxh3421" | md5sum | cut -d" " -f 1
sign=`echo -n "caoxh${fphm}${fpdm}2016-08-26 16:55:40caoxh3421" | md5sum | cut -d" " -f 1`
#url='http://192.168.9.17/fpcheck/app/fininvoice/list'
url='http://180.76.176.251:8082/app/fininvoice/list'
curl -H "Content-type: application/json" -X POST -d '{"head":{"VERSION":"1","REQUESTTYPE":"100","SESSIONID":"4028809056c60fd10156c60fd17e0000","SENDTIME":"2016-08-26 16:55:40","STATUS":"100","USERNAME":"caoxh","SIGN":"'${sign}'","RANDOM":"3421"}, "body":{"FPDM": "'${fpdm}'","FPHM":"'${fphm}'","KPRQ":"'${fprq}'","FPJE":"'${fpje}'","JYM":"'${jym}'"}}' ${url}
echo ""
echo "-------------------------------------------------"
