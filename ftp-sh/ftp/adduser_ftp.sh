#!/bin/bash
if [ $# -ne 2 ]; then
  echo "you must specified a ftpuser and passwd!"
  echo "usage: $0 username passwd"
  exit 0
fi
user_check(){
  if [ id -u ${1} >/dev/null 2>&1 ]; then
    echo "user ${1} exists"
  else
    echo "user does not exist,add it!"
    useradd -g ftp ${1}
  fi
}
user_check ${1}
echo ${1} >> "/etc/vsftpd/chroot_list"
echo ${1} >> "/etc/vsftpd/vuser_passwd.txt"
echo ${2} >> "/etc/vsftpd/vuser_passwd.txt"
cp "/etc/vsftpd/vuser_conf/default" "/etc/vsftpd/vuser_conf/${1}"
/etc/vsftpd/mkpasswd.sh
service vsftpd restart
