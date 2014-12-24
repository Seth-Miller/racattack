touch /etc/scsi_id.config
sed -i -e '/options=/d' /etc/scsi_id.config
sed -i -e '$aoptions=-g' /etc/scsi_id.config

i=1
cmd="/sbin/scsi_id -g -u -d"
> /etc/udev/rules.d/99-oracle-asmdevices.rules
for disk in sdb sdc sdd sde; do 
	if [ "$(hostname -s)" = "collabn1" ]; then
		parted --script /dev/$disk mkpart primary 0% 100%
	fi
	partprobe /dev/${disk}
	echo 'KERNEL=="sd?1", BUS=="scsi", PROGRAM=="'$cmd' /dev/$parent",' \
	'RESULT=="'$($cmd /dev/$disk)'", NAME="asm-disk'"$i"'",' \
	'OWNER="oracle", GROUP="dba", MODE="0660"' >> /etc/udev/rules.d/99-oracle-asmdevices.rules
	let i++ 
done

start_udev
