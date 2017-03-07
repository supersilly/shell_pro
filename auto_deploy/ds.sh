#!/bin/bash
jar_dir=/home/tom/dataswitch
log_dir=/home/tom/dataswitch/logs/ds
key_w=dataswitch-server
check_jar()
{
  echo "check jars..."
  cd $jar_dir
  cj_re=`ls | grep .jar$ | grep $key_w | wc -l`
  if [ $cj_re -eq '0' ]; then
    echo "cannot find server.jar...please check it!"
    exit 0
  elif [ $cj_re -eq '1' ]; then
    echo "jar is ready!"
  else
    echo "there are too many server jar versions...only one is permitted,please make sure!"
    exit 0
  fi
}
serv_start()
{
  check_jar
  echo "begin to start..."
  rm -rf $log_dir
  if [ `ps -ef | grep $key_w | grep -v grep | wc -l` -eq '0' ]; then
    nohup java -Xdebug -Xms512m -Xmn256m -XX:PermSize=128m -Xss256k -Xrunjdwp:transport=dt_socket,address=4445,server=y,suspend=n -jar /home/tom/dataswitch/dataswitch-server*.jar 192.168.6.47:9091 >/dev/null 2>&1 &
    sleep 1
  else
    echo "The dataswitch server is already started!"
    exit 0
  fi
}
serv_stop()
{
  echo "begin to stop..."
  if [ `ps -ef | grep $key_w | grep -v grep | wc -l` -eq '0' ]; then
    echo "server is not running..."
  elif [ `ps -ef | grep $key_w | grep -v grep | wc -l` -eq '1' ]; then
    echo "shutdowning the server..."
    serv_pid=`ps -ef | grep $key_w | grep -v grep | awk '{print $2}'`
    kill -9 $serv_pid
  else
    echo "there are too many dataswitch server processes...please shutdown manually!"
    exit 0
  fi
}
serv_status()
{
  if [ `ps -ef | grep $key_w | grep -v grep | wc -l` -ne 0 ]; then
    ps -ef | grep $key_w | grep -v grep
  else
    echo "$key_w is not running..."
    exit 0
  fi
}
if [ $# -eq 0 ]; then
  serv_status
elif [ $# = 1 -a $1 = "start" ]; then
  serv_start
elif [ $# = 1 -a $1 = "stop" ]; then
  serv_stop
elif [ $# = 1 -a $1 = "restart" ]; then
  serv_stop
  serv_start
elif [ $# = 1 -a $1 = "status" ]; then
  serv_status
else
  echo "Your param is wrong!"
  echo "usage:"
  echo "$0 [ start | stop | restart | status ]"
  echo "The default param:status"
  exit 1
fi
echo "Finished!"
