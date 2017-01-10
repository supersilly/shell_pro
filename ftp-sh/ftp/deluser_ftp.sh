#!/bin/bash
if [ $# -ne 1 ]; then
  echo "you must specified a ftpuser!"
  echo "usage: ${0} username"
  exit 0
fi
cont=$(cat chroot_list)
if [[ $cont =~ "${1}" ]]; then
  echo "Begin to del the user ${1}!"
else
  echo "ftp user ${1} is not exist!"
  exit 0
fi
  
line=$(sed -n /baojia/= "/etc/vsftpd/vuser_passwd.txt")
((next=${line}+1))

sed -i "/${1}/d" "/etc/vsftpd/chroot_list"
#echo ${line} ${next}
sed -i "${line},${next}d" "/etc/vsftpd/vuser_passwd.txt"
rm -rf "/etc/vsftpd/vuser_conf/${1}"
/etc/vsftpd/mkpasswd.sh
service vsftpd restart
