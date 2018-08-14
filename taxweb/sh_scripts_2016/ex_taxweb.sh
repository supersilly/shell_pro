#!/bin/bash
#set -x
cat tax.txt | grep -v NULL |  grep "$1" > tax
while read line
do
echo  "check "${line}
./taxweb.sh ${line}
done < tax
rm -rf tax
