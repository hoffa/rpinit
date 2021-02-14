#!/bin/sh
#
# https://www.raspberrypi.org/documentation/installation/installing-images/mac.md
#
set -e

OS_URL=http://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-01-12/2021-01-11-raspios-buster-armhf-lite.zip
OS_CHECKSUM=d49d6fab1b8e533f7efc40416e98ec16019b9c034bc89c59b83d0921c2aefeef

first_word() {
    awk '{ print $1 }'
}

# $1 - filename
# $2 - checksum
check_sha256sum() {
    test "$(shasum -a 256 "$1" | first_word)" = "$2"
}

guess_sd_disk() {
    diskutil list | grep external | head -n 1 | first_word
}

cecho() {
    printf "\e[$1m==> %s\e[0m\n" "$2"
}

green() {
    cecho "1;32" "$1"
}

yellow() {
    cecho "1;33" "$1"
}

red() {
    cecho "1;31" "$1"
}

fatal() {
    red "$@"
    exit 1
}

prompt() {
    printf "\e[1;32m==> %s\e[0m" "$2"
    read -r "$1"
}

if [ -z "${WIFI_COUNTRY}" ] || [ -z "${WIFI_SSID}" ] || [ -z "${WIFI_PASSWORD}" ]; then
    fatal "WIFI_COUNTRY, WIFI_SSID and WIFI_PASSWORD must be set"
fi

green "Available disks"
diskutil list

guess=$(guess_sd_disk)
if [ -z "${guess}" ]; then
    yellow "Are you sure an SD card is inserted?"
else
    green "Guessing the SD card is ${guess}"
fi
prompt DISK_NUM "Enter disk number: "

DISK="/dev/disk${DISK_NUM}"
RDISK="/dev/rdisk${DISK_NUM}"

if [ -f os.zip ]; then
    green "Skipping download; os.zip already exists"
else
    green "Downloading ${OS_URL}"
    curl -Lo os.zip "${OS_URL}"
fi

green "Verifying integrity"
check_sha256sum os.zip "${OS_CHECKSUM}"

green "Decompressing OS"
unzip -p os.zip >os.img

green "Unmounting ${DISK}"
diskutil unmountDisk "${DISK}"

green "Copying os.img to ${RDISK}"
sudo dd bs=1m if=os.img of="${RDISK}"

green "Waiting for data to be flushed"
sync
sleep 5 # Can we get rid of this?

# https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md
green "Setting up Wi-Fi"
cat >/Volumes/boot/wpa_supplicant.conf <<EOF
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=${WIFI_COUNTRY}
network={
    ssid="${WIFI_SSID}"
    psk="${WIFI_PASSWORD}"
}
EOF

# https://www.raspberrypi.org/documentation/remote-access/ssh/
green "Setting up SSH"
touch /Volumes/boot/ssh

green "Ejecting disk"
diskutil eject "${RDISK}"

green "Done"
