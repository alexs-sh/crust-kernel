#!/bin/sh
ORIGDIR=orig
MODDIR=mod
LINUXVER=linux-imx-rel_imx_4.9.x_1.0.0_ga
echo "*--------------------------------------------------------*"
echo "|                   Patch creator                        |"
echo "*--------------------------------------------------------*"
echo "ORIGINAL DIR: $ORIGDIR"
echo "MODIFIED DIR: $MODDIR"

mkdir -p configs
mkdir -p patches/linux
mkdir -p patches/uboot

# buildroot config
echo "1.Copy config/overlay"
cp $MODDIR/configs/crust_imx6ull_base_defconfig ./configs || echo "Error"
cp -r  $MODDIR/rootfs . || echo "Error"

# device tree include
echo "2.Create imx6ull.dtsi patch"
diff -Nar -U 3 "$ORIGDIR/output/build/$LINUXVER/arch/arm/boot/dts/imx6ull.dtsi" "$MODDIR/output/build/$LINUXVER/arch/arm/boot/dts/imx6ull.dtsi" > 1-imx6ull.dtsi.patch 
sed -i "s|$ORIGDIR/output/build/$LINUXVER|a|" 1-imx6ull.dtsi.patch || echo "Error1"
sed -i "s|$MODDIR/output/build/$LINUXVER|b|" 1-imx6ull.dtsi.patch || echo "Error2"
mv 1-imx6ull.dtsi.patch patches/linux

# device tree for out board
echo "3.Create imx6ull-14x14-nano.dts patch"
diff -Nar -U 3 /dev/null "$MODDIR/output/build/$LINUXVER/arch/arm/boot/dts/imx6ull-14x14-nano.dts" > 2-imx6ull-14x14-nano.dts.patch
sed -i "s|/dev/null|a/arch/arm/boot/dts/imx6ull-14x14-nano.dts|" 2-imx6ull-14x14-nano.dts.patch
sed -i "s|$MODDIR/output/build/$LINUXVER|b|" 2-imx6ull-14x14-nano.dts.patch
mv 2-imx6ull-14x14-nano.dts.patch patches/linux

# device tree for out board
echo "4.Create uboot-load patch"
PATCHED_FILE=output/build/uboot-imx-rel_imx_4.9.x_1.0.0_ga/include/configs/mx6ullevk.h
diff -Nar -U 3  "$ORIGDIR/$PATCHED_FILE" "$MODDIR/$PATCHED_FILE" > 1-mx6ullevk.h.patch
sed -i "s|$ORIGDIR/output/build/uboot-imx-rel_imx_4.9.x_1.0.0_ga|a|"  1-mx6ullevk.h.patch
sed -i "s|$MODDIR/output/build/uboot-imx-rel_imx_4.9.x_1.0.0_ga|b|"   1-mx6ullevk.h.patch
mv 1-mx6ullevk.h.patch patches/uboot


echo "Done"
