I. Debian Rootfs (minimal)
1. Качаем основные пакеты
cd /
sudo mkdir -p chroot
cd chroot
sudo debootstrap --arch=armhf --variant=minbase --foreign stretch minimal
sudo cp /usr/bin/qemu-arm-static /chroot/minimal/usr/bin/

2. Переключаемся в скачанную систему и конфижим
sudo chroot minimal
export distro=stretch    
export LANG=C
/debootstrap/debootstrap --second-stage

Ставим доп. пакеты
apt update
apt upgrade
apt install ssh tar network-manager tzdata locales nano
ln -s /lib/systemd/systemd /sbin/init

cd /etc
rm resolv.conf
ln -s /var/run/NetworkManager/resolv.conf resolv.conf

Настраиваем пользователя
passwd <задать пароль рута>

Разрешаем руту логиниться по ssh.
Для этого указать PermitRootLogin yes в /chroot/minimal/etc/ssh/sshd_config

Конфигурация минимальной системы на этом закончена.
Выполянем exit, чтобы завершить chroot и вернутся в хостовую систему

3. Создаем архив
cd minimal
sudo bsdtar -cvf ../roofs.min.tar *

4. Записываем rootfs на карту
Переходим на  SD-карту
cd /run/media/alexs/2364d486-ebec-43d7-b5a7-4a1c15862829/ (путь к разделу на SD карте может быть другим)
Очищаем
sudo rm -rf * (либо заново создать ext2 на диске)
Распаковать КФС
sudo bsdtar -xvf '/tmp/rootfs.min.tar' (путь к архиву может быть другим)
sync
Отключаем карту и проверяем новую КФС

5. Записываем новый КФС из сервисного режима
Подключить устройство по USB
Подождать, когда устройство запросит загрузку в сервисный режим:
Crust loader:xxxxxx
Crust rootfs:/dev/xxxxx
Enter 'y' to stop...
Ответить y и нажать Enter

cd /tmp
mkdir src dst
mount /dev/mmcblk0p2 src
mount /dev/mmcblk1p2 dst
rm -rf dst/*
cp -fr src/* dst/
sync
reboot
Если в устройстве нет сервисного режима, то см. инструкцию по созданию ядра и загрузчика.

