#!/bin/bash
#set -x
if [ $# -ne 1 ]; then
  echo "you must input inv_kind! usage: sh inv_type.sh [inv_kind]"
  exit 1;
fi
is_num=`echo $1 | sed 's/[0-9]//g'`
if [ -n "$is_num" ]; then
  echo "the inv_kind must be a num!"
  exit 1;
fi
inv_result=`curl -s -k 'https://zjfpcyweb.bjsat.gov.cn/WebQuery/yzmQuery?callback=jQuery110202146848274329527_1510889719389&fpdm='"$1" | egrep -o '"key1":"[^"]+' | sed 's/"//g' | cut -d":" -f 2`
if [ "$inv_result" == "fpdmerr" ]; then
  echo "invalid inv_num!"
  exit 1;
fi
inv_len=${#1}
if [ $inv_len -eq 12 ]; then
    if [ "$1" == "144031539110" -o "$1" == "131001570151" -o "$1" == "133011501118" -o "$1" == "111001571071" ]; then
        inv_type="10"
        echo "${inv_type}电票"
    elif [ ${1:0:1} == "0" ]; then
        if [ ${1:10:2} == "11" ]; then
            inv_type="10"
            echo "${inv_type}电票"
        elif [ ${1:10:2} == "06" -o ${1:10:2} == "07" ]; then
            inv_type="11"
            echo "${inv_tpye}卷票"
        fi
    elif [ ${1:7:1} == "2" -a ${1:0:1} != "0" ]; then
        inv_type="03"
        echo "${inv_type}机动车票"
    else
        echo "inv_num does not exist,please check it!"
        exit 1;
    fi
elif [ $inv_len -eq 10 ]; then
    b=${1:7:1};
    if [ $b -eq 1 -o $b -eq 5 ]; then
        inv_type="01"
        echo "${inv_type}专票"
    elif [ $b -eq 6 -o $b -eq 3 ]; then
        inv_type="04"
        echo "${inv_type}普票"
    elif [ $b -eq 7 -o $b -eq 2 ]; then
        inv_type="02"
        echo "${type}货运"
    else
        echo "inv_num does not exist,please check it!"
        exit 1;
    fi
else
    echo "the length of inv_num must be 10 or 12!"
    exit 1;
fi
