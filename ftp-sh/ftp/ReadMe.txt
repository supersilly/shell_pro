使用说明：

该FTP是配置在linux环境上的vsftpd，可以为FTP用户制定任意主目录，分配任意权限，很灵活、方便,有说明ReadMe.txt
首先 确认 linux 系统的 selinux 和防火墙，这些自己百度修改吧。

包含： 
一键初始化配置vsftpd  ./ftp_onekeyconfig.sh
增加ftp用户脚本  ./adduser_ftp.sh  ftpuser  passwd
删除ftp用户脚本  ./deluser_ftp.sh  ftpuser
可以自由制定用户的目录、权限

该FTP是在linux环境上的，可以为FTP用户制定任意主目录，分配任意权限，很灵活、方便。

原环境 是 centos 7.0 64bit

1.使用yum -y vsftpd （如果没装的话，yum源自己配置），如果是windows上传到linux上，还需要装个 yum -y install dos2unix
2.查看vsftpd默认的目录 应该是/etc/vsftpd。
3.该脚本的执行 由于牵扯到 一些文件的权限分配（/var/ftp），请使用root用户
4.解压后不要动目录的内容，添加执行权限，执行脚本chmod +x *.sh   ,如果是windows，还需执行  dos2unix *.sh  （windows上传的需要修改下格式否则不识别linux  的bash命令）
5.执行./ftp_onekeyconfig.sh,进行初始化。
6.进入目录/etc/vsftpd，命令 cd /etc/vsftpd
7.添加用户ftp,密码pa33，命令  ./adduser_ftp.sh ftp pa33
8.删除用户 ftp,命令  ./deluser_ftp.sh ftp


注意事情：

1.添加ftp用户的时候，会添加系统的user，删除ftp用户的时候，不删除系统user，但会删除ftp的登录user。
2.默认的ftp的用户的目录是/var/ftp,每个用户都有自己的权限配置，在/etc/vsftpd/vuser_conf下，格式如下：
#------使用下方的代码
local_root=/var/ftp/
#虚拟用户根目录,根据实际情况修改  该目录必须要有读写权限 chmod -R 777 目录
write_enable=YES
#可写
anon_umask=022
#掩码 
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
#-------使用上方的代码
修改的时候，修改对应的目录就行了，但是要注意目录自身的权限问题。目录的权限这边不在赘述。
3.vuser_passwd.txt是明文密码，不要删除，会根据它生成加密的密码文件。