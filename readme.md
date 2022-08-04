# Preface

Linux commands are usually case sensitive, so make sure that you copy the commands **exactly** as they are written in the guide


# Steps

1. Boot
    - Boot into the ISO and quickly press F1
    - Enter `gentoo`
    - Quickly enter `uk`
2. Confirm internet connection:
    - Run `ping 1.1.1.1` and stop with `Ctrl + C`.
3. Check if your system is using EFI:
    - Run `ls /sys/firmware/` if a folder called `efi` is listed then use `gpt` when partitioning your disk, if not then use `dos`.
4. Partition your disk:
    - If you have either a NVMe or eMMC drive, note that whilst partitioning your drives you will have to replace `sda` with `nvme0n1`, or `mmcblk0` respectively. If you see `sda1` or `sda2` etc, you will have to append `p1` or `p2` to the drive.
    - Run `cfdisk /dev/sda`.
    - Select the label based on the result of step 3.
    - If you selected `dos`, press `Enter` to create a partition and give it `128M`, then press `B` to make it the boot partition. If you selected `gpt`, select `type` and select `EFI system`
    - Create a partition twice the size of your RAM, more if you have very limited memory and less if you have lots. Select `type` and `Linux swap` to create a swap partition.
    - Create a `Linux root` partition with your remaining space (ensure you select the type corresponding with your CPU archatecture, most likely `ARM-64`) and select `Write` to save the changes and then `Quit`.
    - Ensure that you complete the steps in order so that the rest of the guide is accurate, as it relies on sda1 being a boot partition, sda2 being swap, and sda3 being root.
5. Creating file systems:
    - If you are on an EFI system, run `mkfs.vfat -F 32 /dev/sda1`, if not then run `mkfs.ext4 -T small /dev/sda1`.
    - Run `mkswap /dev/sda2` then `swapon /dev/sda2` to  activate the swap partition.
    - Run `mkfs.ext4 /dev/sda3`. If this root partition is less than 8GB then run `mkfs.ext4 -T small /dev/sda3` instead.
    - Finally run `mount /dev/sda3 /mnt/gentoo` to mount the root partition 