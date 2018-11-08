1. Скачать архив 
wget http://os.archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz

2. Распаковать на SD-карту
su
bsdtar -xpf ArchLinuxARM-armv7-latest.tar.gz -C /run/media/sd-card-part1
sync

Примачание:
Раздел в формате ext2
Путь к разделу SD-карты будет отличаться от того, что приведен выше
bsdtar выдаст сообщения <....> Failed to set file flags - ничего страшного

3. Записать КФС на устройство в раздел /dev/mmcblk1p2
Например,
cd /tmp
mkdir src dst
mount /dev/mmcblk0p2 src
mount /dev/mmcblk1p2 dst
rm -rf dst/*
cp -fr src/* dst/
sync
reboot

Либо воспользоваться командой dd



