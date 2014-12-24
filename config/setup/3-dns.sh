FILEDIR=/racattack/setup

chmod g+w /var/named

mv /etc/named.conf /etc/named.conf.org
cp $FILEDIR/named.conf.$(hostname -s) /etc/named.conf
chgrp named /etc/named.conf

cp $FILEDIR/racattack.dns.conf /var/named/racattack
chgrp named /etc/named.conf
chmod 664 /var/named/racattack

cp $FILEDIR/in-addr.arpa /var/named/in-addr.arpa
chgrp named /var/named/in-addr.arpa
chmod 664 /var/named/in-addr.arpa

cp $FILEDIR/rndc.{conf,key} /etc/
chgrp named /etc/rndc.{conf,key}
chmod 664 /etc/rndc.{conf,key}

cp $FILEDIR/resolv.conf /etc/

service named restart

chkconfig named on
