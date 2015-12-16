#!/bin/bash
#This script will automatically create a partition for you to install Steam games on under Ubuntu/Debian systems on a separate hard drive. This has not been made for use with other distros, which will come in the future. You must execute this script as root.

echo "**WARNING** This script has the potential to fuck up your computer. Please make sure you are using the right hard drive before attempting this, that there is sufficient space on your hard drive prior to use, and that you are SURE you want these things to happen."

echo "What is your user name?"
read usname

echo "You will need to pick a hard drive to install your games on. The name of the drive should be in this format: '/dev/sd*'. You can find the name of your device by opening up a separate terminal and entering 'sudo lshw -C disk'. Please enter the name of the drive."

read drive

echo "The drive you will install Steam Games too needs a name. What would you like to name that location?"

read label

echo "The directory where you will be installing games needs a name. What would you like to name that directory?"

read direct

echo "The size of the location where you are installing your games needs a size. Please enter the size of the location in MiB. If unsure, just enter 'x' for a default value of 100 gigabytes (100,000 MiB)."

read size
if [[ $size="x" ]]
	then
	size="103017"
fi

echo "We are now creating the place where you will install your games. This may take a bit."

(echo n; echo p; echo 2; echo ; echo "+"$size"MB"; echo w) | sudo fdisk $drive

drive2=$drive"2"
mkfs.ext4 $drive2

sudo e2label /dev/sda2 $label
sudo e2label /dev/sda2 $label

echo "Waiting 10 seconds while magic happens..."
sleep 10

cd /media/$usname/$label
sudo mkdir $direct
sudo chown $usname:$usname $direct"/"
sudo chmod 700 $direct"/"
uuidvar=$(sudo blkid /dev/sdc1 | awk '{print substr($2,7,36)}')
sudo echo "#$direct" >> /etc/fstab
sudo echo "UUID=$uuidvar    /media/$usname/$label/$direct   ext4    rw,users,exec,auto    0   0" >> /etc/fstab
mount $direct"/"
sudo chown $usname:$usname $direct
sudo chmod 700 $direct
umount $direct"/"


read -p "The creation of your drive was successful. **YOU MUST REBOOT BEFORE ATTEMPTING TO INSTALL ANYTHING TO THE NEW DRIVE.** Would you like to restart now?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
	then
		sudo reboot
	fi
elif
		sudo exit
	fi
