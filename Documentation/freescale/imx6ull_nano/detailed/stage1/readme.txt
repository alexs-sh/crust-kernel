0. Основыне пакеты и инструменты
  - buildroot2017.02.6 
  - Linux 4.9.11 от Freescale IMX
  - Загрузчик u-boot для 4.9.11 от Freescale IMX
  - Так же в системе установлены uboot-tools, чтобы не собирать их вручную. (u-boot-tools для Debian)
  - см. примечание #2
1. Скачать и распаковать buildroot
2. Скопировать папки configs,patches,rootfs в buildroot 
3. Перейти в директорию buildroot
4. Выбрать конфиг и запустить сборку
  -  make crust_imx6ull_base_defconfig
  -  make
В случае проблем см. Примечание # 2


Как правило, проблемы возникают с версиями пакетов, так что проблема решается переходом на более новый.  

5. Сборка через какое-то время остановится на u-boot, шаг mv _libfdt.so tools/_libfdt.so
  Проблема связана с тем, что uboot от imx создает библиотеку с другим именем. Надо переименовать.
  - cp output/build/uboot-imx-rel_imx_4.9.x_1.0.0_ga/_libfdt.cpython-36m-x86_64-linux-gnu.so  output/build/uboot-imx-rel_imx_4.9.x_1.0.0_ga/_libfdt.so
  - make
6. дождаться окончания сборки
7. перейти в папку buildroot/output/images/ и проверить наличие файлов:
  - zImage
  - rootfs.tar
  - imx6ll-14x14-nano.dtb
  - u-boot.bin
8. сделать образ загрузчика для записи на SD карту.
  mkimage -n ../build/uboot-imx-rel_imx_4.9.x_1.0.0_ga/board/freescale/mx6ullevk/imximage.cfg.cfgtmp -T imximage -e 0x87800000 -d u-boot.bin u-boot.imx
9. подготовить SD-карту. В примере SD-карта видна как /dev/mmcblk0
  9.1 Очистить
    dd if=/dev/zero of=/dev/mmcblk0 bs=1M count=32
    sync
  9.2 Создать разделы. 
    Ядро и dtb - в первом разделе, rootfs - во втором.
    Размер первого раздела - 128-512 Мб
    Второго - все остальное, но не более 3.2 - 4 Gb (это обусловлено размером памяти девайса).
    fdisk /dev/mmcblk0
    Далее приведен пример работы fdisk.
    --> - отметки, где требуется пользоватльский ввод. Если ввод пустой, то был нажат Enter.

  *****************************************************************************
    --> Command (m for help): o
    Created a new DOS disklabel with disk identifier 0x0bea681a.

    --> Command (m for help): n
    Partition type
       p   primary (0 primary, 0 extended, 4 free)
       e   extended (container for logical partitions)
    --> Select (default p): p
    --> Partition number (1-4, default 1): 1
    --> First sector (2048-15273983, default 2048): 
    --> Last sector, +sectors or +size{K,M,G,T,P} (2048-15273983, default 15273983): +128M

    Created a new partition 1 of type 'Linux' and of size 128 MiB.

    --> Command (m for help): n
    Partition type
       p   primary (1 primary, 0 extended, 3 free)
       e   extended (container for logical partitions)
    --> Select (default p): 

    Using default response p.
    --> Partition number (2-4, default 2): 
    --> First sector (264192-15273983, default 264192): 
    --> Last sector, +sectors or +size{K,M,G,T,P} (264192-15273983, default 15273983): +3G

    Created a new partition 2 of type 'Linux' and of size 3 GiB.

    --> Command (m for help): w

*****************************************************************************
  9.3 Создать ФС
  mkfs.vfat /dev/mmcblk0p1
  mkfs.ext2 /dev/mmcblk0p2
  Раздел с ядром и dts в FAT. rootfs в ext2 (можно использовать и другие)
10. Записать загрузчик
  dd if=u-boot.imx of=/dev/mmcblk0 bs=512 seek=2
  sync
11. Записать ядро и описание переферии
  Примонтировать 1-й раздел и скопировать на него zImage и dtb-файл.(В примере раздел примонтирован в /run/media/user/4AFB-C988)
  cp zImage imx6ull-14x14-nano.dtb /run/media/alexs/4AFB-C988
  sync
12. Записать rootfs
  Примонтировать второй раздер и распаковать файлы из rootfs.tar (В примере раздел примонтирован в /run/media/alexs/214d868b-31b4-493b-b8ef-e0d061bfb37c)
  bsdtar -xvf rootfs.tar -C/run/media/alexs/214d868b-31b4-493b-b8ef-e0d061bfb37c
  sync
13. Отмонтировать разделы
14. Проверить
  14.1 Вставляем флешку в девайс, подключаем по USB, коннектимся по посл. порту (115200 8N1),
  постоянно жмем Enter (первые 3 секнды u-boot не грузит систему и ждет, что ему придут команды из вне)
  14.2 Прописываем загрузку с флеш и стартуем
    Обычная версия
    setenv mmcdev 0
    setenv mmcroot /dev/mmcblk0p2 rootwait rw
    boot

    Версия с initrd
    setenv mmcdev 0
    setenv mmcroot /dev/mmcblk0p2 rootwait rw
    setenv initrd_file rootfs.cpio.uboot
    setenv fdt_file imx6ull-14x14-nano.dtb
    fatload mmc ${mmcdev}:${mmcpart} ${loadaddr} ${image}
    fatload mmc ${mmcdev}:${mmcpart} ${fdt_addr} ${fdt_file}
    fatload mmc ${mmcdev}:${mmcpart} ${initrd_addr} ${initrd_file}
    bootz ${loadaddr} ${initrd_addr} ${fdt_addr}
    Ждем появления сл. строк:
    Crust loader:x.x.x
    Crust rootfs:/dev/*
    echo "Enter 'y' to stop...
    Система ждет ввода y в течение 3 сек. Вводим и проверяем систему.
     
  14.3 логин: root
  14.4 для работы с сетью есть ifconfig, dhcpcd, ssh, telnen, wget. Для посл. порта - minicom. (ttymxc0 - USB-порт, ttymxc1-2 - реальные порты)
  14.5 Пример проверки ssh
    dhcpcd - запуск dhcp - клиента и получение адреса
    ip addr - смотрим ip для eth0
    подключаемся по ssh с компа ssh root@10.42.0.179. Пароль не нужен.

15. Запись во внутреннюю память устройства
  
  Обычная версия
  dd if=/dev/mmcblk0 of=/dev/mmcblk1 bs=10M count=360
  sync
  reboot

  Версия с initrd
  setenv mmcdev 0
  setenv mmcroot /dev/mmcblk0p2 rootwait rw
  setenv initrd_file rootfs.cpio.uboot
  setenv fdt_file imx6ull-14x14-nano.dtb
  fatload mmc ${mmcdev}:${mmcpart} ${loadaddr} ${image}
  fatload mmc ${mmcdev}:${mmcpart} ${fdt_addr} ${fdt_file}
  fatload mmc ${mmcdev}:${mmcpart} ${initrd_addr} ${initrd_file}
  bootz ${loadaddr} ${initrd_addr} ${fdt_addr}
  Ждем появления сл. строк:
  Crust loader:x.x.x
  Crust rootfs:/dev/*
  echo "Enter 'y' to stop...
  Система ждет ввода y в течение 3 сек. Вводим и из сервесиного режима
  переписываем данные c SD-карты на внутр. память.
  dd if=/dev/mmcblk0 of=/dev/mmcblk1 bs=10M count=360
  sync
  reboot

  *bs и count зависят от разметки на SD-карте. В среднем запись длиится 7-10 минут.

Примачание #1:
Иногда загрузка архивов Linux и U-Boot через git происходит очень медленно. Чтобы ускорить процесс, 
можно скачать архивы вручную и положить в папку dl

Архивы:
linux-imx-rel_imx_4.9.x_1.0.0_ga.tar.gz
uboot-imx-rel_imx_4.9.x_1.0.0_ga.tar.gz

Сайт:
http://git.freescale.com/git/cgit.cgi/imx/linux-imx.git/tag/?id=rel_imx_4.9.x_1.0.0_ga
http://git.freescale.com/git/cgit.cgi/imx/uboot-imx.git/tag/?id=rel_imx_4.9.x_1.0.0_ga

Примачание #2:
* Если на этапе make crust_imx6ull_base_defconfig будет выведено сообщение вида: ** "You have legacy configuration in your .config!
> Please check your configuration.".  то версия buildroot новее, чем та, которой был сделан конфиг. В новой версии убраны устаревшие параметры (пакеты).
Решение #1:
- make menuconfig
- пункт Legacy config options
- отключить/заменить устаревшие параметры
Решение #2:
Загрузить более старую версию buildroot (версия указана в п. 0)

Полезные ссылки:
Руководство:
https://buildroot.org/downloads/manual/manual.html

Пакеты, требуемые для сборки:
https://buildroot.org/downloads/manual/manual.html#requirement-mandatory

https://buildroot.org/download.html - акутальные версии buildoot
https://buildroot.org/downloads/ - полный перечень версий buildoot, доступные для загрузки
