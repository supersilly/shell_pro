#!/bin/bash
pp=`pwd`
cd /home/tom/bwcloud
pd=`ps -ef | grep bwcloud | grep -v grep | grep java | grep dubbo | wc -l`

dubbo_start() {
  pd=`ps -ef | grep bwcloud | grep -v grep | grep java | grep dubbo | wc -l`
  if [ $pd -ne 0 ]; then
    echo "dubbo is already running..."
    exit 1
  fi
  for i in `find . -name "startup.jar" | cut -d "/" -f 2`
  do
#    if [ $i == "startup" ]; then
      #nohup java -server -Xmx1G -Xms256m -Xmn128m -XX:PermSize=128m -Xss256k -jar -DAPP_HOME=/home/tom/bwcloud -DAPP_NAME=allServices -Ddubbo.registry.file=/home/tom/.dubbo/dubbo-registry-allservices.cache /home/tom/bwcloud/startup/target/startup.jar > nohup_all.out &
    #else
#    nohup java -server -Xmx256m -Xms256m -Xmn128m -XX:PermSize=128m -Xss256k -jar -DAPP_HOME=/home/tom/bwcloud -DAPP_NAME=${i} -Ddubbo.registry.file=/home/tom/.dubbo/dubbo-registry-${i}.cache `find ${i} -name "startup.jar"` > nohup_${i}.out &
#    fi
   nohup java -server -Xmx256m -Xms256m -Xmn128m -XX:PermSize=128m -Xss256k -jar -DAPP_HOME=/home/tom/bwcloud -DAPP_NAME=${i} -Ddubbo.registry.file=/home/tom/.dubbo/dubbo-registry-${i}.cache `find ${i} -name "startup.jar"` > nohup_${i}.out &
  done
}

dubbo_kill() {
  pd=`ps -ef | grep bwcloud | grep -v grep | grep java | grep dubbo | wc -l`
  if [ $pd -eq 0 ]; then
    echo "no dubbo running...exit"
    exit 1
  fi
  for i in `ps -ef | grep bwcloud | grep -v grep | awk '{print $2}'`
  do
    kill -9 $i
  done
}

dubbo_status() {
  pd=`ps -ef | grep bwcloud | grep -v grep | grep java | grep dubbo | wc -l`
  if [ $pd -eq 0 ]; then
    echo "no dubbo running..."
    exit 1
  fi
  ps -ef | grep bwcloud | grep -v grep | grep java | grep dubbo
}
if [ $# -eq 0 ]; then
  dubbo_status
elif [ $# = 1 -a $1 = "start" ]; then
  echo "Begin to start the dubbo ..."
  dubbo_start
elif [ $# = 1 -a $1 = "stop" ]; then
  echo "Begin to shutdown dubbo ..."
  dubbo_kill
elif [ $# = 1 -a $1 = "restart" ]; then
  echo "Begin to restart dubbo ..."
  dubbo_kill
  dubbo_start
elif [ $# = 1 -a $1 = "status" ]; then
  dubbo_status
else
  echo "Your param is wrong!"
  echo "usage:"
  echo "$0 [ start | stop | restart | status ]"
  echo "The default param: log"
  cd $pp
  exit 1
fi
cd $pp
