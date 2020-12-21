# Make a Windows usb installer from Linux

Easy way to create bootable usb flash drive with grub as bootloader.

### General information

Tested only on Debian Buster and Kubuntu 20.

- I recommend using a usb 2.0 pendrive in a pc usb 2.0 port (when installing from usb 3.0 it shows an error about the install.swm file).

### Start installer in UEFI mode

- Select a UEFI file as trusted for executing from your Bios
- Create a profile for boot with this path to file as trusted on UEFI settings: /USB0/BOOT/grubx64.efi
- Boot from the UEFI profile

## Preparing everything for make a usb installer

Packages required:

```
grub-pc-bin grub-efi-ia32-bin grub-efi-amd64-bin parted wimtools
```

Change mode to 'x' to the files, example:

```
chmod +x legacy_installer.sh
```

## First steps

First steps you need to know the name of device, in this example case is 'sdb': 

```
sudo lsblk | grep -v sda
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop3    7:3    0     2G  1 loop /media/jonathan/Win10
sdb      8:16   1  15,1G  0 disk 
└─sdb1   8:17   1  15,1G  0 part /media/jonathan/WINDOWS
sr0     11:0    1  1024M  0 rom

```

Open the file and change the name of the device assuming it is 'sdb' and then the new name that we will give to the pendrive example 'MYUSB'), it must be simple, with capital letters and without numbers, now save the file:

```
usb='sdb'
usb_name='MYUSB'
```

## How to use Legacy installer script (MSDOS file system with FAT32)
Important: FAT32 does not allow copying files larger than 4 gb that's why the largest file of the windows installer is divided into 3 with wimlib-imagex.

Execute with:

```
sudo sh '/your/folder/path/legacy_installer.sh'
```

You should be able to see the folder called 'grub' on your pendrive, (at this point your flash drive is bootable).

1. Disconnect your flash drive and reconnect it.
2. Copy all the files from your Windows iso into the root of the pendrive not inside the 'grub' folder.
3. Connect yout flash drive to your pc.
4. Boot in legacy mode and install Windows.

## How to use UEFI installer script (GPT file system with FAT32 and NTFS)

- Same as legacy mode but configure the uefi options of your motherboard and boot as uefi mode.

## How to use win10_installer script (MSDOS file system with FAT32)
Important: FAT32 does not allow copying files larger than 4 gb that's why the largest file of the windows installer is divided into 3 with wimlib-imagex.

- Same as legacy mode but modify the path of your Windows iso.

## Built With

* GNU bash, versión 5.0.3(1)-release (x86_64-pc-linux-gnu)

## Authors

* **Jonathan Burgos Saldivia** - *on Github* - [jonathanburgossaldivia](https://github.com/jonathanburgossaldivia)

## License

This project is licensed under the Eclipse Public License 2.0 - see the [LICENSE.md](LICENSE.md) file for details
