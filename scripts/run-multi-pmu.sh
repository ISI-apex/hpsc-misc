sudo gdb --args /home/dkang/git-Xilinx/qemu-build/aarch64-softmmu/qemu-system-microblazeel -M microblaze-fdt -display none -hw-dtb tmp/deploy/images/zcu102-zynqmp/qemu-hw-devicetrees/multiarch/zynqmp-pmu.dtb -kernel tmp/deploy/images/zcu102-zynqmp/pmu-rom.elf -device loader,file=tmp/deploy/images/zcu102-zynqmp/pmu-zcu102-zynqmp.elf -device loader,addr=0xfd1a0074,data=0x1011003,data-len=4 -device loader,addr=0xfd1a007C,data=0x1010f03,data-len=4 -machine-path /tmp/qemu -D pmu-ref.log -d int,guest_errors