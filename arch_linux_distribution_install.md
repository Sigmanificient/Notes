# Arch Linux Installation

## Optional Setup

> Set `azerty` keyboard layout
```sh
localectl set-keymap fr
```

> install fish for better autocompletions
```sh
pacman -Sy fish && fish
```

> Using a wifi network
```sh
iwctl
station wlan0 connect [wifi]
```

## Partition table

Use `fdisk -l` to get a list of all the drives in your computer.
> You are mike likely to install your system within `/dev/nvmeXnY` or `/dev/sdX`
```sh
fdisk /dev/[your_drive]
```

For a uefi system the following should be done:
> `/` stand for default value


| Command | Explaination |
| --- | --- |
| g | Creating a new GTP disklabel |
| n - `1` - `/` - `+500M` | Creating a 1st parition with a size of 500Mb |
| t - `1` | Changing the partition type to EFI system |
| n - `/` - `/` - `/` | Creating a 2nd with the remaining space |
| t - `/` - `30`| Chaning the partition type LVM to add a virtual partioning layer |
| w | Writing the change to the disk |


## Lvm configuration

The minimal recommanded lvm setup, note that it can be customized as you want.

> Formatting the lvm partition, this should take a few seconds
```sh
mkfs.ext4 /dev/[your_disk][partition2]
```

> Creating a logical volume
```sh
pvcreate --dataalignment 1m /dev/[your_disk][partition2]
```

> Adding a volume group
```sh
vgcreate [volgroup_name] /dev/[your_disk][partition2]
```

> Setting up the partition, separating `/root` & `/home` is reccomended
```sh
lvcreate -L 50GB [volgroup_name] -n lv_root
lvcreate -l 100%FREE [volgroup_name] -n lv_home
```

> Apply the change on lvm and set the disk to use
```sh
modprobe dm_mod
vgscan
vgchange -ay
```

# System base

> Format the lvm partitions
```sh
mkfs.ext4 /dev/[volgroup_name]/lv_root
mkfs.ext4 /dev/[volgroup_name]/lv_home
```

> mount the partitions to assemble the disk structure, `mnt` correspont to the future `/`
```sh
mount /dev/[volgroup_name]/lv_root /mnt
mkdir /mnt/home
mount /dev/[volgroup_name]/lv_home /mnt/home
```

> Install the arch base
```sh
pacstrap -i /mnt base
```

> Etablish the mount configuration
```sh
genfstab -U -p /mnt >> /mnt/etc/fstab
```

> Chroot in the newly created system
```sh
arch-chroot /mnt
```

## Packages installation

> Install linux & linux headers
```sh
pacman -S linux linux-headers (linux-lts linux-lts-headers)
```

> Install the devel utils
```sh
pacman -S base-devel
```

> Install a text Editor
```sh
pacman -S nano
```

## Networking

> Install network related packages
```sh
pacman -S networkmanager wpa_supplicant wireless_tools netctl dialog
```

> Activate the networking at boot time
```sh
systemctl enable NetworkManager
```

## Ramdisk Environemnt

> Install the lvm2 package
```sh
pacman -S lvm2
```

> Edit the hooks to add `lvm`
```sh
nano /etc/mkinitcpio.conf
```

```diff
- HOOKS=(... block ...)
+ HOOKS=(... block lvm2 ...)
```

> build the ramdisk
```sh
mkinitcpio -p linux
(mkinitcpio -p linux-lts)
```

## Language

> Edit the locale genearation config, uncomment your language (utf-8)
```sh
nano /etc/locale.gen
```

```diff
- # en_US.UTF-8 UTF-8
+ en_US.UTF-8 UTF-8
```

> Build the language
```sh
locale-gen
```

## Account configuration

> Create a passwd for the root user
```sh
passwd
```

> Add your local user and set your password
```sh
useradd -m -g users -G wheel [username]
passwd [username]
```

> Enable sudo command via wheel group user
```sh
EDITOR=nano visudo
```

> Allow wheel group to execute sudo commands with password
```diff
- # %wheel ALL=(ALL:ALL) ALL
+ %wheel ALL=(ALL:ALL) ALL
```

## Grub installation

> Install the grub build packages
```sh
pacman -S grub dosfstools efibootmgr os-prober mtools
```

> Add the EFI partition
```sh
mkdir /boot/EFI
mount /dev/[your_disk][partition1] /boot/EFI
```

> Power grub installation
```sh
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
```

> Build grub config
```sh
grub-mkconfig -o /boot/grub/grub.cfg
```

> Copy the grub message translating
```sh
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
```

## Swapfile

> Create an empty fixed size file
```sh
dd if=/dev/zero of=/swapfile bs=1M count=4096 status=progress
chmod 600 /swapfile
```

> Configure the swap
```sh
mkswap /swapfile
echo '/swapfile none swap 0 0' | tee -a /etc/fstab
```

> Activate the swap
```sh
mount -a
swapon -a
```

## Time sync

> set the timezone
```sh
timedatectl set-timezone Europe/Paris
```

> enable time sync at boot
```sh
systemctl enable systemd-timesyncd
```

## Final Tweaks

> Edit hosts to add localhost
```sh
nano /etc/hosts
```

```diff
+ 127.0.0.1 localhost
```

> Install micro code & firmware (choose for the currect cpu)
```sh
pacman -S linux-firmware intel-ucode
pacman -S linux-firmware amd-ucode
```

> Install video driver (choose again)
```sh
pacman -S nvidia (nvidia-lts)
pacman -S mesa
```

> Prepare xorg display server
```sh
pacman -S xorg-server
```

## KDE Plasma

> Install the desktop environment
```sh
pacman -S plasma-meta
```
**dont install kde-applications**

> Add dolphin and ark
```sh
pacman -S dolphin ark
```

> Activate the sddm
```sh
systemctl enable sddm
```

### Reboot

> exit chroot environment
```sh
exit
```

> unmount the system
```sh
umount -a
```

> enjoy :)
```sh
reboot
```