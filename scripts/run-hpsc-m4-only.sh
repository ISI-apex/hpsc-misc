#sudo gdb --args /home/dkang/git-Xilinx/qemu-build/aarch64-softmmu/qemu-system-microblazeel \
#	-M microblaze-fdt -display none \
#	-hw-dtb DK/hpsc-m4-single.dtb \
#	-kernel tmp/deploy/images/zcu102-zynqmp/pmu-rom.elf \
#	-device loader,file=tmp/deploy/images/zcu102-zynqmp/pmu-zcu102-zynqmp.elf \
#	-device loader,addr=0xfd1a0074,data=0x1011003,data-len=4 \
#	-device loader,addr=0xfd1a007C,data=0x1010f03,data-len=4 \
#	-machine-path /tmp/qemu -D pmu-ref.log -d int,guest_errors

sudo gdb --args /home/dkang/WORK/qemu-build-multi/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
	-device loader,addr=0xfd1a0074,data=0x1011003,data-len=4 \
	-device loader,addr=0xfd1a007C,data=0x1010f03,data-len=4 \
        -hw-dtb DK/hpsc-m4.dtb \
        -serial mon:stdio -serial /dev/null -display none \
        -D ./m4-test.log -d in_asm,exec,fdt,pm,in_asm,int,cpu_reset \
	-device loader,file=DK/mynotmain.bin 	# works fine
#	-device loader,addr=0xffd00000,file=DK/notmain.bin 	# it still starts from address 0x0, so "Undefine Instruction" error happens
#	-device loader,file=DK/hello_m.elf \
#        -gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1,hostfwd=tcp:127.0.0.1:10022-10.0.2.15:22 
#       -D ./apu-test.log -d in_asm,exec,fdt,pm,in_asm,int
#       -D ./apu-test.log -d guest_errors
