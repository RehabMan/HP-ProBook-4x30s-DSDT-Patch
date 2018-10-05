#!/bin/bash
printf "!! creating config/config_4x30.plist\n"
cp config_parts/config_master.plist config/config_4x30.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:KernelPm false" config/config_4x30.plist
/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" config/config_4x30.plist
/usr/libexec/PlistBuddy -c "Set SMBIOS:ProductName MacBookPro8,1" config/config_4x30.plist
./merge_plist.sh "Devices:Properties" config_parts/config_HD3000-4000_hdmi.plist config/config_4x30.plist
./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_parts/config_non_Intel_USB3.plist config/config_4x30.plist
printf "\n"
printf "!! creating config/config_4x40.plist\n"
cp config_parts/config_master.plist config/config_4x40.plist
/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" config/config_4x40.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" config/config_4x40.plist
./merge_plist.sh "Devices:Properties" config_parts/config_HD3000-4000_hdmi.plist config/config_4x40.plist
printf "\n"
printf "!! creating config/config_4x0_G0.plist\n"
cp config_parts/config_master.plist config/config_4x0_G0.plist
/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" config/config_4x0_G0.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" config/config_4x0_G0.plist
./merge_plist.sh "Devices:Properties" config_parts/config_HD3000-4000_hdmi.plist config/config_4x0_G0.plist
printf "\n"
printf "!! creating config/config_4x0_G1_Ivy.plist\n"
cp config/config_4x0_G0.plist config/config_4x0_G1_Ivy.plist
printf "\n"
printf "!! creating config/config_8x0_G1_Ivy.plist\n"
cp config_parts/config_master.plist config/config_8x0_G1_Ivy.plist
/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" config/config_8x0_G1_Ivy.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" config/config_8x0_G1_Ivy.plist
./merge_plist.sh "Devices:Properties" config_parts/config_HD3000-4000_dp.plist config/config_8x0_G1_Ivy.plist
printf "\n"
printf "!! creating config/config_ZBook_G0.plist\n"
cp config/config_8x0_G1_Ivy.plist config/config_ZBook_G0.plist
printf "\n"
printf "!! creating config/config_9x70m.plist\n"
cp config_parts/config_master.plist config/config_9x70m.plist
/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" config/config_9x70m.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" config/config_9x70m.plist
./merge_plist.sh "Devices:Properties" config_parts/config_HD3000-4000_dp.plist config/config_9x70m.plist
printf "\n"
printf "!! creating config/config_9x80m.plist\n"
cp config_parts/config_master.plist config/config_9x80m.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_9x80m.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" config/config_9x80m.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Haswell_dp.plist config/config_9x80m.plist
printf "\n"
printf "!! creating config/config_6x60p.plist\n"
cp config_parts/config_master.plist config/config_6x60p.plist
/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" config/config_6x60p.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:KernelPm false" config/config_6x60p.plist
/usr/libexec/PlistBuddy -c "Set SMBIOS:ProductName MacBookPro8,1" config/config_6x60p.plist
./merge_plist.sh "Devices:Properties" config_parts/config_HD3000-4000_dp.plist config/config_6x60p.plist
./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_parts/config_non_Intel_USB3.plist config/config_6x60p.plist
printf "\n"
printf "!! creating config/config_2x60p.plist\n"
cp config/config_6x60p.plist config/config_2x60p.plist
printf "\n"
printf "!! creating config/config_8x60p.plist\n"
cp config/config_6x60p.plist config/config_8x60p.plist
printf "\n"
printf "!! creating config/config_5x30m.plist\n"
cp config_parts/config_master.plist config/config_5x30m.plist
/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" config/config_5x30m.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:KernelPm false" config/config_5x30m.plist
/usr/libexec/PlistBuddy -c "Set SMBIOS:ProductName MacBookPro8,1" config/config_5x30m.plist
./merge_plist.sh "Devices:Properties" config_parts/config_HD3000-4000_hdmi.plist config/config_5x30m.plist
./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_parts/config_non_Intel_USB3.plist config/config_5x30m.plist
printf "\n"
printf "!! creating config/config_6x70p.plist\n"
cp config_parts/config_master.plist config/config_6x70p.plist
/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" config/config_6x70p.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" config/config_6x70p.plist
./merge_plist.sh "Devices:Properties" config_parts/config_HD3000-4000_dp.plist config/config_6x70p.plist
printf "\n"
printf "!! creating config/config_8x70p.plist\n"
cp config/config_6x70p.plist config/config_8x70p.plist
printf "\n"
printf "!! creating config/config_2x70p.plist\n"
cp config/config_6x70p.plist config/config_2x70p.plist
printf "\n"
printf "!! creating config/config_3x0_G1.plist\n"
cp config_parts/config_master.plist config/config_3x0_G1.plist
/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" config/config_3x0_G1.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" config/config_3x0_G1.plist
./merge_plist.sh "Devices:Properties" config_parts/config_HD3000-4000_hdmi.plist config/config_3x0_G1.plist
printf "\n"
printf "!! creating config/config_8x0_G1_Haswell.plist\n"
cp config_parts/config_master.plist config/config_8x0_G1_Haswell.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_8x0_G1_Haswell.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" config/config_8x0_G1_Haswell.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Haswell_dp.plist config/config_8x0_G1_Haswell.plist
printf "\n"
printf "!! creating config/config_4x0_G1_Haswell.plist\n"
cp config_parts/config_master.plist config/config_4x0_G1_Haswell.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_4x0_G1_Haswell.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" config/config_4x0_G1_Haswell.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Haswell_hdmi.plist config/config_4x0_G1_Haswell.plist
printf "\n"
printf "!! creating config/config_4x0_G2_Haswell.plist\n"
cp config_parts/config_master.plist config/config_4x0_G2_Haswell.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_4x0_G2_Haswell.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" config/config_4x0_G2_Haswell.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Haswell_hdmi.plist config/config_4x0_G2_Haswell.plist
printf "\n"
printf "!! creating config/config_8x0_G2_Haswell.plist\n"
cp config_parts/config_master.plist config/config_8x0_G2_Haswell.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_8x0_G2_Haswell.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" config/config_8x0_G2_Haswell.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Haswell_dp.plist config/config_8x0_G2_Haswell.plist
printf "\n"
printf "!! creating config/config_4x0_G2_Broadwell.plist\n"
cp config_parts/config_master.plist config/config_4x0_G2_Broadwell.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_4x0_G2_Broadwell.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir7,2" config/config_4x0_G2_Broadwell.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Broadwell_hdmi.plist config/config_4x0_G2_Broadwell.plist
printf "\n"
printf "!! creating config/config_8x0_G2_Broadwell.plist\n"
cp config_parts/config_master.plist config/config_8x0_G2_Broadwell.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_8x0_G2_Broadwell.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir7,2" config/config_8x0_G2_Broadwell.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Broadwell_dp.plist config/config_8x0_G2_Broadwell.plist
printf "\n"
printf "!! creating config/config_8x0_G3_Broadwell.plist\n"
cp config/config_8x0_G2_Broadwell.plist config/config_8x0_G3_Broadwell.plist
printf "\n"
printf "!! creating config/config_1020_G1_Broadwell.plist\n"
cp config_parts/config_master.plist config/config_1020_G1_Broadwell.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_1020_G1_Broadwell.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir7,2" config/config_1020_G1_Broadwell.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Broadwell_hdmi.plist config/config_1020_G1_Broadwell.plist
printf "\n"
printf "!! creating config/config_ZBook_G2_Haswell.plist\n"
cp config_parts/config_master.plist config/config_ZBook_G2_Haswell.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_ZBook_G2_Haswell.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" config/config_ZBook_G2_Haswell.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Haswell_no_hdmi_dp.plist config/config_ZBook_G2_Haswell.plist
printf "\n"
printf "!! creating config/config_ZBook_G1_Haswell.plist\n"
cp config/config_ZBook_G2_Haswell.plist config/config_ZBook_G1_Haswell.plist
printf "\n"
printf "!! creating config/config_ZBook_G2_Broadwell.plist\n"
cp config_parts/config_master.plist config/config_ZBook_G2_Broadwell.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_ZBook_G2_Broadwell.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" config/config_ZBook_G2_Broadwell.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Broadwell_dp.plist config/config_ZBook_G2_Broadwell.plist
printf "\n"
printf "!! creating config/config_ZBook_G2_Haswell_ALC280.plist\n"
cp config_parts/config_master.plist config/config_ZBook_G2_Haswell_ALC280.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_ZBook_G2_Haswell_ALC280.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" config/config_ZBook_G2_Haswell_ALC280.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Haswell_dp.plist config/config_ZBook_G2_Haswell_ALC280.plist
printf "\n"
printf "!! creating config/config_8x0_G3_Skylake.plist\n"
cp config_parts/config_master.plist config/config_8x0_G3_Skylake.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_8x0_G3_Skylake.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" config/config_8x0_G3_Skylake.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Skylake_dp.plist config/config_8x0_G3_Skylake.plist
printf "\n"
printf "!! creating config/config_ZBook_G3_Skylake.plist\n"
cp config/config_8x0_G3_Skylake.plist config/config_ZBook_G3_Skylake.plist
printf "\n"
printf "!! creating config/config_4x0_G3_Skylake.plist\n"
cp config_parts/config_master.plist config/config_4x0_G3_Skylake.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_4x0_G3_Skylake.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" config/config_4x0_G3_Skylake.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Skylake_hdmi.plist config/config_4x0_G3_Skylake.plist
printf "\n"
printf "!! creating config/config_1030_G1_Skylake.plist\n"
cp config/config_8x0_G3_Skylake.plist config/config_1030_G1_Skylake.plist
printf "\n"
printf "!! creating config/config_6x0_G2_Skylake.plist\n"
cp config_parts/config_master.plist config/config_6x0_G2_Skylake.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_6x0_G2_Skylake.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" config/config_6x0_G2_Skylake.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Skylake_dp.plist config/config_6x0_G2_Skylake.plist
printf "\n"
printf "!! creating config/config_1040_G1_Haswell.plist\n"
cp config/config_8x0_G1_Haswell.plist config/config_1040_G1_Haswell.plist
printf "\n"
printf "!! creating config/config_6x0_G1_Haswell.plist\n"
cp config/config_8x0_G1_Haswell.plist config/config_6x0_G1_Haswell.plist
printf "\n"
printf "!! creating config/config_1040_G3_Skylake.plist\n"
cp config_parts/config_master.plist config/config_1040_G3_Skylake.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_1040_G3_Skylake.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" config/config_1040_G3_Skylake.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Skylake_dp.plist config/config_1040_G3_Skylake.plist
printf "\n"
printf "!! creating config/config_1050_G1_KabyLake-R.plist\n"
cp config_parts/config_master.plist config/config_1050_G1_KabyLake-R.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_1050_G1_KabyLake-R.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" config/config_1050_G1_KabyLake-R.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Kabylake_dp.plist config/config_1050_G1_KabyLake-R.plist
printf "\n"
printf "!! creating config/config_4x0_G4_Kabylake.plist\n"
cp config_parts/config_master.plist config/config_4x0_G4_Kabylake.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_4x0_G4_Kabylake.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" config/config_4x0_G4_Kabylake.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Kabylake_hdmi.plist config/config_4x0_G4_Kabylake.plist
printf "\n"
printf "!! creating config/config_4x0_G5_Kabylake-R.plist\n"
cp config/config_4x0_G4_Kabylake.plist config/config_4x0_G5_Kabylake-R.plist
printf "\n"
printf "!! creating config/config_8x0_G4_Kabylake.plist\n"
cp config_parts/config_master.plist config/config_8x0_G4_Kabylake.plist
/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" config/config_8x0_G4_Kabylake.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" config/config_8x0_G4_Kabylake.plist
./merge_plist.sh "Devices:Properties" config_parts/config_Kabylake_dp.plist config/config_8x0_G4_Kabylake.plist
printf "\n"
