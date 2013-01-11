# About piscreen

*piscreen* is a small, Chromium based, Kiosk/Digital Signage solution for the [Raspberry Pi](http://raspberrypi.org).


The difference to other signage-software like [Screeny OSE](https://github.com/wireload/screenly-ose) is that it supports just one static URL that it displays - but it provides nice error screens when your network/the internet is not reachable.

# Installation
## 1. Preparing the SD card

1. Get the latest [MoebiusLinux](http://moebiuslinux.sourceforge.net/) for your Raspberry Pi and write it to the SD card with dd (on Linux & Mac):

        tar -zxvf moebius.minimal.image.1.0.1.tar.gz
        dd bs=1M if=moebius.minimal.image of=/dev/sdX

  You can also write to the SD card with [Win32DiskImager](https://wiki.ubuntu.com/Win32DiskImager) if you are using Windows. 

2. Insert the SD in the Raspberry Pi and power it on

## 2. Basic (manual) Updating & Configuration

1. Log in as *root* with the Password: *raspi*. If the password doesn't work look in the [Moebius FAQ](http://moebiuslinux.sourceforge.net/documentation/faq/).

2. A basic auto-configuration tool should appear (if not, start `raspi-config`). 
  
  Set your keyboard-layout, timezone, overscan-settings (if you see black borders on your screen), overclock (tip: use Medium) and resize the root partition. A reboot should happen. After the resizing login again.

3. Update the System

        apt-get update
        apt-get -y dist-upgrade

  If a conflict happens for any file press `Y`.

4. Change the password of root: `passwd`

5. Reboot the Pi: `reboot`

## 3. Setup the automatic installation

1. Login again as *root* with your new password.

2. Install Git: `apt-get install git-core`

3. Checkout the files of this repo: `git clone https://github.com/robbi5/piscreen.git ./screen`

4. Run the automatic installer: `bash screen/setup.sh`

## 4. Fill your piscreen configuration

Insert the SD card in your regular computer and edit the `piscreen.txt` in the root folder of the SD card.
Attention: You must not use spaces between the key, the = and the value.

## 5. Test and run

Insert the SD card back into the Raspberry Pi and power it on. It should now boot, open chrome in fullscreen with your desired URL.

To shutdown it nicely, press `ALT+F4`, rightclick, choose *Terminal* and enter `sudo poweroff`.

# Todo

* Read the hostname from `piscreen.txt` and set it on boot.
* Add a wallpaper, overlay start-time, hostname and current ip
* Support proxies
* Add nicer shutdown button

# Thanks

[Screeny OSE](https://github.com/wireload/screenly-ose) and the [Raspberry Pi forums](http://www.raspberrypi.org/forum) for the inspiration.

[hexxeh](http://hexxeh.net) for the [RPi Binaries of Chromium](http://hexxeh.net/?p=328117859).

ben for [Moebius Linux](http://moebiuslinux.sourceforge.net), a minimal installation of [Raspbian](http://raspbian.org).
