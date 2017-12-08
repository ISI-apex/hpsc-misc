sudo gdb --args /home/dkang/git-Xilinx/qemu-ref-build/aarch64-softmmu/qemu-system-aarch64 \
	-net nic -net nic -net nic -net nic,netdev=net0,macaddr=52:54:00:12:34:02 \
	-netdev tap,id=net0,ifname=tap0,script=no,downscript=no \
	-device loader,addr=0x6000000,file=tmp/deploy/images/zcu102-zynqmp/core-image-minimal-zcu102-zynqmp-20170714142939.rootfs.cpio.gz.u-boot,force-raw=true \
	-nographic -serial mon:stdio -serial null \
	-hw-dtb tmp/deploy/images/zcu102-zynqmp/qemu-hw-devicetrees/multiarch/zcu102-arm.dtb \
	-global xlnx,zynqmp-boot.cpu-num=0 -global xlnx,zynqmp-boot.use-pmufw=true \
	-device loader,file=DK/arm-trusted-firmware.elf,cpu-num=0 \
	-device loader,file=tmp/deploy/images/zcu102-zynqmp/u-boot.elf \
	-device loader,addr=0x4000000,file=tmp/deploy/images/zcu102-zynqmp/Image-zynqmp-zcu102-revB.dtb \
	-device loader,addr=0x80000,file=tmp/deploy/images/zcu102-zynqmp/Image \
	-machine arm-generic-fdt  -m 4096 -machine-path /tmp/qemu \
	-D ./apu-ref.log -d int,guest_errors,in_asm,fdt
#sudo gdb --args /home/dkang/yocto/poky/build/tmp/work/x86_64-linux/qemu-xilinx-helper-native/1.0-r1/recipe-sysroot-native/usr/bin//qemu-xilinx/qemu-system-aarch64 -net nic -net nic -net nic -net nic,netdev=net0,macaddr=52:54:00:12:34:02 -netdev tap,id=net0,ifname=tap0,script=no,downscript=no -device loader,addr=0x6000000,file=tmp/deploy/images/zcu102-zynqmp/core-image-minimal-zcu102-zynqmp-20170714142939.rootfs.cpio.gz.u-boot,force-raw=true -nographic -serial mon:stdio -serial null -hw-dtb tmp/deploy/images/zcu102-zynqmp/qemu-hw-devicetrees/multiarch/zcu102-arm.dtb -global xlnx,zynqmp-boot.cpu-num=0 -global xlnx,zynqmp-boot.use-pmufw=true -device loader,file=DK/arm-trusted-firmware.elf,cpu-num=0 -device loader,file=tmp/deploy/images/zcu102-zynqmp/u-boot.elf  -device loader,addr=0x4000000,file=tmp/deploy/images/zcu102-zynqmp/Image-zynqmp-zcu102-revB.dtb -device loader,addr=0x80000,file=tmp/deploy/images/zcu102-zynqmp/Image -machine arm-generic-fdt  -m 4096 -machine-path /tmp/qemu -D ./apu-ref.log -d int,guest_errors,in_asm,fdt
