usb='sdb'
usbname='WINDOWS'

echo "\n\n### PREPARING ###\n\n"
sudo killall gparted 2> /dev/null
for p in `sudo ls /dev/${usb}?`; do sudo umount $p 2> /dev/null; done
for p in `sudo ls /dev/sd?`; do sudo umount $p 2> /dev/null; done

echo "\n\n### FILESYSTEMS ###\n\n"
sudo /usr/sbin/sfdisk --delete /dev/${usb}
sudo /sbin/parted /dev/${usb} mklabel msdos --script

echo "\n\n### PARTITIONS ###\n\n"
sudo /sbin/parted /dev/${usb} mkpart primary fat32 0% 100%
sudo mkfs.fat -F32 -v -I -n ${usbname} /dev/${usb}1

echo "\n\n### GRUB INSTALLATION ###\n\n"
#sudo rm -rf /media/*
sudo rm -rf /media/${usbname} 
sudo mkdir /media/${usbname}
sudo mount /dev/${usb}1 /media/${usbname}/
sudo grub-install --target=i386-pc --recheck --boot-directory=/media/${usbname} /dev/${usb}
sleep 1
mkdir /media/${usbname}
cd /media/${usbname}
mkdir grub
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

