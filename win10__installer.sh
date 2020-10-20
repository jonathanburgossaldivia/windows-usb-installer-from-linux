usb='sdg'
usbname='WINDOWS'
mount_point='dvd_win'
win_iso="/home/$LOGNAME/Descargas/Win10_2004_Spanish_x64.iso"

echo "### PREPARING ###"
sudo killall gparted 2> /dev/null
for p in `sudo ls /dev/${usb}?`; do sudo umount $p 2> /dev/null; done
for p in `sudo ls /dev/sd?`; do sudo umount $p 2> /dev/null; done

echo "### FILESYSTEMS ###"
sudo /usr/sbin/sfdisk --delete /dev/${usb}
sudo /sbin/parted /dev/${usb} mklabel msdos --script

echo "### PARTITIONS ###"
sudo /sbin/parted /dev/${usb} mkpart primary fat32 0% 100%
sudo mkfs.fat -F32 -v -I -n ${usbname} /dev/${usb}1

echo "### MOUNT PARTITION ###"
sudo rm -rf /media/${usbname} 2> /dev/null
sudo mkdir /media/${usbname} 2> /dev/null
sudo mount -t vfat /dev/${usb}1 /media/${usbname}/
echo "### GRUB INSTALLATION ###"
sudo grub-install --target=i386-pc --recheck --boot-directory=/media/${usbname} /dev/${usb}
echo "### MOUNT WIN DVD ###"

sudo mkdir /media/$mount_point 2> /dev/null
sudo mount -t udf "$win_iso" /media/$mount_point

echo "### WRITING TEMP FILES###"
sudo cp -p /media/$mount_point/sources/install.wim /tmp/install.wim
sudo wimlib-imagex split /tmp/install.wim /tmp/install.swm 2000

echo "### COPYING FILES TO USB ###"
sudo rsync --perms -q --recursive -P --exclude="install.wim" /media/$mount_point/* /media/${usbname}/
sudo cp -p /tmp/install.swm /media/$usbname/sources/
sudo cp -p /tmp/install2.swm /media/$usbname/sources/
sudo cp -p /tmp/install3.swm /media/$usb_name/sources

echo "### CHANGING PERMISSIONS ###"
sudo chmod 555 /media/${usbname}/sources/install*
sudo chown nobody:nogroup /media/${usbname}/*
echo "### DELETING TEMP FILES###"
sudo rm -rf /tmp/install*.swm /tmp/install.wim 
echo "### CREATING FRUB.CFG FILE ###"
cd /media/${usbname} 2> /dev/null
mkdir grub 2> /dev/null
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
echo "### FINISH TASK ###"

