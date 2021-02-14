#!/bin/sh
set -eu

OS_URL=http://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2020-05-28/2020-05-27-raspios-buster-lite-armhf.zip

WIFI_COUNTRY=CA
WIFI_SSID=some-ssid
WIFI_PASS=some-pass

color_echo() {
    printf "\e[$1m==> %s\e[0m\n" "$2"
}

green() {
    color_echo "1;32" "$1"
}

green "Downloading ${OS_URL}"
if [ -f os.zip ]; then
    green "Skipping download; os.zip already exists"
else
    curl -Lo os.zip "${OS_URL}"
fi

green "Decompressing OS"
unzip -p os.zip >os.img

green "Listing disks"
diskutil list

green "Enter disk number"
read DISK_NUM

DISK="/dev/disk${DISK_NUM}"
RDISK="/dev/rdisk${DISK_NUM}"

green "Will copy to ${DISK}"

green "Unmounting disk"
diskutil unmountDisk "${DISK}"

green "Copying image"
sudo dd bs=1m if=os.img of="${RDISK}"
sync

# Can we get rid of this?
sleep 3

green "Setting up Wi-Fi and SSH"
cat >/Volumes/boot/wpa_supplicant.conf <<EOF
country=${WIFI_COUNTRY}
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
    ssid="${WIFI_SSID}"
    psk="${WIFI_PASS}"
}
EOF
touch /Volumes/boot/ssh

green "Ejecting disk"
diskutil eject "${RDISK}"
