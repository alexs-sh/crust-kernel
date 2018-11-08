0. Установить Ubuntu. Установить qemu и mk-sbuild
1. Запустить сборщик КФС и следовать инструкциям 
mk-sbuild --arch armhf xenial
По умолчанию КФС будут в /var/lib/schroot/chroots, но при первом запуске mk-sbuild предложит поменять
пути. Так же их можно изменить в файле .sbuildrc

2. Запустить в эмуляторе образ КФС
sudo schroot -c source:xenial-armhf -u root (дефолтные пути)

2.1 Установить пакеты
обязателно: udev
опционально: network-manager, boost, ssh, sudo, net-tools, tar ....

2.2 Настроить пользвателей:
добавить пароль для root'а (passwd)
создать новых, если необходимо и добавить их в группы (adduser / usermod)

2.3 При необходимости модифицировать конфиги сети / ssh

2.4 Очистить кэш пакетов 
  apt-get autoclean (удаляет устаревшие)
  apt-get clean	(чистит весь кэш)

3. Создаем архив с КФС
cd /var/lib/schroot/chroots/xenial-armhf
sudo tar -czf ../ubuntu-rootfs.tar.gz *

4. Распаковываем архив на SD-карту
sudo bsdtar -xpvf ubuntu-rootfs.tar.gz -C /run/media/sd-card-part1
sync

5. Записать КФС в устройство на /dev/mmcblk1p2
cd /tmp
mkdir src dst
mount /dev/mmcblk0p2 src
mount /dev/mmcblk1p2 dst
rm -rf dst/*
cp -fr src/* dst/
sync
reboot


Так же КФС можно собрать через debootstrap. См. сборку КФС для Debian

Полезные ссылки
https://wiki.ubuntu.com/ARM/RootfsFromScratch/QemuDebootstrap
