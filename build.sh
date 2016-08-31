#/bin/bash
#big thanks to moon.linux!!
#http://forum.odroid.com/viewtopic.php?f=136&t=23052

#clone odroidc2-3.14 kernel
git clone --depth 1 -b odroidc2-3.14.y https://github.com/hardkernel/linux.git odroidc2-3.14.y-rt
cd odroidc2-3.14.y-rt

#copy config file to current directory
cp ../odroidc2_defconfig .

#apply patches
patch -p1 < ../rt-fullarm64v2/0001-rt-patch-3.14.65-rt68.patch.patch
patch -p1 < ../rt-fullarm64v2/0002-arm64-Mark-PMU-interrupt-IRQF_NO_THREAD.patch
patch -p1 < ../rt-fullarm64v2/0003-arm64-Allow-forced-irq-threading.patch
patch -p1 < ../rt-fullarm64v2/0004-arch-arm64-Add-lazy-preempt-support.patch
patch -p1 < ../rt-fullarm64v2/0005-mmc-amlogic-convert-spin_lock_irq-to-raw_spin_lock_i.patch
patch -p1 < ../rt-fullarm64v2/0006-amports-fix-the-build-error-with-DEFINE_SPINLOCK.patch
patch -p1 < ../rt-fullarm64v2/0007-drivers-block-zram-Replace-bit-spinlocks-with-rtmute.patch
patch -p1 < ../rt-fullarm64v2/0008-drivers-block-zram-fixup-compile-for-RT.patch
patch -p1 < ../rt-fullarm64v2/0009-amlogic-hdmi-cec-use-a-simple-waitqueue.patch
patch -p1 < ../rt-fullarm64v2/0010-usb-otg-Convert-blocking-notifier-chain-to-SRCU.patch
patch -p1 < ../rt-fullarm64v2/0011-display-vout-Convert-blocking-notifier-chain-to-SRCU.patch
patch -p1 < ../rt-fullarm64v2/0012-defconfig-odroidc2-Realtime-Kernel-full-preemptive-f.patch

#Build the kernel using odroidc2_defconfig
#make mrproper
make odroidc2_defconfig
make -j4 dtbs Image modules LOCALVERSION=-xhkc2rt
make modules_install LOCALVERSION=-xhkc2rt

#install, backup, reboot
set +x
kernelversion=`cat ./include/config/kernel.release`
cp -v .config /boot/config-$kernelversion
echo "kernel version" $kernelversion
cp -v arch/arm64/boot/dts/meson64_odroidc2.dtb /media/boot/meson64_odroidc2-$kernelversion.dtb
cp -v arch/arm64/boot/dts/meson64_odroidc2.dtb /media/boot/meson64_odroidc2.dtb
cp -v arch/arm64/boot/Image /media/boot/Image-$kernelversion
cp -v arch/arm64/boot/Image /media/boot/Image
cp -v .config /media/boot/config-$kernelversion
update-initramfs -c -k ${kernelversion}
mkimage -A arm64 -O linux -T ramdisk -a 0x0 -e 0x0 -n /boot/initrd.img-${kernelversion} -d /boot/initrd.img-${kernelversion} uInitrd-${kernelversion}
cp uInitrd-${kernelversion} /media/boot/uInitrd
sync
reboot

