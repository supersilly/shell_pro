#!/bin/bash
set -x
#curl -d @req.xml -H "Content-Type: text/xml;charset=UTF-8" http://182.92.213.158:8080/GwssiFpcxService/webservice/QxrzService?wsdl
wsTime=`date +%Y%m%d%H%M%S`
cert=$1
token=$2
wsName="admin"
wsPassword="1"
wsSignature=`echo -n ${token}${wsName}${wsTime}${wsPassword} | md5sum | cut -d " " -f 1`
if [ "$1" = "91422827767429195D" ]; then
  reqdata='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.fpcxService.gwssi.com/"><soapenv:Header/><soapenv:Body><web:jbxxQxrzFpcx><arg0>{"cert":"'${cert}'","fpdm":"4200162130","fphm":"07650002","dqdm":"4200","token":"'${token}'","wsName":"admin","wsSignature":"'${wsSignature}'","wsTime":"'${wsTime}'"}</arg0></web:jbxxQxrzFpcx></soapenv:Body></soapenv:Envelope>'
elif [ "$1" = "91429004760681451F" ]; then
  reqdata='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.fpcxService.gwssi.com/"><soapenv:Header/><soapenv:Body><web:jbxxQxrzFpcx><arg0>{"cert":"'${cert}'","fpdm":"4200163130","fphm":"07856390","dqdm":"4200","token":"'${token}'","wsName":"admin","wsSignature":"'${wsSignature}'","wsTime":"'${wsTime}'"}</arg0></web:jbxxQxrzFpcx></soapenv:Body></soapenv:Envelope>'
else
  echo "taxno is wrong!"
  exit 0
fi
echo ${reqdata}
curl -d "${reqdata}" -H "Content-Type: text/xml;charset=UTF-8" 'http://182.92.213.158:8080/GwssiFpcxService/webservice/QxrzService?wsdl'
