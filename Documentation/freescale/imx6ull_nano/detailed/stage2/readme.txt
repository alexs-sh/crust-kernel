Обновление ядра / конфигурации
Скопировать новое ядро / dtb на SD-карту и подключить карту к устройству
Загрузить устройство и выполнить сл. команды от суперпользователя

cd /tmp
mkdir src dst
mount /dev/mmcblk0p1 src
mount /dev/mmcblk1p1 dst
cp src/* dst/
sync
umount /tmp/src
umount /tmp/dst
reboot

