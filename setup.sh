#!/bin/bash 
# 1 target ip
# 2 target port
# 3 baudrate
# 4 target dir
# 5 installation dir
function pause(){
        read -n 1 -p "$*" INP
        if [ $INP != '' ] ; then
                echo -ne '\b \n'
        fi
}
if [[ "$USER" != "root" ]]; then
	echo "please run this script as root!"
	exit 99
fi
/usr/bin/apt-get update
/usr/bin/apt-get install -y ppp python-wxgtk2.8 python-matplotlib python-opencv python-pip python-numpy
work_path='/srv/DTR-3G/'
if [ -n $4 ]; then
	work_path=$4
fi
/bin/mkdir -p $work_path
/bin/cp "${5}/chatscript" $work_path
echo /sbin/route add $1 dev \${IFNAME} > /etc/ppp/ip-up.d/3G
/bin/chmod +x /etc/ppp/ip-up.d/3G
/bin/mv /etc/rc.local /etc/rc.local.bak
echo \#\!/bin/bash > /etc/rc.local
echo "/usr/sbin/pppd /dev/ttyUSB2 connect \"chat -v -f ${5}/chatscript \"" >> /etc/rc.local
/usr/bin/pip install mavproxy
/bin/cp /etc/inittab /etc/inittab.bak
/bin/sed -i "/^T0:23:respawn/c #" /etc/inittab
/bin/cp /boot/cmdline.txt /boot/cmdline.txt.bak
/bin/sed -i "/^dwc_otg.lpm_enable=0/c dwc_otg.lpm_enable=0 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait" /boot/cmdline.txt
echo "/usr/bin/nohup /usr/local/bin/mavproxy.py --master=/dev/ttyAMA0 --baudrate ${3} --out ${1}:${2} --aircraft MyCopter &" >> /etc/rc.local 
echo "exit 0" >> /etc/rc.local
pause "system will reboot, please press any key to continue..."
/sbin/reboot
