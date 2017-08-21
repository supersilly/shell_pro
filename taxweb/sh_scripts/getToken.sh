#!/bin/bash 
#set -x
web="http://ivs.baiwang.com/jxfp/api/gwsoft/getToken"
username="admin" 
pw="gwsoftadmin" 
taxno=$1
dqbm=$2
da=`date +%s%N`
rand=${da:0:13}
force=true
sign=`echo -n "${taxno}${dqbm}true${username}${pw}" | md5sum |  awk -F" " '{print $1}'`
para="sh="${taxno}"&dqbm="${dqbm}"&force="${force}"&username="${username}"&sign="${sign}
for ((i=0;i<1;))
  do
    rel=`curl -s ${web}?${para}`
    token=`echo ${rel} | grep token | grep -v "grep" | sed 's/\(.*\)token":"\([^"]*\)","\(.*\)/\2/g'`
    #check whether token is not null, if not null,set i equals 1,to break the loop
    if [ -n "${token}" ]; then
      echo "${token}"
      i=1
    fi
    # if token is not gotten, sleep 1
    if [[ "$i" = 0  ]]; then
      sleep 1
    fi
  done
