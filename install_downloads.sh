#!/bin/bash
#set -x

EXCEPTIONS=
ESSENTIAL=
HDA=ProBook

# include subroutines
DIR=$(dirname ${BASH_SOURCE[0]})
source "$DIR/tools/_install_subs.sh"

warn_about_superuser

# install tools
install_tools

# install required kexts
install_download_kexts
install_brcmpatchram_kexts
install_fakepciid_xhcimux
install_fakepciid_intel_hdmi_audio
remove_deprecated_kexts
install_backlight_kexts

# install special kexts specific to ProBook
install_kext kexts/SATA-unsupported.kext
install_kext kexts/XHCI-300-series-injector.kext
install_kext kexts/HSSDBlockStorage.kext
install_kext kexts/JMB38X.kext
install_kext kexts/JMicronATA.kext
install_kext kexts/ProBookAtheros.kext

# install HackrNVMEFamily-.* if it is found in Clover/kexts
kext=`echo "$EFI"/EFI/CLOVER/kexts/Other/HackrNVMeFamily-*.kext`
if [[ -e "$kext" ]]; then
    install_kext "$kext"
fi

# remove kexts that are no longer used
remove_kext AppleHDAIDT.kext
remove_kext AppleHDAALC.kext
remove_kext USBXHCI_4x40s.kext
remove_kext SATA-100-series-unsupported.kext

# create/install patched AppleHDA files
install_hda

# all kexts are now installed, so rebuild cache
rebuild_kernel_cache

# update kexts on EFI/CLOVER/kexts/Other
update_efi_kexts

# install HPFanReset.efi
EFI=`./mount_efi.sh`
zip=`echo -n _downloads/efi/HPFanReset*.zip`
out=${zip/.efi.zip/}
rm -Rf $out && unzip -q -d $out $zip
echo copying $out/*.efi to $EFI/EFI/CLOVER/drivers64UEFI
cp $out/*.efi $EFI/EFI/CLOVER/drivers64UEFI

# delete old kexts that might be on EFI
rm -Rf $EFI/EFI/CLOVER/kexts/Other/SATA-100-series-unsupported.kext

# VoodooPS2Daemon is deprecated
remove_voodoops2daemon

#EOF

