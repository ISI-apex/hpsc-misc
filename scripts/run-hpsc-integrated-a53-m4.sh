# 1. ends up Linux overwrites the address 0x000 where M4's vector table and code exist
#    When all cores of SMP Linux is enabled, M4's Qemu reads Undefined instructions
#sudo gdb --args /home/dkang/WORK/qemu-build-multi/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
#	-device loader,file=DK/myfsb.bin,addr=0xffff0000,cpu=0 \
#	-device loader,file=DK/bl31.elf \
#	-device loader,file=DK/myImage,addr=0x00080000 \
#	-device loader,file=DK/linux-hpsc.dtb,addr=0x04080000 \
#	-device loader,file=DK/Single-Ref/linux-boot.elf \
#	-device loader,file=DK/m4resetA53.bin,cpu=10 \
#	-hw-dtb DK/hpsc-integrated.dtb \
#	-pflash DK/Single-Ref/nand0.qcow2 \
#	-serial mon:stdio -serial /dev/null -display none \
#	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1,hostfwd=tcp:127.0.0.1:10022-10.0.2.15:22 \
#	-D ./hpsc-integrated.log -d in_asm,exec,fdt,pm,in_asm,int
##	-device loader,addr=0xfd1a0104,data=0x800000fe,data-len=4 \	# this is for resetting A53 CPU0.
##	-D ./apu-test.log -d guest_errors

# 2.  Moved the code of M4 to 0xfffdc000 which is the memory of Xilinx PMU
#     Working version: m4fsb.bin has vector table and jump instruction to 0xfffdc000
#     		       m4resetA53.bin has the code for infinite loop with sleep. 
#		       M4 gots interrupt periodically (which I'm not sure if it is from device or just Qemu internal).
#		       So, I had to put the sleep instruction inside of infinite loop.
#     We should specifyu "cpu=10" for both m4fsb.bin and m4resetA53.bin.
#     If unspecified, the code seems to be run on CPU0.
sudo gdb --args /home/dkang/WORK/qemu-build-multi/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
	-device loader,file=DK/myfsb.bin,addr=0xffff0000,cpu=0 \
	-device loader,file=DK/bl31.elf \
	-device loader,file=DK/myImage,addr=0x00080000 \
	-device loader,file=DK/linux-hpsc.dtb,addr=0x04080000 \
	-device loader,file=DK/Single-Ref/linux-boot.elf \
	-device loader,file=DK/m4fsb.bin,cpu=10 \
	-device loader,file=DK/m4resetA53.bin,addr=0xfffdc000,cpu=10 \
	-hw-dtb DK/hpsc-integrated.dtb \
	-pflash DK/Single-Ref/nand0.qcow2 \
	-serial mon:stdio -serial /dev/null -display none \
	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1,hostfwd=tcp:127.0.0.1:10022-10.0.2.15:22 \
	-D ./hpsc-integrated.log -d in_asm,exec,fdt,pm,in_asm,int
#	-device loader,file=DK/m4fsb.bin,cpu=10 \
#	-device loader,addr=0xfd1a0104,data=0x800000fe,data-len=4 \	# this is for resetting A53 CPU0.
#	-D ./apu-test.log -d guest_errors
