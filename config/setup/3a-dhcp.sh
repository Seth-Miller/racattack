FILEDIR=/racattack/setup

mv /etc/dhcpd.conf /etc/dhcpd.conf.org
cp $FILEDIR/dhcpd.conf.$(hostname -s) /etc/dhcpd.conf

service dhcpd restart

chkconfig dhcpd on
