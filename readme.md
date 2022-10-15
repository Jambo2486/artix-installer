# Preface

- Linux commands are usually case sensitive, so make sure that you copy the commands **exactly** as they are written in the guide.
- You can use `Tab` to auto complete many commands. If there are multiple possible commands, it will complete until the commands differ.


# Steps

1. Confirm internet connection:
    - Run `ping 1.1.1.1` to ensure you have an internet connection and stop with `Ctrl + C`.
2. Check if your system is using EFI:
    - Run `ls /sys/firmware/` if a folder called `efi` is listed then use `gpt` when partitioning your disk, if not then use `dos`.
3. Partition your disk:
    - If you have either a NVMe or eMMC drive, note that whilst partitioning your drives you will have to replace `sda` with `nvme0n1`, or `mmcblk0` respectively. If you see `sda1` or `sda2` etc, you will have to append `p1` or `p2` to the drive.
    - Run `cfdisk /dev/sda`.
    - Select the label based on the result of step 3.
    - If you selected `dos`, press `Enter` to create a partition and give it `128M`, then press `B` to make it the boot partition. If you selected `gpt`, select `type` and select `EFI system`
    - Create a partition twice the size of your RAM, more if you have very limited memory and less if you have lots. Select `type` and `Linux swap` to create a swap partition.
    - Create a `Linux root` partition with your remaining space (ensure you select the type corresponding with your CPU archatecture, most likely `x86-64`) and select `Write` to save the changes and then `Quit`.
    - Ensure that you complete the steps in order so that the rest of the guide is accurate, as it relies on sda1 being a boot partition, sda2 being swap, and sda3 being root.
4. Creating file systems:
    - If you are on an EFI system, run `mkfs.vfat -F 32 /dev/sda1` and `fatlabel /dev/dsa1 BOOT`, if not then run `mkfs.ext4 -L BOOT /dev/sda1`.
    - Run `mkswap -L SWAP /dev/sda2` then `swapon /dev/disk/by-label/SWAP` to  activate the swap partition.
    - Run `mkfs.ext4 -L ROOT /dev/sda3`. If this root partition is less than 8GB then run `mkfs.ext4 -T small -L ROOT /dev/sda3` instead.
    - Run `mount /dev/disk/by-label/ROOT /mnt` to mount the root partition.
    - Run `mkdir /mnt/boot` and `mount /dev/disk/by-label/BOOT /mnt/boot` to mount the boot partition.
4. Download the install script:
    - Run `curl github.com/Jambo2486/artix-installer/raw/main/install.sh > install.sh` to download the Artix install script
    - Run `install.sh` to run it.