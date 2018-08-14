#!/bin/bash
set -x
cat tax.txt | grep "$1" > tax
while read line
do
./taxweb.sh ${line}
done < tax
rm -rf tax
