# windows-usb-installer-from-linux
Create a Windows usb installer from Linux
## General information

Tested only on Debian Buster.

### Prerequisites

Packages required:

```
grub-pc-bin, grub-efi-ia32-bin, grub-efi-amd64-bin, parted
```

### Installing

the way to install is like this:

```
sudo apt install grub-pc-bin grub-efi-ia32-bin grub-efi-amd64-bin parted
```

### How to use

Open Terminal app or other console app and change mode to 'x' to the 2 files, example:

```
chmod +x legacy_installer.sh
```
Execute:

```
./legacy_installer.sh
```

## Built With

* GNU bash, versión 5.0.3(1)-release (x86_64-pc-linux-gnu)

## Authors

* **Jonathan Burgos Saldivia** - *on Github* - [jonathanburgossaldivia](https://github.com/jonathanburgossaldivia)

## License

This project is licensed under the Eclipse Public License 2.0 - see the [LICENSE.md](LICENSE.md) file for details
