usb='sdb'
usb_name='WINDOWS'

#sudo apt install grub-pc-bin grub-efi-ia32-bin grub-efi-amd64-bin parted

sudo killall gparted

for p in `sudo ls /dev/${usb}?`; do sudo umount $p; done
for p in `sudo ls /dev/sd?`; do sudo umount $p; done

sudo /usr/sbin/sfdisk --delete /dev/${usb}
sudo /sbin/parted /dev/${usb} mklabel msdos --script
sudo /sbin/parted /dev/${usb} mkpart primary fat32 0% 100%

sudo mkfs.fat -F32 -v -I -n ${usb_name} /dev/${usb}1

#sudo rm -rf /media/*

sudo rm -rf /media/${usb_name} 
sudo mkdir /media/${usb_name}

sudo mount /dev/${usb}1 /media/${usb_name}/
sudo grub-install --removable --boot-directory=/media/${usb_name} --efi-directory=/media/${usb_name} --target=x86_64-efi /dev/${usb}

sudo mkdir -p /media/${usb_name}/grub
cat << EOF > /media/${usb_name}/grub/grub.cfg

default=1  
timeout=15
set menu_color_highlight=yellow/dark-gray
set menu_color_normal=black/light-gray
set color_normal=yellow/black
 
menuentry "Start Windows Installation" {
    insmod ntfs
    insmod search_label
    search --no-floppy --set=root --label ${usb_name} --hint hd0,msdos1
    ntldr /bootmgr
    boot
}
EOF

sudo cp /media/${usb_name}/grub/grub.cfg /media/${usb_name}/EFI/BOOT/grub.cfg
