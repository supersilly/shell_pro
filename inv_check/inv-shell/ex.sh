#!/bin/bash
thread_num=20
cat inv.txt | grep -v '#' >testdata
while read line
do
  #echo $line
  w_cnt=$(ps -ef | grep j_x | grep -v grep | wc -l)
  echo `ps -ef | grep j_x | grep -v grep`
  if [ $w_cnt -lt ${thread_num} ]; then
    echo "the times is ${w_cnt},begin to work..."
    nohup ./j_x.sh ${line} >/dev/null 2>&1 &
  else
    echo "the times is ${w_cnt},sleep 1s ..."
    sleep 1
  fi
done < testdata
rm -rf testdata
