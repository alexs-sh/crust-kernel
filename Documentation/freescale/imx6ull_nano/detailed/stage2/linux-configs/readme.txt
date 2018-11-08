Пересборка ядра
1. положить .config  в <buildroot>/output/build/linux-imx-rel_imx_4.9.x_1.0.0_ga/
2. положить dts/dtsi в <buildroot>/output/build/linux-imx-rel_imx_4.9.x_1.0.0_ga/arch/arm/boot/dts/
3. очистить сборку и удалить отметки buildroot
  cd <buildroot>/output/build/linux-imx-rel_imx_4.9.x_1.0.0_ga/
  rm .stamp_built .stamp_images_installed .stamp_target_installed
  make clean
  make ARCH=arm oldconfig
4. запустить сборку
  cd <buidlroot>
  make
5. для изменения конфигурации ядра
  cd <buildroot>/output/build/linux-imx-rel_imx_4.9.x_1.0.0_ga/
  make ARCH=arm menuconfig / make ARCH=arm nconfig / make ARCH=arm gconfig / make ARCH=arm xconfig
  Сохранить и пересобрать
