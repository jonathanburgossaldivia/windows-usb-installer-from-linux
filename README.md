# windows-usb-installer-from-linux
Create a Windows usb installer from Linux
## General information

Tested only on Debian Buster.

### Prerequisites

Packages required:

```
grub-pc-bin, grub-efi-ia32-bin, grub-efi-amd64-bin, parted
```

Can install the packages with this command:

```
sudo apt install grub-pc-bin grub-efi-ia32-bin grub-efi-amd64-bin parted
```

### First steps

Change mode to 'x' to the 2 files, example:

```
chmod +x legacy_installer.sh
```
### How to use

First steps you need to know the name of device, in my case, since the name of my usb is WINDOWS I can know that the name of the device is sdb, for know that you can use this command: 

```
sudo lsblk | grep -v sda
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop3    7:3    0     2G  1 loop /media/jonathan/Win10
sdb      8:16   1  15,1G  0 disk 
└─sdb1   8:17   1  15,1G  0 part /media/jonathan/WINDOWS
sr0     11:0    1  1024M  0 rom

```

```
./legacy_installer.sh
```

## Built With

* GNU bash, versión 5.0.3(1)-release (x86_64-pc-linux-gnu)

## Authors

* **Jonathan Burgos Saldivia** - *on Github* - [jonathanburgossaldivia](https://github.com/jonathanburgossaldivia)

## License

This project is licensed under the Eclipse Public License 2.0 - see the [LICENSE.md](LICENSE.md) file for details
