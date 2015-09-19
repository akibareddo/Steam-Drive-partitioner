#!/bin/bash
#This script will automatically create a partition for you to install Steam games on under Ubuntu/Debian systems on a separate hard drive. This has not been made for use with other distros, which will come in the future. You must execute this script as root.

echo "**WARNING** This script has the potential to fuck up your computer. Please make sure you are using the right hard drive before attempting this, that there is sufficient space on your hard drive prior to use, and that you are SURE you want these things to happen.\n"

echo "You will need to pick a hard drive to install your games on. The name of the drive should be in this format: '/dev/sd*'. You can find the name of your device by opening up a separate terminal and entering 'sudo lshw -C disk'. Please enter the name of the drive.\n"

read drive

echo "The location you will install Steam Games too needs a name. What would you like to name that location?\n"

read label

echo "The size of the location where you are installing your games needs a size. Please enter the size of the location in MiB. If unsure, just enter 'x' for a default value of 100 gigabytes (100,000 MiB).\n"

read size
if $size="x"
	size=103017	

echo "We are now creating the place where you will install your games. This may take a bit.\n"

(echo n; echo p; echo 4; echo 1; echo $size; echo w) | sudo fdisk $drive
drive4="$drive""4"

mkfs.ext4 $drive4

cd /media
sudo chown $USER:$USER $label/
sudo chmod 700 $label
uuidvar=sudo blkid /dev/sda2 | awk '{print substr($3,7,36)}'
sudo echo "#steam drive\n UUID=$uuidvar    /media/$label   ext4    rw,users,exec,auto    0   0" >> /etc/fstab
mount steamgames/
sudo chown $USER:$USER $label/
sudo chmod 700 $label/
umount steamgames/


read -p "The creation of your drive was successful. **YOU MUST REBOOT BEFORE ATTEMPTING TO INSTALL ANYTHING TO THE NEW DRIVE.** Would you like to restart now?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
	then
		sudo reboot
	fi
elif
		sudo exit
	fi
