## sudo apt install grub-efi-amd64-bin grub-efi-ia32-bin

usb='sdb'
usbname='WINDOWS'

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

sleep 5 #debe estar si o si

sudo mkfs.fat -F32 -I -n EFII /dev/${usb}1
sudo mkfs.ntfs --quick -F -L ${usbname} /dev/${usb}2

echo "\n\n### GRUB INSTALLATION ###\n\n"

sudo rm -rf /media/EFII
sudo mkdir /media/EFII

sudo mount /dev/${usb}1 /media/EFII/

sudo grub-install --removable --boot-directory=/media/EFII --efi-directory=/media/EFII --target=x86_64-efi /dev/${usb}
sudo mkdir -p /media/EFII/grub

sudo bash -c "cat << EOF > /media/EFII/grub/grub.cfg
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
sudo cp /media/EFII/grub/grub.cfg /media/EFII/EFI/BOOT/grub.cfg
