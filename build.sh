#!/bin/bash

./make_config.sh
./make_acpi.sh


echo "Is this a Elitebook 8640/8470? (y/n)"
read in
if [ $in == "y" ]; then
	SOURCE="${BASH_SOURCE[0]}"
	cp -r $SOURCE/kexts/AppleALC.kext /Volumes/EFI/EFI/CLOVER/kexts/Other/AppleALC.kext
fi
./patch_hda.sh ProBook
