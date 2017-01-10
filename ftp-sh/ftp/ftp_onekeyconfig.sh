#!/bin/bash
echo "linux vsftpd one key to config!"
if [ -d "/etc/vsftpd/" ]; then
  echo "Find the vsftpd!"
else
  echo "Cannot find vsftpd in etc,quit!"
  exit 0
fi
if [ -f "/etc/pam.d/vsftpd" ]; then
  echo "Find the vsftpd pam!"
  rm -rf "/etc/pam.d/vsftpd"
fi
cp vsftpd "/etc/pam.d/vsftpd"  
mv adduser_ftp.sh /etc/vsftpd/
mv deluser_ftp.sh /etc/vsftpd/
mv mkpasswd.sh /etc/vsftpd/
if [ -f "/etc/vsftpd/vsftpd.conf" ]; then
  echo "Find the vsftpd.conf!"
  mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf_bak
fi
cp vsftpd.conf /etc/vsftpd/vsftpd.conf
if [ -d "/etc/vsftpd/" ]; then
  echo "Make dir /etc/vsftpd/vuser_conf!"
  mkdir -p "/etc/vsftpd/vuser_conf"
fi
mv default "/etc/vsftpd/vuser_conf/"
if [ -d "/var/ftp" ]; then
  echo "make the default dir /var/ftp!"
  mkdir -p /var/ftp
else
  echo "the default dir is /var/ftp!"
fi
chown -R ftp:ftp /var/ftp
chmod -R 774 /var/ftp