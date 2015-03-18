touch /etc/scsi_id.config
sed -i -e '/options=/d' /etc/scsi_id.config
echo '$aoptions=-g' >> /etc/scsi_id.config

i=1
cmd="/sbin/scsi_id -g -u -d"
awkscript='BEGIN {FS = ":"; count = 0}; $1 == "1" {count = count+1}; END {print count}'
> /etc/udev/rules.d/99-oracle-asmdevices.rules
for disk in sdb sdc sdd sde sdf sdg sdh; do 
	if [ "$(hostname -s)" != "collabn1" ]; then
		echo "This is not collabn1, skipping partition creation for disk /dev/$disk"
	elif [ "$(parted -m --script /dev/$disk print | awk "$awkscript")" != "0" ]; then
		echo "The partition for disk /dev/$disk has already been created, skipping partition creation"
	else
		parted --script /dev/$disk mklabel msdos
		parted --script /dev/$disk mkpart primary 0% 100%
	fi
	partprobe /dev/${disk}
	echo 'KERNEL=="sd?1", BUS=="scsi", PROGRAM=="'$cmd' /dev/$parent",' \
	'RESULT=="'$($cmd /dev/$disk)'", NAME="asm-disk'"$i"'",' \
	'OWNER="oracle", GROUP="dba", MODE="0660"' >> /etc/udev/rules.d/99-oracle-asmdevices.rules
	let i++ 
done

echo
cat /etc/udev/rules.d/99-oracle-asmdevices.rules
echo

start_udev
