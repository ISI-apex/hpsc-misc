#sudo gdb --args /home/dkang/WORK/qemu-build/aarch64-softmmu/qemu-system-aarch64 -net nic -net nic -net nic -net nic,netdev=net0,macaddr=52:54:00:12:34:02 -netdev tap,id=net0,ifname=tap0,script=no,downscript=no -device loader,addr=0x6000000,file=tmp/deploy/images/zcu102-zynqmp/core-image-minimal-zcu102-zynqmp-20170714142939.rootfs.cpio.gz.u-boot,force-raw=true -nographic -serial mon:stdio -serial null -hw-dtb DK/hw-single.dtb -global xlnx,zynqmp-boot.cpu-num=0 -device loader,file=DK/bl31.elf,cpu-num=0 -device loader,file=tmp/deploy/images/zcu102-zynqmp/u-boot.elf  -device loader,addr=0x4000000,file=DK/linux-single.dtb -device loader,addr=0x80000,file=DK/Image-test -machine arm-generic-fdt,accel=tcg -m 4096 -machine-path /tmp/qemu -D ./apu-test.log -d int,guest_errors,in_asm,fdt
#sudo gdb --args /home/dkang/git-Xilinx/qemu-build/aarch64-softmmu/qemu-system-aarch64 -net nic -net nic -net nic -net nic,netdev=net0,macaddr=52:54:00:12:34:02 -netdev tap,id=net0,ifname=tap0,script=no,downscript=no -device loader,addr=0x6000000,file=tmp/deploy/images/zcu102-zynqmp/core-image-minimal-zcu102-zynqmp-20170714142939.rootfs.cpio.gz.u-boot,force-raw=true -nographic -serial mon:stdio -serial null -hw-dtb DK/hw.dtb -global xlnx,zynqmp-boot.cpu-num=0 -global xlnx,zynqmp-boot.use-pmufw=true -device loader,file=DK/bl31.elf,cpu-num=0 -device loader,file=tmp/deploy/images/zcu102-zynqmp/u-boot.elf  -device loader,addr=0x4000000,file=tmp/deploy/images/zcu102-zynqmp/Image-zynqmp-zcu102-revB.dtb -device loader,addr=0x80000,file=tmp/deploy/images/zcu102-zynqmp/Image -machine arm-generic-fdt  -m 4096 -machine-path /tmp/qemu -D ./apu-test.log -d int,guest_errors,in_asm,fdt

# 1. Works fine (qemu is OK, modified ATF, reference Linux image, reference linux device tree, reference linux-boot loader, reference hw device tree, reference rfs
#    my qemu (xilinx-v2016.4), my ATF
# it wait a little after first cpu0 boot. But eventually shows the login prompt.
#    Linux: Linux version 4.6.0-xilinx (xbrbbot@xcosswbld01) 
#    kernel parameter: earlycon=cdns,mmio,0xFF000000,115200n8
#sudo gdb --args /home/dkang/WORK/qemu-build-single/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
#	-device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4 \
#	-device loader,file=DK/bl31.elf,cpu=0 \
#	-device loader,file=DK/Single-Ref/Image,addr=0x00080000 \
#	-device loader,file=DK/Single-Ref/system.dtb,addr=0x04080000 \
#	-device loader,file=DK/Single-Ref/linux-boot.elf \
#	-hw-dtb DK/Single-Ref/zynqmp-qemu-arm.dtb \
#	-pflash DK/Single-Ref/nand0.qcow2 \
#	-serial mon:stdio -serial /dev/null -display none \
#	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1 \
#	-D ./apu-test.log

# 2. Working (qemu is OK, modified ATF, reference Linux image, reference linux device tree, reference linux-boot loader, reference hw device tree, reference rfs
#    Qemu: my qemu built from source (xilinx-v2016.4),  - no 2nd cluster of A53
#    ATF: my ATF
#    Qemu FDT:	(xilinx-v2016.4)  - no 2nd cluster of A53
#    Initially Linux kernel panic
#    Fixed by editing zynqmp-arm.dtsi (edited ddr_bank3 register)
#    Linux: Linux version 4.6.0-xilinx (xbrbbot@xcosswbld01) 
#sudo gdb --args /home/dkang/WORK/qemu-build-single/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
#	-device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4 \
#	-device loader,file=DK/bl31.elf,cpu=0 \
#	-device loader,file=DK/Single-Ref/Image,addr=0x00080000 \
#	-device loader,file=DK/Single-Ref/system.dtb,addr=0x04080000 \
#	-device loader,file=DK/Single-Ref/linux-boot.elf \
#	-hw-dtb DK/hw-single.dtb \
#	-pflash DK/Single-Ref/nand0.qcow2 \
#	-serial mon:stdio -serial /dev/null -display none \
#	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1 \
#	-D ./apu-test.log

# 2.1.  1 + Linux image from source code
#    Qemu: my qemu built from source (xilinx-v2016.4),  - no 2nd cluster of A53
#    ATF: my ATF
#    Qemu FDT:	Reference
#    Linux: from source code (git commit 061577cf00d48e8d7e5501cb3bae88ee82ce8eb9)
#    a. Linux from source code (myImage) Linux version 4.9.0-00442-gca1d7a1 (dkang@Yocto)
#       2nd boot doesn't start (So, Linux is problem)
#    b. Linux from source code (myImage) from git commit 7eecb2b947b11e20f5296cdc7ba560fa4439ca90 (Nov 21 2016)  Linux version 4.6.0-00001-g7eecb2b
#       2nd boot starts, but kernel panic
#    c. Linux from source code (myImage) from git commit 2762bc9163bb8576f63ff82801a65576f59e1e57 (Nov 23 2016) 
#	[    7.469420] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
#    d. Linux from source code (myImage) from git commit 34421523b45c5e51e5594b532001d17502c33ded (Dec 19 2016) 
#	[    7.469420] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
#    e. Linux from source code (myImage) from git commit 34421523b45c5e51e5594b532001d17502c33ded (Dec 19 2016)  (PCI MSI is disabled)
#	[    7.469420] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
#    f. Linux from source code (myImage) from git commit 472236088ad190937efa1be2d96965f9bb7c9bcb (Mar 8 2016)  
#	[    7.469420] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
#    g. Linux from source code (myImage) from git commit ab597d35ef11d2a921e0ec507a9b7861bcb44cbd (Mar 6 2016)  
#	WARNING: DK4: power state = (0, 0, 0, 0, 1, 1, 1, 1)
# 	VERBOSE: psci_warmboot_entrypoint: after psci_set_pwr_domains_to_run
# 	[Thread 0x7ffff2ab4700 (LWP 42827) exited]  --> 2nd boot doesn't start
#    h. Linux from source code (myImage) from git commit 2762bc9163bb8576f63ff82801a65576f59e1e57 (Nov 23 2016)   --> Petalinux 2016.4 version
#	[    7.980185] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
#    i. Linux from source code (myImage) from git commit 78c22449f2d32aafd8804047f7e3bee4926b52eb (Oct 12 2016)   --> before Petalinux 2016.4 version
#	Failed to set up IOMMU for device ff0e0000.ethernet; retaining platform DMA ops
#	[    1.896789] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
#    j. Linux from source code (myImage) from git commit 061577cf00d48e8d7e5501cb3bae88ee82ce8eb9 (Dec 22 2016)   --> after Petalinux 2016.4 version
#	works after specifying root file system: CONFIG_INITRAMFS_SOURCE="./rootfs.cpio" in arch/arm64/configs/xilinx_zynqmp_defconfig
#	rootfs.cpio file is copied from PetaLinux v2016.4
#sudo gdb --args /home/dkang/WORK/qemu-build-single/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
#	-device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4 \
#	-device loader,file=DK/bl31.elf,cpu=0 \
#	-device loader,file=DK/myImage,addr=0x00080000 \
#	-device loader,file=DK/Single-Ref/system.dtb,addr=0x04080000 \
#	-device loader,file=DK/Single-Ref/linux-boot.elf \
#	-hw-dtb DK/Single-Ref/zynqmp-qemu-arm.dtb \
#	-pflash DK/Single-Ref/nand0.qcow2 \
#	-serial mon:stdio -serial /dev/null -display none \
#	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1 \
#	-D ./apu-test.log

# 2.1.1  2.1 + Qemu FDT (built)
#    Qemu: my qemu built from source (xilinx-v2016.4),  - no 2nd cluster of A53
#    ATF: my ATF
#    Qemu FDT:	(xilinx-v2016.4)  - no 2nd cluster of A53
#    Linux: from source code (git commit 061577cf00d48e8d7e5501cb3bae88ee82ce8eb9)
#    Works!
#sudo gdb --args /home/dkang/WORK/qemu-build-single/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
#	-device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4 \
#	-device loader,file=DK/bl31.elf,cpu=0 \
#	-device loader,file=DK/myImage,addr=0x00080000 \
#	-device loader,file=DK/Single-Ref/system.dtb,addr=0x04080000 \
#	-device loader,file=DK/Single-Ref/linux-boot.elf \
#	-hw-dtb DK/hw-single.dtb \
#	-pflash DK/Single-Ref/nand0.qcow2 \
#	-serial mon:stdio -serial /dev/null -display none \
#	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1 \
#	-D ./apu-test.log

# 2.1.2  2.1.1 + Linux FDT (built)
#    Qemu: my qemu built from source (xilinx-v2016.4),  - no 2nd cluster of A53
#    ATF: my ATF
#    Qemu FDT:	(xilinx-v2016.4)  - no 2nd cluster of A53
#    Linux: from source code (git commit 061577cf00d48e8d7e5501cb3bae88ee82ce8eb9)
#    Working!
#sudo gdb --args /home/dkang/WORK/qemu-build-single/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
#	-device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4 \
#	-device loader,file=DK/bl31.elf,cpu=0 \
#	-device loader,file=DK/myImage,addr=0x00080000 \
#	-device loader,file=DK/linux-zcu102.dtb,addr=0x04080000 \
#	-device loader,file=DK/Single-Ref/linux-boot.elf \
#	-hw-dtb DK/hw-single.dtb \
#	-pflash DK/Single-Ref/nand0.qcow2 \
#	-serial mon:stdio -serial /dev/null -display none \
#	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1 \
#	-D ./apu-test.log

# 2.1.3  2.1.2 + 8 core Qemu (hpsc)
#    Qemu: my qemu built from source (hpsc),  - With 2nd cluster of A53
#    ATF: my ATF
#    Qemu FDT:	(xilinx-v2016.4)  - no 2nd cluster of A53
#    Linux: from source code (git commit 061577cf00d48e8d7e5501cb3bae88ee82ce8eb9)
#    Working!
#sudo gdb --args /home/dkang/WORK/qemu-build-multi/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
#	-device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4 \
#	-device loader,file=DK/bl31.elf,cpu=0 \
#	-device loader,file=DK/myImage,addr=0x00080000 \
#	-device loader,file=DK/linux-zcu102.dtb,addr=0x04080000 \
#	-device loader,file=DK/Single-Ref/linux-boot.elf \
#	-hw-dtb DK/hw-single.dtb \
#	-pflash DK/Single-Ref/nand0.qcow2 \
#	-serial mon:stdio -serial /dev/null -display none \
#	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1 \
#	-D ./apu-test.log

# 2.1.4  2.1.2 + 8 core Qemu (hpsc) + 8 core Qemu FDT (hpsc)
#    Qemu: my qemu built from source (hpsc),  - With 2nd cluster of A53
#    ATF: my ATF
#    Linux: from source code (git commit 061577cf00d48e8d7e5501cb3bae88ee82ce8eb9)
#    a. Qemu FDT:	(git hpsc)  - 2nd cluster of A53
#       Kernel panic:
#    	[    0.000000] kernel BUG at arch/arm64/mm/mmu.c:205!
#    b. Qemu FDT:	(git xilinx-v2016.4)  - original form zynq (zcu102-arm.dtb)
#       Works well
#    3. Qemu FDT:	(git xilinx-v2016.4)  - adding 2nd cluster (hpsc-single.dtb)
#			linux-zcu102.dtb  - original 4 core linux fdt
#       boots with 4 CPUs. The other 4 CPUs are not recognized by Linux
#	1st boot on CPU#0 passes, but 2nd boot doesn't start (ATF messages are printed after the 1st boot)
#    3.1 Qemu FDT:	(git xilinx-v2016.4)  - adding 2nd cluster (hpsc-single.dtb)
#			linux-hpsc.dtb - new hpsc linux fdt with 8 cores
#	boots with 4 CPUs. Fails to wake up the new 4th cores (2nd boot doesn't start)
#    3.2. working but only 4 CPUs - login prompt is shown
#		my hw dtb: hpsc-single.dtb
#		boot arg: -device loader,addr=0xfd1a0104,data=0x800000fe,data-len=4 
#		linux fdt: original fdt: linux-zcu102.dtb
#WARNING: DK: zynqmp_nopmu_pwr_domain_on: read CRF_APB_RST_FPD_APU(800000f8)
#WARNING: DK: zynqmp_nopmu_pwr_domain_on: write CRF_APB_RST_FPD_APU(800000f0)
#WARNING: DK: psci_cpu_on_start: after pwr_domain_on, rc = 0
#WARNING: DK: power state = (0, 0, 0, 2, 1, 1, 1, 1)
#WARNING: DK: psci_cpu_on_start: return, rc = 0
#WARNING: DK: power state = (0, 0, 0, 2, 1, 1, 1, 1)
#WARNING: DK: psci_cpu_on_start: returns 0
#VERBOSE: psci_warmboot_entrypoint: start
#VERBOSE: psci_warmboot_entrypoint: after psci_get_target_local_pwr_states
#VERBOSE: psci_cpu_on_finish: starts
#VERBOSE: zynqmp_pwr_domain_on_finish: target_state->pwr_domain_state[0]=2
#VERBOSE: zynqmp_pwr_domain_on_finish: target_state->pwr_domain_state[1]=0
#VERBOSE: zynqmp_pwr_domain_on_finish: target_state->pwr_domain_state[2]=0
#VERBOSE: psci_warmboot_entrypoint: after psci_cpu_on_finish
#WARNING: DK: psci_set_pwr_domains_to_run : start, cpu_idx = 3)
#WARNING: DK1: power state = (0, 0, 0, 2, 1, 1, 1, 1)
#WARNING: DK2: power state = (0, 0, 0, 2, 1, 1, 1, 1)
#WARNING: DK3: power state = (0, 0, 0, 0, 1, 1, 1, 1)
#WARNING: DK4: power state = (0, 0, 0, 0, 1, 1, 1, 1)
#VERBOSE: psci_warmboot_entrypoint: after psci_set_pwr_domains_to_run
#[    0.000000] Booting Linux on physical CPU 0x0

#    3.3. 2nd boot doesn't start at all
#		my hw dtb: hpsc-single.dtb
#		boot arg: -device loader,addr=0xfd1a0104,data=0x800000fe,data-len=4 
#		linux fdt: my fdt: linux-hpsc.dtb
#		(hpsc-single.dtb: cpu register is either one word (0x0, .., 0x3, 0x100, .., 0x103) or two words (0x0 0x0, .., 0x0 0x3, 0x1 0x0, .., 0x1 0x3)
#		DK thinks one word is better
#WARNING: DK: zynqmp_nopmu_pwr_domain_on: read CRF_APB_RST_FPD_APU(80000080)
#WARNING: DK: zynqmp_nopmu_pwr_domain_on: write CRF_APB_RST_FPD_APU(80000000)
#WARNING: DK: psci_cpu_on_start: after pwr_domain_on, rc = 0
#WARNING: DK: power state = (0, 0, 0, 0, 0, 0, 0, 2)
#WARNING: DK: psci_cpu_on_start: return, rc = 0
#WARNING: DK: power state = (0, 0, 0, 0, 0, 0, 0, 2)
#WARNING: DK: psci_cpu_on_start: returns 0
#VERBOSE: psci_warmboot_entrypoint: start
#VERBOSE: psci_warmboot_entrypoint: after psci_get_target_local_pwr_states
#VERBOSE: psci_cpu_on_finish: starts
#VERBOSE: zynqmp_pwr_domain_on_finish: target_state->pwr_domain_state[0]=2
#VERBOSE: zynqmp_pwr_domain_on_finish: target_state->pwr_domain_state[1]=0
#VERBOSE: zynqmp_pwr_domain_on_finish: target_state->pwr_domain_state[2]=0
#VERBOSE: psci_warmboot_entrypoint: after psci_cpu_on_finish
#WARNING: DK: psci_set_pwr_domains_to_run : start, cpu_idx = 7)
#WARNING: DK1: power state = (0, 0, 0, 0, 0, 0, 0, 2)
#WARNING: DK2: power state = (0, 0, 0, 0, 0, 0, 0, 2)
#WARNING: DK3: power state = (0, 0, 0, 0, 0, 0, 0, 0)
#WARNING: DK4: power state = (0, 0, 0, 0, 0, 0, 0, 0)
#VERBOSE: psci_warmboot_entrypoint: after psci_set_pwr_domains_to_run
sudo gdb --args /home/dkang/WORK/qemu-build-multi/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
	-device loader,addr=0xfd1a0104,data=0x800000fe,data-len=4 \
	-device loader,file=DK/bl31.elf,cpu=0 \
	-device loader,file=DK/myImage,addr=0x00080000 \
	-device loader,file=DK/linux-hpsc.dtb,addr=0x04080000 \
	-device loader,file=DK/Single-Ref/linux-boot.elf \
	-hw-dtb DK/hpsc-single.dtb \
	-pflash DK/Single-Ref/nand0.qcow2 \
	-serial mon:stdio -serial /dev/null -display none \
	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1,hostfwd=tcp:127.0.0.1:10022-10.0.2.15:22 \
	-D ./hpsc-single.log -d in_asm,exec,fdt,pm,in_asm,int
#	-D ./apu-test.log -d guest_errors



#  Old trials - not well organized
#
# 2.1.2  2.1 + my zcu-102 single FDT
#    (qemu is OK, modified ATF, reference Linux image, reference linux-boot loader, reference rfs
#    my qemu (xilinx-v2016.4), my ATF
#    Linux image from source code
#    a. new: my Qemu single dtb (8core-single-qemu.dtb)  + original Linux FDT (Single-Ref/system.dtb)
#       kernel panic on the first stage boot: [    0.000000] Internal error: Oops - BUG: 0 [#1] SMP
#    b. new: my Qemu single dtb (8core-single-qemu.dtb)  + my Linux FDT (linux-new.dtb)
#	kernal panic on the first stage boot: [    0.000000] kernel BUG at arch/arm64/mm/mmu.c:205!
#sudo gdb --args /home/dkang/WORK/qemu-build-single/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
#	-device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4 \
#	-device loader,file=DK/bl31.elf,cpu=0 \
#	-device loader,file=DK/myImage,addr=0x00080000 \
#	-device loader,file=DK/linux-new.dtb,addr=0x04080000 \
#	-device loader,file=DK/Single-Ref/linux-boot.elf \
#	-hw-dtb DK/Single-Ref/zynqmp-qemu-arm.dtb \
#	-pflash DK/Single-Ref/nand0.qcow2 \
#	-serial mon:stdio -serial /dev/null -display none \
#	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1 \
#	-D ./apu-test.log

# 2.1.4  2.1 + my Qemu multi FDT
#    (qemu is OK, modified ATF, reference Linux image, reference linux device tree, reference linux-boot loader, reference hw device tree, reference rfs
#    my qemu (xilinx-v2016.4), my ATF
#    Linux image from source code
#    new: my Qemu multi dtb 
#    8core-multi-qemu.dtb: cannot start: qemu-system-aarch64: /pmu@0: Missing chardesc prop. Forgot -machine-path?
#sudo gdb --args /home/dkang/WORK/qemu-build-single/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
#	-device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4 \
#	-device loader,file=DK/bl31.elf,cpu=0 \
#	-device loader,file=DK/myImage,addr=0x00080000 \
#	-device loader,file=DK/Single-Ref/system.dtb,addr=0x04080000 \
#	-device loader,file=DK/Single-Ref/linux-boot.elf \
#	-hw-dtb DK/8core-multi-qemu.dtb \
#	-pflash DK/Single-Ref/nand0.qcow2 \
#	-serial mon:stdio -serial /dev/null -display none \
#	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1 \
#	-D ./apu-test.log

# 2.1.1.1  2.1.1 + modified Linux FDT
#    (qemu is OK, modified ATF, reference Linux image, reference linux device tree, reference linux-boot loader, reference hw device tree, reference rfs
#    my qemu (xilinx-v2016.4), my ATF
#    Linux image from source code
#    new: my Linux dtb
#    initially works with 4 CPUs.
#sudo gdb --args /home/dkang/WORK/qemu-build-single/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
#	-device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4 \
#	-device loader,file=DK/bl31.elf,cpu=0 \
#	-device loader,file=DK/myImage,addr=0x00080000 \
#	-device loader,file=DK/mylinux.dtb,addr=0x04080000 \
#	-device loader,file=DK/Single-Ref/linux-boot.elf \
#	-hw-dtb DK/hw-single.dtb \
#	-pflash DK/Single-Ref/nand0.qcow2 \
#	-serial mon:stdio -serial /dev/null -display none \
#	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1 \
#	-D ./apu-test.log

# 2.1.1.1.1  2.1.1.1 + qemu-multi
#    (qemu is OK, modified ATF, reference Linux image, reference linux device tree, reference linux-boot loader, reference hw device tree, reference rfs
#    my qemu (xilinx-v2016.4), my ATF
#    Linux image from source code
#    new: my Linux dtb
#    initially works with 4 CPUs.
#sudo gdb --args /home/dkang/WORK/qemu-build-multi/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
#	-device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4 \
#	-device loader,file=DK/bl31.elf,cpu=0 \
#	-device loader,file=DK/myImage,addr=0x00080000 \
#	-device loader,file=DK/mylinux.dtb,addr=0x04080000 \
#	-device loader,file=DK/Single-Ref/linux-boot.elf \
#	-hw-dtb DK/hw-single.dtb \
#	-pflash DK/Single-Ref/nand0.qcow2 \
#	-serial mon:stdio -serial /dev/null -display none \
#	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1 \
#	-D ./apu-test.log




# 3. Not Working (qemu is OK, modified ATF, reference Linux image, reference linux device tree, reference linux-boot loader, reference hw device tree, reference rfs
#    DK_2
#    my qemu (xilinx-v2016.4), my ATF
#    my qemu FDT
#    my linux image (myImage from xilinx-linux source code) with "Single-Ref/system.dtb" --> does not work. 2nd kernel boot doesn't start (thread exits)
#    my linux image (myImage from xilinx-linux source code) with "mylinux.dtb" --> does not work. 2nd kernel boot doesn't start (thread exits)
#sudo gdb --args /home/dkang/WORK/qemu-build-single/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
#	-device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4 \
#	-device loader,file=DK/bl31.elf,cpu=0 \
#	-device loader,file=DK/myImage,addr=0x00080000 \
#	-device loader,file=DK/mylinux.dtb,addr=0x04080000 \
#	-device loader,file=DK/Single-Ref/linux-boot.elf \
#	-hw-dtb DK/hw-single.dtb \
#	-pflash DK/Single-Ref/nand0.qcow2 \
#	-serial mon:stdio -serial /dev/null -display none \
#	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1 \
#	-D ./apu-test.log

# 4. test 
#    DK_2
#    my qemu (xilinx-v2016.4), my ATF
#    my qemu FDT
#    a. my yocto linux image  with "Single-Ref/system.dtb" with nand0.qcow2--> does not work. 2nd kernel boot doesn't start (no thread exits)
#    b. my yocto linux image with "Single-Ref/system.dtb" with nand0.qcow2--> does not work. 2nd kernel boot doesn't start (no thread exits)
#    my yocto linux image (myImage from xilinx-linux source code) with "Single-Ref/system.dtb" --> does not work. 2nd kernel boot doesn't start (no thread exits)
#sudo gdb --args /home/dkang/WORK/qemu-build-single/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
#	-device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4 \
#	-device loader,file=DK/bl31.elf,cpu=0 \
#	-device loader,file=DK/Image-test,addr=0x00080000 \
#	-device loader,file=DK/Single-Ref/system.dtb,addr=0x04080000 \
#	-device loader,file=DK/Single-Ref/linux-boot.elf \
#	-hw-dtb DK/hw-single.dtb \
#	-pflash DK/Single-Ref/nand0.qcow2 \
#	-serial mon:stdio -serial /dev/null -display none \
#	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1 \
#	-D ./apu-test.log 
#	-device loader,addr=0x6000000,file=tmp/deploy/images/zcu102-zynqmp/core-image-minimal-zcu102-zynqmp-20170714142939.rootfs.cpio,force-raw=true \

# 5. u-boot (not working)
# (qemu is OK, modified ATF, reference Linux image, reference linux device tree, reference linux-boot loader, reference hw device tree, reference rfs
#    No addtional modification
#    my qemu (xilinx-v2016.4), my ATF
#    my qemu FDT,
#   Tried:
#    my Linux image, linux boot, my Linux FDT --> 2nd boot does not start
#    my Linux image, linux boot, reference linux device tree  --> 2nd boot does not start
#    my Linux image, uboot, my linux FDT  --> fails with "PMUFW is not found - Please load it!" message. Looks like that u-boot loads PMUFW.
#    Linux (xilinx-v2016.4) image, Linux FDT (xilinx-v2016.4) --> I don't know how to make rootfs for vmlinux.
#    my Linux image with reference linux device tree, linux boot, reference linux device tree
#sudo gdb --args /home/dkang/WORK/qemu-build-single/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
#	-device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4 \
#	-device loader,file=DK/bl31.elf,cpu=0 \
#	-device loader,file=DK/Image-test,addr=0x00080000 \
#	-device loader,file=DK/Single-Ref/system.dtb,addr=0x04080000 \
#	-device loader,file=DK/u-boot.elf \
#	-hw-dtb DK/hw-single.dtb \
#	-pflash DK/Single-Ref/nand0.qcow2 \
#	-serial mon:stdio -serial /dev/null -display none \
#	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1 \
#	-D ./apu-test.log

#    my Linux image, linux boot, my Linux FDT, my rootfs, 
#sudo gdb --args /home/dkang/WORK/qemu-build-single/aarch64-softmmu/qemu-system-aarch64 -M arm-generic-fdt \
#	-device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4 \
#	-device loader,file=DK/bl31.elf,cpu=0 \
#	-device loader,file=DK/Image-test,addr=0x00080000 \
#	-device loader,file=DK/Single-Ref/system.dtb,addr=0x04080000 \
#	-device loader,file=DK/u-boot.elf \
#	-hw-dtb DK/hw-single.dtb \
#	-pflash DK/Single-Ref/nand0.qcow2 \
#	-serial mon:stdio -serial /dev/null -display none \
#	-gdb tcp::9000 -net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1 \
#	-D ./apu-test.log


#-pflash /home/data/opr-test/pkg/xilinx-zcu102-2016.4/images/linux/nand0.qcow2

#Image  linux-boot.elf  nand0.qcow2  system.dtb  zynqmp-qemu-arm.dtb
