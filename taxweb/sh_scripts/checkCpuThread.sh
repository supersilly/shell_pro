#/bin/bash
#set -x
if [ $# -ne 1 ]; then
  echo "you must input one parameter to be a pid!"
  exit 1;
fi
pd="$1"
is_ok=`ps -ef | grep $pd | grep -v grep | wc -l`
if [ $is_ok -ne 1 ]; then
  echo "there are ${is_ok} pid(s) ${pd} found, it must be 1!"
  exit
fi

a=(`ps -mp $pd -o THREAD,tid |  awk '{split($2,a,".");if(a[1]>0 && a[1]<100) print $0}' | awk '{print $NF}'`)
s_pd=${#a[*]}
#echo "${a[*]}"
for ((i=0;i<${s_pd};i++))
do
#echo "i is: "$i
#eval echo "a ${i} is: " ${a[$i]}
xpd=`printf "%x\n" ${a[$i]}`
#echo "xpd is $xpd"
jstack $pd | grep "${xpd}" -A 10
echo "---------------------------------"
done
