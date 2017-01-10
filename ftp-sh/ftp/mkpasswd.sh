#!/bin/bash
db_load -T -t hash -f /etc/vsftpd/vuser_passwd.txt /etc/vsftpd/vuser_passwd.db
