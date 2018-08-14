#!/bin/bash
for t in `ps -ef | grep tomcat | grep -v grep | egrep -o "\/[^/]*\/conf\/logging.properties" | cut -d "/" -f 2`;
do echo $t; ps -ef | grep $t | grep -v grep | awk '{print $2}' | xargs -i cat /proc/{}/status | grep read; echo ""; done
