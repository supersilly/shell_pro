#!/bin/bash
set -x
#curl -d @req.xml -H "Content-Type: text/xml;charset=UTF-8" http://182.92.213.158:8080/GwssiFpcxService/webservice/QxrzService?wsdl
wsTime=`date +%Y%m%d%H%M%S`
cert=$1
token=$2
wsName="admin"
wsPassword="1"
dqdm=$3
wsSignature=`echo -n ${token}${wsName}${wsTime}${wsPassword} | md5sum | cut -d " " -f 1`
reqdata='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.fpcxService.gwssi.com/"><soapenv:Header/><soapenv:Body><web:jyxxQxrzDownload><!--Optional:--><arg0>{"wsName":"'${wsName}'","wsSignature":"'${wsSignature}'","wsTime":"'${wsTime}'","cert":"'${cert}'","hxzt":"0","kprq_q":"2016-12-12","kprq_z":"2017-01-01","token":"'${token}'","dqdm":"'${dqdm}'"}</arg0></web:jyxxQxrzDownload></soapenv:Body></soapenv:Envelope>'
echo ${reqdata}
curl -d "${reqdata}" -H "Content-Type: text/xml;charset=UTF-8" 'http://182.92.213.158:8080/GwssiFpcxService/webservice/QxrzService?wsdl'
