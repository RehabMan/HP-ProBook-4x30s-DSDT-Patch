#!/bin/bash

#set -x

uid=10
vanilla=/System/Library/Extensions/AppleBacklight.kext

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
sed "s/F99T1234/$id/g" Backlight.plist >/tmp/org.rehabman.merge.plist

if [ -d AppleBacklightInjector.kext ]; then rm -Rf AppleBacklightInjector.kext; fi
cp -R /System/Library/Extensions/AppleBacklight.kext AppleBacklightInjector.kext
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
