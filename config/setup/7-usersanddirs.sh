
FILEDIR=/racattack/setup

sed -i -e '/session    required     pam_selinux.so open/i\
session    required     \/lib64\/security\/pam_limits.so\
session    required     pam_limits.so' /etc/pam.d/login

echo racattack | passwd --stdin oracle

mkdir -p /u01/app /u01/app/oracle
chown -R oracle:oinstall /u01/app

usermod -g oinstall -G dba,vboxsf oracle

mkdir -p /root/.ssh
mkdir -p /home/oracle/.ssh
chmod 700 /root/.ssh
chmod 700 /home/oracle/.ssh


cp -f $FILEDIR/ssh_host_rsa_key /etc/ssh/
cp -f $FILEDIR/ssh_host_rsa_key.pub /etc/ssh/
chmod 600 /etc/ssh/ssh_host_rsa_key

cp -f $FILEDIR/id_rsa.root /root/.ssh/id_rsa
cp -f $FILEDIR/id_rsa.pub.root /root/.ssh/id_rsa.pub
cp -f $FILEDIR/authorized_keys.root /root/.ssh/authorized_keys
cp -f $FILEDIR/known_hosts /root/.ssh/known_hosts
chmod 600 /root/.ssh/id_rsa

cp -f $FILEDIR/id_rsa.oracle /home/oracle/.ssh/id_rsa
cp -f $FILEDIR/id_rsa.pub.oracle /home/oracle/.ssh/id_rsa.pub
cp -f $FILEDIR/authorized_keys.oracle /home/oracle/.ssh/authorized_keys
cp -f $FILEDIR/known_hosts /home/oracle/.ssh/known_hosts
chmod 600 /home/oracle/.ssh/id_rsa
chown -R oracle.oinstall /home/oracle/.ssh
