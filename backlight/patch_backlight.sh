#!/bin/bash

#set -x

uid=10
vanilla=/System/Library/Extensions/AppleBacklight.kext

ioreg -n IGPU -arxw0>/tmp/org.rehabman.gfx.plist
if [ ! -s /tmp/org.rehabman.gfx.plist ]; then
    ioreg -n GFX0 -arxw0>/tmp/org.rehabman.gfx.plist
fi
if [ ! -s /tmp/org.rehabman.gfx.plist ]; then
    echo Error generating AppleBaclightInjector.kext; not able to determine graphics device!
    exit 1
fi

devid=`/usr/libexec/PlistBuddy -c "Print :0:device-id" /tmp/org.rehabman.gfx.plist|xxd -p`
devid=${devid:0:8}
case $devid in
    16010000 | 26010000 | 12010000 | 22010000 | 66010000 | 42000000 | 46000000)
        pwmmax=0x710
        ;;

    *)
        pwmmax=0xad9
        ;;
esac

echo using Backlight_$pwmmax.plist, for device $devid

ioreg -n AppleBacklightDisplay -arxw0>/tmp/org.rehabman.display.plist
if [ ! -s /tmp/org.rehabman.display.plist ]; then
    ioreg -n AppleDisplay -arxw0>/tmp/org.rehabman.display.plist
fi
if [ ! -s /tmp/org.rehabman.display.plist ]; then
    echo Error generating AppleBaclightInjector.kext; not able to determine display-id!
    exit 1
fi
id=`/usr/libexec/PlistBuddy -c "Print :0:DisplayProductID" /tmp/org.rehabman.display.plist`
id=`printf "F%02dT%04x" $uid $id`
sed "s/F99T1234/$id/g" Backlight_$pwmmax.plist >/tmp/org.rehabman.merge.plist

if [ -d AppleBacklightInjector.kext ]; then rm -Rf AppleBacklightInjector.kext; fi
cp -RX /System/Library/Extensions/AppleBacklight.kext AppleBacklightInjector.kext
plist=AppleBacklightInjector.kext/Contents/Info.plist
#/usr/libexec/PlistBuddy -c "Copy ':IOKitPersonalities:AppleIntelPanelA:ApplePanels' ':ApplePanelsBackup'" $plist
/usr/libexec/PlistBuddy -c "Delete ':IOKitPersonalities:AppleIntelPanelA:ApplePanels'" $plist
/usr/libexec/PlistBuddy -c "Merge /tmp/org.rehabman.merge.plist ':IOKitPersonalities:AppleIntelPanelA'" $plist
#/usr/libexec/PlistBuddy -c "Copy ':ApplePanelsBackup:Default' ':IOKitPersonalities:AppleIntelPanelA:ApplePanels:Default'" $plist
#/usr/libexec/PlistBuddy -c "Delete ':ApplePanelsBackup'" $plist
/usr/libexec/PlistBuddy -c "Delete ':BuildMachineOSBuild'" $plist
/usr/libexec/PlistBuddy -c "Delete ':DTCompiler'" $plist
/usr/libexec/PlistBuddy -c "Delete ':DTPlatformBuild'" $plist
/usr/libexec/PlistBuddy -c "Delete ':DTPlatformVersion'" $plist
/usr/libexec/PlistBuddy -c "Delete ':DTSDKBuild'" $plist
/usr/libexec/PlistBuddy -c "Delete ':DTSDKName'" $plist
/usr/libexec/PlistBuddy -c "Delete ':DTXcode'" $plist
/usr/libexec/PlistBuddy -c "Delete ':DTXcodeBuild'" $plist
/usr/libexec/PlistBuddy -c "Delete ':OSBundleLibraries'" $plist
/usr/libexec/PlistBuddy -c "Delete ':CFBundleExecutable'" $plist
/usr/libexec/PlistBuddy -c "Set ':CFBundleGetInfoString' '0.9.0, Copyright 2013 RehabMan Inc. All rights reserved.'" $plist
/usr/libexec/PlistBuddy -c "Set ':CFBundleIdentifier' 'org.rehabman.injector.AppleBacklightInjector'" $plist
/usr/libexec/PlistBuddy -c "Set ':CFBundleName' 'AppleBacklightInjector'" $plist
/usr/libexec/PlistBuddy -c "Set ':CFBundleShortVersionString' '0.9.0'" $plist
/usr/libexec/PlistBuddy -c "Set ':CFBundleVersion' '0.9.0'" $plist
/usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:AppleIntelPanelA:IOProbeScore' 2500" $plist
rm -R AppleBacklightInjector.kext/Contents/_CodeSignature
rm -R AppleBacklightInjector.kext/Contents/MacOS
rm AppleBacklightInjector.kext/Contents/version.plist

echo "Patched AppleBacklight.kext for DisplayID: " $id
