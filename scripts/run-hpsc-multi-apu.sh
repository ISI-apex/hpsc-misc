# This should work with the other Qemu PMU.
# This does not work, yet!

sudo gdb --args /home/dkang/WORK/qemu-build-single/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
	-device loader,file=DK/bl31.elf,cpu=0 \
	-device loader,file=DK/myImage,addr=0x00080000 \
	-device loader,file=DK/linux-hpsc.dtb,addr=0x04080000 \
	-device loader,file=DK/Single-Ref/linux-boot.elf \
	-hw-dtb DK/hpsc-multi.dtb \
	-pflash DK/Single-Ref/nand0.qcow2 \
	-serial mon:stdio -serial /dev/null -display none \
	-machine-path /tmp/qemu \
	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1,hostfwd=tcp:127.0.0.1:10022-10.0.2.15:22 \
	-D ./hpsc-multi-apu.log -d in_asm,exec,fdt,pm,in_asm,int
#	-D ./apu-test.log -d guest_errors

