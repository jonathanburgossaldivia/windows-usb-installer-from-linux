usb='sdb'
usbname='WINDOWS'

echo '### PREPARING ###'
sudo killall gparted
for p in `sudo ls /dev/${usb}?`; do sudo umount $p; done
for p in `sudo ls /dev/sd?`; do sudo umount $p; done

echo '### FILESYSTEMS ###'
sudo /usr/sbin/sfdisk --delete /dev/${usb}
sudo /sbin/parted /dev/${usb} mklabel msdos --script
sudo /sbin/parted /dev/${usb} mkpart primary fat32 0% 100%

echo '### PARTITIONS ###'
sudo mkfs.fat -F32 -v -I -n ${usbname} /dev/${usb}1

echo '### GRUB INSTALLATION ###'
#sudo rm -rf /media/*
sudo rm -rf /media/${usbname} 
sudo mkdir /media/${usbname}
sudo mount /dev/${usb}1 /media/${usbname}/
sudo grub-install --target=i386-pc --recheck --boot-directory=/media/${usbname} /dev/${usb}
mkdir -p /media/${usbname}/grub
sudo bash -c "cat << EOF > /media/${usbname}/grub/grub.cfg
default=1  
timeout=15
set menu_color_highlight=yellow/dark-gray
set menu_color_normal=black/light-gray
set color_normal=yellow/black
 
menuentry 'USB Installation for Microsoft Windows 7/8/8.1/10 MBR/MSDOS' {
    insmod ntfs
    insmod search_label
    search --no-floppy --set=root --label ${usbname} --hint hd0,msdos1
    ntldr /bootmgr
    boot
}
EOF"

