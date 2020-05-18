# Make a usb Windows installer from Linux

Automatic create bootable usb with grub, then copy and paste files from Windows iso to usb, tested with Windows 7, 8 and 10.

### General information

Tested only on Debian Buster.

## Before starting to consider a couple of things

### Problems with CD/DVD drivers on installation

In some cases Windows 7, 8 or 10 does not detect cd or dvd drivers, this means:

- Windows claims that the installation is done from a CD/DVD, therefore the problem is with the USB stick or PC USB port.

To solve this you must:

- Use a usb 2.0 flash drive for the installation
- Put the flash drive in a usb 2.0 port of PC or laptop everything for make a usb installer

### Grub does not start in UEFI mode

To solve this you must:

- Select a UEFI file as trusted for executing
- Create a profile for boot with this path to file as trusted on UEFI settings: /USB0/BOOT/grubx64.efi
- Boot from the UEFI profile

## Preparing everything for make a usb installer

Packages required:

```
grub-pc-bin, grub-efi-ia32-bin, grub-efi-amd64-bin, parted
```

Can install the packages with this command:

```
sudo apt install grub-pc-bin grub-efi-ia32-bin grub-efi-amd64-bin parted
```

Change mode to 'x' to the files, example:

```
chmod +x legacy_installer.sh
```

First steps you need to know the name of device, in my case, since the name of my usb is WINDOWS I can know that the name of the device is 'sdb', for know that you can use this command: 

```
sudo lsblk | grep -v sda
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop3    7:3    0     2G  1 loop /media/jonathan/Win10
sdb      8:16   1  15,1G  0 disk 
└─sdb1   8:17   1  15,1G  0 part /media/jonathan/WINDOWS
sr0     11:0    1  1024M  0 rom

```

Now that we have everything ready we must modify the script (are only the first 2 lines of the script), first put the name of the device (assuming it is 'sdc') and then the name that we will give to the pendrive (example 'pendrive'), it must be simple, with capital letters and without numbers:

```
usb='sdc'
usb_name='PENDRIVE'
```

## How to use Legacy installer script

Now that we have everything we must execute the script, for this just drag and drop it to the console or terminal app, interpose 'sudo sh ' and press enter:

```
sudo sh '/your/usb/path/legacy_installer.sh'
```

If all goes well you should be able to see the folder called 'grub' on your pendrive, (at this point your flash drive is bootable), to finish with the pendrive just disconnect your flash drive and reconnect it, then copy all the files from your Windows iso into the root of the pendrive (not inside the 'grub' folder), to understand it better, the iso files should be copied next to the 'grub' folder (not real tree, is only a example).

```
tree -d '/media/jonathan/WINDOWS1/'
/media/jonathan/WINDOWS1/
├── boot
│   ├── es-mx
│   ├── fonts
│   └── resources
├── efi
│   ├── boot
│   └── microsoft
│       └── boot
│           ├── fonts
│           └── resources
├── grub
│   ├── fonts
│   ├── i386-pc
│   └── locale
└── sources
```

## How to use Legacy installer script

- Pending: UEFI installation works only to the grub.

## Built With

* GNU bash, versión 5.0.3(1)-release (x86_64-pc-linux-gnu)

## Authors

* **Jonathan Burgos Saldivia** - *on Github* - [jonathanburgossaldivia](https://github.com/jonathanburgossaldivia)

## License

This project is licensed under the Eclipse Public License 2.0 - see the [LICENSE.md](LICENSE.md) file for details
