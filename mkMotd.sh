#!/bin/bash
#set -x
nat=`ifconfig | grep cast | awk -F" " '{print $1,$2}'`
#net=`curl -s 'www.baidu.com/s?wd=ip' | egrep -o "我的ip.* " | grep -Eoe "([0-9]|[\.])*"`
#getnet=`curl -k -s 'https://ip.cn/' | cut -d "：" -f 2 | cut -d " " -f 1`
getnet=`curl -k -s 'https://ip.cn/' | iconv -futf-8`
echo $getnet
if [[ "${getnet}" =~ "IP" ]]; then
  net=`echo $getnet | grep -Eoe "([0-9]|\.)*" | head -1`
else
  net="null"
fi
num=`echo $net | cut -d "." -f 4`
motd=/etc/motd
if [ -w $motd ]; then
  echo "write login info"
  echo "">$motd
  echo "${nat}">>$motd
  echo "net ip: ${net}">>$motd
  echo "welcome to ${num}">>$motd
  cat $motd
else
  echo "${nat}"
  echo "net ip: ${net}"
  echo "welcome to ${num}"
fi
