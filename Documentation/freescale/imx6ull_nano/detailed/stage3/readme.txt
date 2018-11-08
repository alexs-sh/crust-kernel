При создании рутфс обратить внимание на сл. моменты

1. Сеть

  1.1 Если выбрали работу через NetworkManager
    - Убьедится, что службы NetworkManager включены. 
    - /etc/resolv.conf заполняется значениями в зависимости от выбранной конфигурации. Конфигурации не перезаписываются
  другими программами (dhpcd/resolvconf). Имя программы, создавщей файл, написано в первой строке файла
    - В 95% случаев при использовании NetworkManager resolv.conf является ссылкой на resolv.conf в NetworkManager (обычно /var/run/NetworkManager/). 
  Если это не так, убедится, что вы знаете почему так сделано. 

  1.2 Если выбрали ручную работу с сетью, то
    - Убедиться, что NetworkManager не устновленл / или его службы отключены
    - /etc/resolv.conf - файл. Если предпологается работа только по ip-адресам, то файл может быть пустым.
  Если потребуется dns без dhcp, то файл должен содержать информацию о name-серверах, например
  nameserver 192.168.1.1
    - Убедится, что файл не перезаписывается другими программами в процессе работы
  Если используеся dhcp, файл заполняется автоматически
    - Если предпологается работа с dhcp, то должен быть установлен dhcp-клиент. Например, dhcpcd

    - /etc/hosts - существует и в нем указаны localhost и имя девайса. Например,
  127.0.0.1 device
  127.0.0.1 localhost
  Характерным признаком ошибки в hosts является долгий запуск команды sudo, т.к. она будет искать
  имя устройства в hosts пока не истечет таймаут

    - /etc/network/interfaces - содержит конфиги сети. 


2. Языковая поддержка

  - Убедится, что локали установлениы и в файле /etc/locale.gen прописаны необходмые.
  Обычно это 
  en_US.UTF-8 UTF-8
  ru_RU.UTF-8 UTF-8
  - Убедится, что после настройка locale.gen была выполнена команда locale-gen 
  - Убедится, что локаль по умолчанию прописана в /etc/locale.conf
  Например,
  LANG=en_US.UTF-8 

3. Дата / время
  - Убедится, что установлен часовой пояс (tzdata)
  - Убедится, что для RTC(hwclock) задан корректный режим работы (utc / local)
  - Убедится, что синхронизация по NTP включена (systemd-timesyncd / ntpd), 
  - Убедится, что нет одновременно работающих служб (либо systemd-timesyncd, либо ntpd, либо ручной ntpdate)
  - Убедится, что синхронизация работает для системных (date) и железных (hwclock). 
  - Убедится, что RTC работает. Для этого убедится, что чип RTC подключен к независимому источнику питания, 
  снять общее питание с устройства, подождать 1-2 минуты, включить без возможности связаться с NTP, проверить системное и аппаратное время.
  
4. ФС
  - Убедится, что утсановлен пакет ntfs-3g, если планируется работать с NTFS

5. Общее
  - Убедится, что размер логов ограничен (journalctl, /etc/systemd/journald.conf), либо syslog отключен
  - Убедится, что суперпользователь (root) создан и запоролен. Команда su (не sudo !) работает нормально.
  - Убедится, что отключены лишние службы, типа автоообновления (apt-dayly-update и т.п.)
  Примерный перечень служб:
  autovt@.service                        enabled  
  cron.service                           enabled  
  getty@.service                         enabled  
  networking.service                     enabled  
  pppd-dns.service                       enabled  
  rsyslog.service                        enabled  
  ssh.service                            enabled  
  sshd.service                           enabled  
  syslog.service                         enabled  
  systemd-networkd-wait-online.service   enabled  
  systemd-networkd.service               enabled  
  systemd-timesyncd.service              enabled 


Ссылки для скачивания готовых КФС / установщиков
ArchLinux: https://archlinuxarm.org/platforms/armv7
Debian: http://http.us.debian.org/debian/dists/stretch/main/
Ubuntu: http://cdimage.ubuntu.com/ubuntu-base/releases/16.04/release/
Fedora: https://arm.fedoraproject.org/

