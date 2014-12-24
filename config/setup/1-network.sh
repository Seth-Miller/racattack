
SED=sed
FILE=/etc/sysconfig/network-scripts/ifcfg-eth0
ETH0=/etc/sysconfig/network-scripts/ifcfg-eth0
ETH1=/etc/sysconfig/network-scripts/ifcfg-eth1
ETH2=/etc/sysconfig/network-scripts/ifcfg-eth2
ETH1RT=/etc/sysconfig/network-scripts/route-eth1

echo >> $ETH1RT

function mkchg ()
{
	# Parameter to replace
	local PARM=$1
	# Use $FILE from script if not provided
	local FILE=${2:-$FILE}

	# First delete the parameter and its value from the file if they exist
        $SED -i '/'"${PARM%=*}"'/d' $FILE
	# Then append the new one
	$SED -i '$a'"$PARM" $FILE
}

function rmparm ()
{
	# Parameter to delete
	local PARM=$1
	# Use $FILE from script if not provided
	local FILE=${2:-$FILE}

	# Delete parameter
        $SED -i '/'"${PARM%=*}"'/d' $FILE

}



# Make network changes
if [ "$(hostname -s)" = "collabn1" ]; then
	mkchg 'IPADDR="192.168.78.51"' $ETH0
	sed -i '/collabn1/d' /etc/hosts
        sed -i '1i192.168.78.51        collabn1.racattack        collabn1' /etc/hosts
elif [ "$(hostname -s)" = "collabn2" ]; then
	mkchg 'IPADDR="192.168.78.52"' $ETH0
	sed -i '/collabn2/d' /etc/hosts
        sed -i '1i192.168.78.52        collabn2.racattack        collabn2' /etc/hosts
fi

mkchg 'BOOTPROTO="static"' $ETH0
mkchg 'BOOTPROTO="static"' $ETH1
mkchg 'ONBOOT="yes"' $ETH0
mkchg 'ONBOOT="yes"' $ETH1
mkchg 'NETMASK="255.255.255.0"' $ETH0
mkchg 'NETMASK="255.255.255.0"' $ETH1
mkchg 'PEERDNS="no"' $ETH0
mkchg 'PEERDNS="no"' $ETH1
mkchg 'PEERDNS="no"' $ETH2
mkchg '224.0.0.0\/24 dev eth1' $ETH1RT


# Disable selinux
mkchg 'SELINUX=disabled' /etc/selinux/config

# Disable the firewall
service iptables stop
chkconfig iptables off
