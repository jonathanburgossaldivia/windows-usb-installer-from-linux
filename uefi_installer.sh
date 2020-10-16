## Required packages: grub-efi-amd64-bin grub-efi-ia32-bin

usb='sdb' #change sdb for your device name (entire disk or pendrive), list your devices with 'fdisk -l' command
boot_partition='EFI'
os_partition='WINDOWS'


echo "\n\n### PREPARING ###\n\n"
sudo killall gparted 2> /dev/null
for p in `sudo ls /dev/${usb}?`; do sudo umount $p 2> /dev/null; done
for p in `sudo ls /dev/sd?`; do sudo umount $p 2> /dev/null; done

echo "\n\n### FILESYSTEMS ###\n\n"
sudo /usr/sbin/sfdisk --delete /dev/${usb}
sudo /sbin/parted -s /dev/${usb} mklabel gpt

echo "\n\n### PARTITIONS ###\n\n"
sudo /sbin/parted /dev/${usb} mkpart primary fat32 0% 10%
sudo /sbin/parted /dev/${usb} mkpart primary ntfs 10% 100%

sleep 5 #waith for finish previous tasks

sudo mkfs.fat -F32 -I -n ${boot_partition} /dev/${usb}1
sudo mkfs.ntfs --quick -F -L ${os_partition} /dev/${usb}2

echo "\n\n### GRUB INSTALLATION ###\n\n"

sudo rm -rf /media/${boot_partition}
sudo mkdir /media/${boot_partition}

sudo mount /dev/${usb}1 /media/${boot_partition}/

sudo grub-install --removable --boot-directory=/media/${boot_partition} --efi-directory=/media/${boot_partition} --target=x86_64-efi /dev/${usb}

sleep 1
mkdir /media/${boot_partition}
cd /media/${boot_partition}
mkdir grub

sudo bash -c "cat << EOF > /media/${boot_partition}/grub/grub.cfg
default=1  
timeout=15
set menu_color_highlight=yellow/dark-gray
set menu_color_normal=black/light-gray
set color_normal=yellow/black
 
menuentry 'USB Installation for Microsoft Windows 7/8/8.1/10 UEFI/GPT' {
    insmod ntfs
    set root='hd0,gpt2'
    chainloader /efi/boot/bootx64.efi
    boot
}
EOF"
sudo cp /media/${boot_partition}/grub/grub.cfg /media/${boot_partition}/EFI/BOOT/grub.cfg
