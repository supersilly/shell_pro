#!/bin/bash
cd /home/tom/tomcat_8082
m_date=$(date +%Y%m%d_%H%M)
tomcat_dir="/home/tom/tomcat_8082"
start_sh=${tomcat_dir}"/bin/startup.sh"
stop_sh=${tomcat_dir}"/bin/shutdown.sh"
log=${tomcat_dir}"/logs/catalina.out"
function start_tm {
  if [ ! -x ${start_sh} ]; then
    echo "start shell not available..."
    exit 0
  else
    echo "starting..."
  fi
  if [ $(ps -ef | grep java | grep tom | grep tomcat_8082/bin | grep -v grep | wc -l) -eq '0' ]; then
    nohup $start_sh >/dev/null  2>&1 &
  else
    echo "The tomcat is already started!"
    exit 0
  fi
  sleep 2
  if [ -f $log ]; then
    tail -500f $log
  fi
}

function stop_tm {
  if [ $(ps -ef | grep java | grep tomcat_8082/bin | grep tom | grep -v grep | wc -l) -eq '1' ]; then
    $stop_sh
  else
    echo "The tomcat is not running!"
    exit 0
  fi
  sleep 2
  for ((i=0;i<3;i++))
  do
    if [ $(ps -ef | grep java | grep tomcat_8082/bin | grep tom | grep -v grep | wc -l) -eq '0' ]; then
      echo "Shutdown the tomcat successfully!"
      i=10
    else
      echo "wait,it is shutting down..." 
      sleep 1
    fi
  done
  if [ $(ps -ef | grep java | grep tomcat_8082/bin | grep tom | grep -v grep | wc -l) -ne '0' ]; then
    echo "Find tomcat is still running,kill it!"
    ps -ef | grep tomcat_8082/bin | grep tom | grep -v grep | awk '{print $2}' | xargs kill -9
  fi
  if [ -f $log ]; then
    echo "move the log to a new name..."
    mv "$log" $log"_"${m_date}
  fi
}

function restart_tm {
  echo "begin to restart tomcat"
  stop_tm
  sleep 2
  start_tm
}

function status_tm {
  echo "The follows:"
  if [ $(ps -ef | grep java | grep tom | grep tomcat_8082/bin | grep -v grep | wc -l) -eq '0' ]; then
    echo "Tomcat is not running!"
    exit 0
  else
    ps -ef | grep tomcat_8082/bin | grep -v grep
  fi
}

#if the user is not root,exit
echo "check whether the user is tom"
USER_NOW=$(whoami)
if [ ${USER_NOW} = "tom" ]; then
  echo "You are tom."
else
  echo "To execute this shell,you must be tom!"
  exit 0
fi

if [ $# -eq 0 ]; then
  tail -100f $log
elif [ $# = 1 -a $1 = "start" ]; then
  echo "Begin to start the tomcat ..."
  start_tm
elif [ $# = 1 -a $1 = "stop" ]; then
  echo "Begin to shutdown the tomcat ..."
  stop_tm
elif [ $# = 1 -a $1 = "restart" ]; then
  echo "Begin to restart the tomcat ..."
  restart_tm
elif [ $# = 1 -a $1 = "status" ]; then
  status_tm
elif [ $# = 1 -a $1 = "log" ]; then
  tail -500f $log
else
  echo "Your param is wrong!"
  echo "usage:"
  echo "$0 [ start | stop | restart | status | log ]"
  echo "The default param: log"
  exit 1
fi
echo "Finished!"
