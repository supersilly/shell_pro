#!/bin/bash
#set -x
src_dir=/home/tom/src/bwcloud/Huanghe
dubbo_dir=/home/tom/bwcloud
tom_dir=/home/tom/tomcat_8082
pp=`pwd`

#check dubbo and tomcat manage sh,if not exist,exit!
if [ -f /home/tom/dubbo.sh ]; then
  /home/tom/dubbo.sh stop
else
  echo "cannot find dubbo.sh in /home/tom,exit!"
  exit 1
fi
if [ -f /home/tom/8082.sh ]; then
  /home/tom/8082.sh stop
else
  echo "cannot find 8082.sh in /home/tom,exit!"
  exit 1
fi

#go to source dir
cd $src_dir
echo "$pwd"
#read -p "press anykey to continue..."
#get the newest version in git!
git reset --hard
git checkout develop
git pull
#git checkout master

#reset the confi file to fit the testing env!
for i in `find $src_dir -name "uconf.properties" -printf "%p\n"`
do
sed -i /zk.address=/d $i
sed -i '/dubbo.registry.address=/d' $i
echo "zk.address=zkServer1:2181">>$i
echo "dubbo.registry.address=zookeeper://zkServer1:2181?client=curator">>$i
done

#maven make apps
mvn clean install -Dmaven.test.skip=true


#set the deploy info in deploy file!
find . -name "startup.jar" | cut -d "/" -f 2 > ${dubbo_dir}/deploy
find . -name "*.war" | awk -F'/' '{print $NF}' > ${tom_dir}/deploy

#deploy dubbo...
cd ${dubbo_dir}
if [ -f "deploy" ]; then
  while read line
  do
    if [ -d ${line} ]; then
          rm -rf ${line}
    fi
     cp -r ${src_dir}/${line} .  
  done <deploy
else
  echo "no jar to deploy..."
  exit 1
fi

#delete redundant dubbo app
file=startup/pom.xml
if [ -f ${file} ]; then
  sed -i ":begin; { /-->/! { $! { N; b begin }; }; s/<\!--.*-->/ /; };" $file
  cat $file | grep artifactId | grep baiwangcloud | grep -o baiwangcloud.*service | sed s/baiwangcloud//g |sed s/service//g | tr -d "\." >delete
  for rm_dubbo in `cat delete`
    do
      rm -rf ${rm_dubbo}
    done
else
  echo "$file"
fi
unset file

#deploy tomcat...
cd ${tom_dir}
if [ -f "deploy" ]; then
  rm -rf webapps/*
#  read -p "press any key to continue..."
  while read line
  do
    cp -r `find /home/tom/src/ -name "${line}" -printf "%p\n"` webapps
  done<deploy
else
  echo "no war to deploy..."
  exit 1
fi

cd $pp
#start dubbo and tomcat!
echo "begin to start dubbo..."
/home/tom/dubbo.sh start
echo "begin to start tomcat..."
/home/tom/8082.sh start
echo "FINISHED!"
