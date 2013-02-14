#!/bin/bash

echo "Installing piscreen"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "Checking for IPv6..."
if [ `lsmod | grep -o ^ipv6` ]; then
  echo "IPv6 is already enabled. Good!"
else
  rm /etc/sysctl.d/disableipv6.conf
  modprobe ipv6
  echo "ipv6" >> /etc/modules
fi

echo "Installing dependencies"
apt-get -y install openbox evilvte hsetroot x11-xserver-utils unclutter avahi-daemon imagemagick chkconfig xinit nodm watchdog

echo "Creating screen user"
useradd -m screen

echo "Installing nodm auto login"
sed -e 's/NODM_ENABLED=.*$/NODM_ENABLED=true/g' -i /etc/default/nodm
sed -e "s/NODM_USER=.*$/NODM_USER=screen/" -i /etc/default/nodm

echo "Enabling Watchdog"
modprobe bcm2708_wdog
cp /etc/modules /etc/modules.bak
sed '$ i\bcm2708_wdog' -i /etc/modules
chkconfig watchdog on
cp /etc/watchdog.conf /etc/watchdog.conf.bak
sed -e 's/#watchdog-device/watchdog-device/g' -i /etc/watchdog.conf
/etc/init.d/watchdog start

echo "Adding piscreen config-file"
cp ./screen/piscreen.example.txt /boot/piscreen.txt
chmod ugo+r /boot/piscreen.txt

echo "Installing Google Chrome"
bash <(curl -sL http://distribution-us.hexxeh.net/chromium-rpi/install.sh)
update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/chrome 100

echo "Creating openbox autostart"
mkdir /home/screen/.config
mkdir /home/screen/.config/openbox
touch /home/screen/.config/openbox/autostart
echo "~/piscreen/autostart &" >> /home/screen/.config/openbox/autostart
chown -R screen /home/screen/.config

echo "Copying piscreen files"
cp -r ./screen/piscreen /home/screen/
chown -R screen /home/screen/piscreen
chmod +x /home/screen/piscreen/start-browser.sh
chmod +x /home/screen/piscreen/autostart

echo "Allowing screen shutdown"
echo "screen ALL=(ALL) NOPASSWD: /sbin/shutdown, /sbin/poweroff, /sbin/reboot" >> /etc/sudoers

# echo "Adding shutdown-menu entries"
# FIXME: add openbox menu.xml with entries for shutdown & restart

echo "Assuming no errors were encountered, go ahead and restart the pi."
