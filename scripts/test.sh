# 1st trial: now 1 stage boot works.
#sudo gdb --args /home/dkang/WORK/qemu-build-multi/aarch64-softmmu/qemu-system-aarch64 -net nic -net nic -net nic -net nic,netdev=net0,macaddr=52:54:00:12:34:02 \
#	-device loader,addr=0xfd1a0104,data=0x800000fe,data-len=4 \
#	-netdev tap,id=net0,ifname=tap0,script=no,downscript=no \
#	-device loader,addr=0x6000000,file=tmp/deploy/images/zcu102-zynqmp/core-image-minimal-zcu102-zynqmp-20170714142939.rootfs.cpio.gz.u-boot,force-raw=true \
#	-nographic -serial mon:stdio -serial null -hw-dtb DK/hw-single.dtb -global xlnx,zynqmp-boot.cpu-num=0 \
#	-device loader,file=DK/bl31.elf,cpu-num=0 \
#	-device loader,addr=0x4000000,file=DK/linux-single.dtb \
#	-device loader,addr=0x80000,file=DK/Image-test \
#	-device loader,file=DK/u-boot.test.elf \
#	-machine arm-generic-fdt,accel=tcg -m 4096 -machine-path /tmp/qemu 
##	-device loader,file=tmp/deploy/images/zcu102-zynqmp/u-boot.elf  \
##	-D ./apu-test.log -d int,guest_errors,in_asm,fdt

# 2nd trial: the first Linux boot works, but the second proceed up to the point of "IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes readyc"
# 	     only 4 CPUs are up
#
#sudo gdb --args /home/dkang/WORK/qemu-build-multi/aarch64-softmmu/qemu-system-aarch64 -net nic -net nic -net nic -net nic,netdev=net0,macaddr=52:54:00:12:34:02 \
#	-device loader,addr=0xfd1a0104,data=0x800000fe,data-len=4 \
#	-netdev tap,id=net0,ifname=tap0,script=no,downscript=no \
#	-device loader,addr=0x6000000,file=tmp/deploy/images/zcu102-zynqmp/core-image-minimal-zcu102-zynqmp-20170714142939.rootfs.cpio.gz.u-boot,force-raw=true \
#	-nographic -serial mon:stdio -serial null -hw-dtb DK/hw-single.dtb -global xlnx,zynqmp-boot.cpu-num=0 \
#	-device loader,file=tmp/deploy/images/zcu102-zynqmp/arm-trusted-firmware.elf,cpu-num=0 \
#	-device loader,addr=0x4000000,file=DK/linux-single.dtb \
#	-device loader,addr=0x80000,file=DK/myImage \
#	-device loader,file=DK/u-boot.test.elf \
#	-machine arm-generic-fdt,accel=tcg -m 4096 -machine-path /tmp/qemu 
##	-D ./u-boot-test.log -d int,guest_errors,in_asm,fdt
##	-device loader,addr=0x80000,file=DK/Image-test \
##	-device loader,file=DK/bl31.elf,cpu-num=0 \
###	-device loader,file=tmp/deploy/images/zcu102-zynqmp/u-boot.elf  \

# 3rd trial: 
#	arm-trusted-firmware
#	linux-hpsc.dtb
#	myImage
#	u-boot.test.elf: JTAG Mode boot
#	--> stuck right before showing command prompt
#	1. u-boot.test.elf: UART Mode boot
#	--> Finally works!! but with only 4 CPUs "psci: failed to boot CPU4" ==> probably due to arm-trusted-firmware
#	2. use bl31 instead of arm-trusted-firmware
#	--> still only 4 CPUs are up "power state = (0, 0, 0, 0, 2, 2, 2, 2)" doesn't change.
#	3. removing "-global xlnx,zynqmp-boot.cpu-num=0" doesn't affect at all.
#	   removing ",accel=tcg -m 4096 -machine-path /tmp/qemu " doesn't affect at all.
#	   removing "-netdev tap,id=net0,ifname=tap0,script=no,downscript=no" doesn't affect at all.
#	   We should have used hpsc-single.dtb
#	   --> now all 8 cores are up and running.
#
#sudo gdb --args /home/dkang/WORK/qemu-build-multi/aarch64-softmmu/qemu-system-aarch64 -machine arm-generic-fdt \
#	-device loader,addr=0xfd1a0104,data=0x800000fe,data-len=4 \
#	-device loader,addr=0x6000000,file=tmp/deploy/images/zcu102-zynqmp/core-image-minimal-zcu102-zynqmp-20170714142939.rootfs.cpio.gz.u-boot,force-raw=true \
#	-nographic -serial mon:stdio -serial null \
#	-hw-dtb DK/hpsc-single.dtb \
#	-device loader,file=DK/bl31.elf,cpu-num=0 \
#	-device loader,addr=0x4000000,file=DK/linux-hpsc.dtb \
#	-device loader,addr=0x80000,file=DK/myImage \
#	-device loader,file=DK/u-boot.test.elf \
#	-net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1,hostfwd=tcp:127.0.0.1:10022-10.0.2.15:22 
##	-net nic,netdev=net0,macaddr=52:54:00:12:34:02 
##	-netdev tap,id=net0,ifname=tap0,script=no,downscript=no \
##	,accel=tcg -m 4096 -machine-path /tmp/qemu 
##	-global xlnx,zynqmp-boot.cpu-num=0 \
##	-device loader,file=tmp/deploy/images/zcu102-zynqmp/arm-trusted-firmware.elf,cpu-num=0 \
##	-D ./u-boot-test.log -d int,guest_errors,in_asm,fdt
##	-device loader,addr=0x80000,file=DK/Image-test \
##	-device loader,file=DK/bl31.elf,cpu-num=0 \
##	-device loader,file=tmp/deploy/images/zcu102-zynqmp/u-boot.elf  \


# 4th trial: 
#	integrated --> works fine.
#	However, we didn't test if ramdisk is loaded properly because myImage has rootfs in it.
#
#sudo gdb --args /home/dkang/WORK/qemu-build-multi/aarch64-softmmu/qemu-system-aarch64 -machine arm-generic-fdt \
#	-device loader,file=DK/myfsb.bin,addr=0xffff0000,cpu=0 \
#	-device loader,addr=0x6000000,file=tmp/deploy/images/zcu102-zynqmp/core-image-minimal-zcu102-zynqmp-20170714142939.rootfs.cpio.gz.u-boot,force-raw=true \
#	-nographic -serial mon:stdio -serial null \
#	-hw-dtb DK/hpsc-integrated.dtb \
#	-device loader,file=DK/bl31.elf,cpu-num=0 \
#	-device loader,addr=0x4000000,file=DK/linux-hpsc.dtb \
#	-device loader,addr=0x80000,file=DK/myImage \
#	-device loader,file=DK/u-boot.test.elf \
#	-net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1,hostfwd=tcp:127.0.0.1:10022-10.0.2.15:22 
##	-device loader,file=DK/m4fsb.bin,cpu=10 \
##	-device loader,file=DK/m4resetA53.bin,addr=0xfffdc000,cpu=10 \


# 5th trial: 
#	have ramfs separately
#	Using Zilinx Linux Image: 2nd SMP boot doesn't start
#	Made Linux Image without rootfs
#	u-boot:
#		Changed initrd_address of u-boot include/configs/xilinx_zynqmp.h
#				(original: 0xa00000 // this will overwrite kernel, so with this address kernel doesn't start
#				 changed:  0x6000000 // still fails to mount root fs "Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)"
#		Changed "loadbootenv_addr=0x2000000\0" from 0x100000
#				--> still the same
#
sudo gdb --args /home/dkang/WORK/qemu-build-multi/aarch64-softmmu/qemu-system-aarch64 -machine arm-generic-fdt \
	-device loader,file=DK/myfsb.bin,addr=0xffff0000,cpu=0 \
	-device loader,addr=0x6000000,file=tmp/deploy/images/zcu102-zynqmp/core-image-minimal-zcu102-zynqmp-20170714142939.rootfs.cpio.gz.u-boot,force-raw=true \
	-nographic -serial mon:stdio -serial null \
	-hw-dtb DK/hpsc-integrated.dtb \
	-device loader,file=DK/bl31.elf,cpu-num=0 \
	-device loader,addr=0x4000000,file=DK/linux-hpsc.dtb \
	-device loader,addr=0x80000,file=DK/myImage-wo-rootfs \
	-device loader,file=DK/u-boot.test.elf \
	-device loader,file=DK/m4fsb.bin,cpu=10 \
	-device loader,file=DK/m4resetA53.bin,addr=0xfffdc000,cpu=10 \
	-net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1,hostfwd=tcp:127.0.0.1:10022-10.0.2.15:22 


