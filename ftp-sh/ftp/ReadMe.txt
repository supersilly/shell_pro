ʹ��˵����

��FTP��������linux�����ϵ�vsftpd������ΪFTP�û��ƶ�������Ŀ¼����������Ȩ�ޣ���������,��˵��ReadMe.txt
���� ȷ�� linux ϵͳ�� selinux �ͷ���ǽ����Щ�Լ��ٶ��޸İɡ�

������ 
һ����ʼ������vsftpd  ./ftp_onekeyconfig.sh
����ftp�û��ű�  ./adduser_ftp.sh  ftpuser  passwd
ɾ��ftp�û��ű�  ./deluser_ftp.sh  ftpuser
���������ƶ��û���Ŀ¼��Ȩ��

��FTP����linux�����ϵģ�����ΪFTP�û��ƶ�������Ŀ¼����������Ȩ�ޣ��������㡣

ԭ���� �� centos 7.0 64bit

1.ʹ��yum -y vsftpd �����ûװ�Ļ���yumԴ�Լ����ã��������windows�ϴ���linux�ϣ�����Ҫװ�� yum -y install dos2unix
2.�鿴vsftpdĬ�ϵ�Ŀ¼ Ӧ����/etc/vsftpd��
3.�ýű���ִ�� ����ǣ���� һЩ�ļ���Ȩ�޷��䣨/var/ftp������ʹ��root�û�
4.��ѹ��Ҫ��Ŀ¼�����ݣ����ִ��Ȩ�ޣ�ִ�нű�chmod +x *.sh   ,�����windows������ִ��  dos2unix *.sh  ��windows�ϴ�����Ҫ�޸��¸�ʽ����ʶ��linux  ��bash���
5.ִ��./ftp_onekeyconfig.sh,���г�ʼ����
6.����Ŀ¼/etc/vsftpd������ cd /etc/vsftpd
7.����û�ftp,����pa33������  ./adduser_ftp.sh ftp pa33
8.ɾ���û� ftp,����  ./deluser_ftp.sh ftp


ע�����飺

1.���ftp�û���ʱ�򣬻����ϵͳ��user��ɾ��ftp�û���ʱ�򣬲�ɾ��ϵͳuser������ɾ��ftp�ĵ�¼user��
2.Ĭ�ϵ�ftp���û���Ŀ¼��/var/ftp,ÿ���û������Լ���Ȩ�����ã���/etc/vsftpd/vuser_conf�£���ʽ���£�
#------ʹ���·��Ĵ���
local_root=/var/ftp/
#�����û���Ŀ¼,����ʵ������޸�  ��Ŀ¼����Ҫ�ж�дȨ�� chmod -R 777 Ŀ¼
write_enable=YES
#��д
anon_umask=022
#���� 
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
#-------ʹ���Ϸ��Ĵ���
�޸ĵ�ʱ���޸Ķ�Ӧ��Ŀ¼�����ˣ�����Ҫע��Ŀ¼�����Ȩ�����⡣Ŀ¼��Ȩ����߲���׸����
3.vuser_passwd.txt���������룬��Ҫɾ��������������ɼ��ܵ������ļ���