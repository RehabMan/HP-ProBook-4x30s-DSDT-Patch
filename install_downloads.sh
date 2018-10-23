#!/bin/bash
#set -x

EXCEPTIONS=
ESSENTIAL="AppleALC.kext CodecCommander.kext ProBookAtheros.kext"

# include subroutines
source "$(dirname ${BASH_SOURCE[0]})"/_tools/_install_subs.sh

warn_about_superuser

# install tools
install_tools

# remove kexts that are no longer used
remove_deprecated_kexts
remove_kext AppleHDAIDT.kext
remove_kext AppleHDAALC.kext
remove_kext USBXHCI_4x40s.kext
remove_kext SATA-100-series-unsupported.kext
remove_kext AppleHDA_ProBook.kext

# using AppleALC.kext, remove patched zml.zlib files
sudo rm -f /System/Library/Extensions/AppleHDA.kext/Contents/Resources/*.zml.zlib

# install required kexts
install_download_kexts
install_brcmpatchram_kexts
install_fakepciid_xhcimux
install_fakepciid_intel_hdmi_audio
install_backlight_kexts

# install special kexts specific to ProBook
install_kext kexts/HSSDBlockStorage.kext
install_kext kexts/JMB38X.kext
install_kext kexts/JMicronATA.kext
# install other common kexts
install_kext _tools/kexts/XHCI-unsupported.kext
install_kext _tools/kexts/SATA-unsupported.kext
install_kext _tools/kexts/ProBookAtheros.kext

# install special build of AppleALC.kext until fixed build is available
install_kext kexts/AppleALC.kext

# install HackrNVMEFamily-.* if it is found in Clover/kexts
EFI="$(./mount_efi.sh)"
kext="$(echo "$EFI"/EFI/CLOVER/kexts/Other/HackrNVMeFamily-*.kext)"
if [[ -e "$kext" ]]; then
    install_kext "$kext"
fi

# LiluFriend and kernel cache rebuild
finish_kexts

# update kexts on EFI/CLOVER/kexts/Other
update_efi_kexts

# install HPFanReset.efi
zip=`echo -n _downloads/efi/HPFanReset*.zip`
out=${zip/.efi.zip/}
rm -Rf $out && unzip -q -d $out $zip
echo copying $out/*.efi to "$EFI"/EFI/CLOVER/drivers64UEFI
cp $out/*.efi "$EFI"/EFI/CLOVER/drivers64UEFI

# delete old kexts that might be on EFI
rm -Rf "$EFI"/EFI/CLOVER/kexts/Other/SATA-100-series-unsupported.kext

# VoodooPS2Daemon is deprecated
remove_voodoops2daemon

#EOF

