#!/bin/bash
set -x
token=$1
wsName="admin"
wsTime=`date +%Y%m%d%H%M%S`
wsPassword="1"
wsSignature=`echo -n ${token}${wsName}${wsTime}${wsPassword} | md5sum | cut -d " " -f 1`
echo ${wsSignature}
