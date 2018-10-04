# makefile

#
# Patches/Installs/Builds DSDT patches for HP ProBook/EliteBook/ZBook
#
# Created by RehabMan
#

BUILDDIR=./build
HOTPATCH=./hotpatch
HACK=$(wildcard $(HOTPATCH)/*.dsl)
HACK:=$(subst $(HOTPATCH),$(BUILDDIR),$(HACK))
HACK:=$(subst .dsl,.aml,$(HACK))
HACK:=$(HACK) $(BUILDDIR)/SSDT-IGPUH.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-FANQ.aml $(BUILDDIR)/SSDT-FANRM.aml $(BUILDDIR)/SSDT-FANGRAP.aml

# system specfic config.plist
PLIST:= \
    config/config_4x30.plist config/config_4x40.plist \
	config/config_4x0_G0.plist config/config_4x0_G1_Ivy.plist config/config_ZBook_G0.plist \
	config/config_8x0_G1_Ivy.plist config/config_9x70m.plist \
	config/config_9x80m.plist \
	config/config_2x60p.plist config/config_6x60p.plist config/config_8x60p.plist config/config_5x30m.plist \
	config/config_6x70p.plist config/config_8x70p.plist config/config_2x70p.plist \
	config/config_3x0_G1.plist \
	config/config_8x0_G1_Haswell.plist config/config_4x0_G1_Haswell.plist \
	config/config_4x0_G2_Haswell.plist config/config_8x0_G2_Haswell.plist \
	config/config_4x0_G2_Broadwell.plist config/config_8x0_G2_Broadwell.plist \
	config/config_1020_G1_Broadwell.plist \
	config/config_ZBook_G1_Haswell.plist config/config_ZBook_G2_Haswell.plist config/config_ZBook_G2_Broadwell.plist \
	config/config_ZBook_G2_Haswell_ALC280.plist \
	config/config_ZBook_G3_Skylake.plist \
	config/config_4x0_G3_Skylake.plist \
	config/config_8x0_G3_Skylake.plist \
	config/config_1030_G1_Skylake.plist \
	config/config_6x0_G2_Skylake.plist \
	config/config_1040_G1_Haswell.plist config/config_6x0_G1_Haswell.plist \
	config/config_1040_G3_Skylake.plist config/config_1050_G1_KabyLake-R.plist \
	config/config_4x0_G4_Kabylake.plist config/config_4x0_G5_Kabylake-R.plist config/config_8x0_G4_Kabylake.plist

.PHONY: all
all : $(HACK) $(PLIST)

.PHONY: clean
clean: 
	rm -f $(HACK) $(PLIST)

make_config.sh: makefile
	echo '#!/bin/bash'>$@
	make -n -B -s $(PLIST) >>$@
	chmod +x $@

make_acpi.sh: makefile
	echo '#!/bin/bash'>$@
	make -n -B -s $(HACK) >>$@
	chmod +x $@

install_acpi_include.sh: makefile
	echo CORE=\"$(CORE)\">$@
	chmod +x $@

.PHONY: force_update
force_update:
	make -B make_config.sh make_acpi.sh
	make -B install_acpi_include.sh
	./find_dependencies.sh >makefile.d

# dependencies for model specific SSDTs
include makefile.d

# generated config.plist files

PARTS=config_parts

# 4x30s is IDT76d1, HD3000, HDMI, non-Intel USB3
config/config_4x30.plist : $(PARTS)/config_master.plist $(PARTS)/config_HD3000-4000_hdmi.plist $(PARTS)/config_non_Intel_USB3.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:KernelPm false" $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set SMBIOS:ProductName MacBookPro8,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_hdmi.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_non_Intel_USB3.plist $@
	@printf "\n"

# 4x40s is IDT76d9, HD3000 or HD4000, HDMI
config/config_4x40.plist : $(PARTS)/config_master.plist $(PARTS)/config_HD3000-4000_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_hdmi.plist $@
	@printf "\n"

# 4x0_G0 is IDT 76e0, HD4000, HDMI
config/config_4x0_G0.plist : $(PARTS)/config_master.plist $(PARTS)/config_HD3000-4000_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_hdmi.plist $@
	@printf "\n"

# 4x0_G1_Ivy is same as 4x0_G0
config/config_4x0_G1_Ivy.plist: config/config_4x0_G0.plist
	@printf "!! creating $@\n"
	cp config/config_4x0_G0.plist $@
	@printf "\n"

# 8x0_G1_Ivy is IDT 76e0, HD4000, DP
config/config_8x0_G1_Ivy.plist: $(PARTS)/config_master.plist $(PARTS)/config_HD3000-4000_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_dp.plist $@
	@printf "\n"

# ZBook_G0 is same as 8x0_G1_Ivy
config/config_ZBook_G0.plist: config/config_8x0_G1_Ivy.plist
	@printf "!! creating $@\n"
	cp config/config_8x0_G1_Ivy.plist $@
	@printf "\n"

# 9x70m is IDT 76e0, HD4000, DP
config/config_9x70m.plist : $(PARTS)/config_master.plist $(PARTS)/config_HD3000-4000_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_dp.plist $@
	@printf "\n"

# 9x80m is ALC280, HD4400, DP
config/config_9x80m.plist : $(PARTS)/config_master.plist $(PARTS)/config_Haswell_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Haswell_dp.plist $@
	@printf "\n"

# 4x0_G1_Haswell is IDT 76e0, HD4400, HDMI
config/config_4x0_G1_Haswell.plist : $(PARTS)/config_master.plist $(PARTS)/config_Haswell_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Haswell_hdmi.plist $@
	@printf "\n"

# 8x0_G1_Haswell is IDT 76e0, HD4400, DP
config/config_8x0_G1_Haswell.plist : $(PARTS)/config_master.plist $(PARTS)/config_Haswell_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Haswell_dp.plist $@
	@printf "\n"

# 6x0_G1_Haswell is same as 8x0_G1_Haswell
config/config_6x0_G1_Haswell.plist : config/config_8x0_G1_Haswell.plist
	@printf "!! creating $@\n"
	cp config/config_8x0_G1_Haswell.plist $@
	@printf "\n"

# 1040_G1_Haswell is same as 8x0_G1_Haswell
config/config_1040_G1_Haswell.plist : config/config_8x0_G1_Haswell.plist
	@printf "!! creating $@\n"
	cp config/config_8x0_G1_Haswell.plist $@
	@printf "\n"

# 6x60p is IDT7605, HD3000, non-Intel USB3, DP
config/config_6x60p.plist : $(PARTS)/config_master.plist $(PARTS)/config_HD3000-4000_dp.plist $(PARTS)/config_non_Intel_USB3.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:KernelPm false" $@
	/usr/libexec/PlistBuddy -c "Set SMBIOS:ProductName MacBookPro8,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_dp.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_non_Intel_USB3.plist $@
	@printf "\n"

# 8x60p is same as 6x60p
config/config_8x60p.plist : config/config_6x60p.plist
	@printf "!! creating $@\n"
	cp config/config_6x60p.plist $@
	@printf "\n"

# 2x60p is same as 6x60p
config/config_2x60p.plist : config/config_6x60p.plist
	@printf "!! creating $@\n"
	cp config/config_6x60p.plist $@
	@printf "\n"

# 5x30m is IDT7605, HD3000, non-Intel USB3, HDMI
config/config_5x30m.plist : $(PARTS)/config_master.plist $(PARTS)/config_HD3000-4000_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:KernelPm false" $@
	/usr/libexec/PlistBuddy -c "Set SMBIOS:ProductName MacBookPro8,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_hdmi.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_non_Intel_USB3.plist $@
	@printf "\n"

# 6x70p is IDT7605, HD4000, DP
config/config_6x70p.plist : $(PARTS)/config_master.plist $(PARTS)/config_HD3000-4000_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_dp.plist $@
	@printf "\n"

# 8x70p is same as 6x70p
config/config_8x70p.plist : config/config_6x70p.plist
	@printf "!! creating $@\n"
	cp config/config_6x70p.plist $@
	@printf "\n"

# 2x70p is same as 6x70p
config/config_2x70p.plist : config/config_6x70p.plist
	@printf "!! creating $@\n"
	cp config/config_6x70p.plist $@
	@printf "\n"

# 3x0_G1 is IDT7695, HD4000, HDMI
config/config_3x0_G1.plist : $(PARTS)/config_master.plist $(PARTS)/config_HD3000-4000_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_hdmi.plist $@
	@printf "\n"

# 4x0_G2_Haswell is ALC282, Haswell, HDMI
config/config_4x0_G2_Haswell.plist : $(PARTS)/config_master.plist $(PARTS)/config_Haswell_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Haswell_hdmi.plist $@
	@printf "\n"

# 8x0_G2_Haswell is ALC282, Haswell, DP
config/config_8x0_G2_Haswell.plist: $(PARTS)/config_master.plist $(PARTS)/config_Haswell_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Haswell_dp.plist $@
	@printf "\n"

# 4x0_G2_Broadwell is ALC282, Broadwell, HDMI
config/config_4x0_G2_Broadwell.plist : $(PARTS)/config_master.plist $(PARTS)/config_Broadwell_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir7,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Broadwell_hdmi.plist $@
	@printf "\n"

# 8x0_G2_Broadwell is ALC280, Broadwell, DP
config/config_8x0_G2_Broadwell.plist : $(PARTS)/config_master.plist $(PARTS)/config_Broadwell_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir7,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Broadwell_dp.plist $@
	@printf "\n"

# 1020_G1_Broadwell is ALC286, Broadwell, HDMI
config/config_1020_G1_Broadwell.plist : $(PARTS)/config_master.plist $(PARTS)/config_Broadwell_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir7,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Broadwell_hdmi.plist $@
	@printf "\n"

# ZBook_G2_Haswell is IDT 76e0, Haswell, no external ports for Intel graphics
# confirmed here: http://www.tonymacx86.com/el-capitan-laptop-guides/189416-guide-hp-probook-elitebook-zbook-using-clover-uefi-hotpatch-10-11-a-76.html#post1242529
config/config_ZBook_G2_Haswell.plist : $(PARTS)/config_master.plist $(PARTS)/config_Haswell_no_hdmi_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Haswell_no_hdmi_dp.plist $@
	@printf "\n"

# ZBook_G1_Haswell is same as ZBook_G2_Haswell
config/config_ZBook_G1_Haswell.plist : config/config_ZBook_G2_Haswell.plist
	@printf "!! creating $@\n"
	cp config/config_ZBook_G2_Haswell.plist $@
	@printf "\n"

# ZBook_G2_Haswell_ALC280 is ALC280, Haswell, DP
config/config_ZBook_G2_Haswell_ALC280.plist : $(PARTS)/config_master.plist $(PARTS)/config_Haswell_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Haswell_dp.plist $@
	@printf "\n"

# ZBook_G2_Broadwell is ALC280, Broadwell, DP
config/config_ZBook_G2_Broadwell.plist : $(PARTS)/config_master.plist $(PARTS)/config_Broadwell_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Broadwell_dp.plist $@
	@printf "\n"

# ProBook_4x0_G3_Skylake is CX20724, Skylake, HDMI
config/config_4x0_G3_Skylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_Skylake_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Skylake_hdmi.plist $@
	@printf "\n"

# ProBook_8x0_G3_Skylake is CX20724, Skylake, DP
config/config_8x0_G3_Skylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_Skylake_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Skylake_dp.plist $@
	@printf "\n"

# EliteBook 1030_G1_Skylake is same as 8x0_G3_Skylake
config/config_1030_G1_Skylake.plist : config/config_8x0_G3_Skylake.plist
	@printf "!! creating $@\n"
	cp config/config_8x0_G3_Skylake.plist $@
	@printf "\n"

# ZBook_G3_Skylake is same as 8x0_G3_Skylake
config/config_ZBook_G3_Skylake.plist : config/config_8x0_G3_Skylake.plist
	@printf "!! creating $@\n"
	cp config/config_8x0_G3_Skylake.plist $@
	@printf "\n"

# ProBook_6x0_G2_Skylake is CX20724, Skylake, DP
config/config_6x0_G2_Skylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_Skylake_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Skylake_dp.plist $@
	@printf "\n"

# EliteBook 1040_G3_Skylake is CX20724, Skylake, DP
config/config_1040_G3_Skylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_Skylake_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Skylake_dp.plist $@
	@printf "\n"

#REVIEW: CX20724 is not correct for the 1050 (it uses a new audio codec)
# EliteBook 1050_G1_KabyLake-R is CX20724, KabyLake-R, DP
config/config_1050_G1_KabyLake-R.plist : $(PARTS)/config_master.plist $(PARTS)/config_Kabylake_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Kabylake_dp.plist $@
	@printf "\n"

# ProBook_4x0_G4_Kabylake is CX8200, Kabylake, HDMI
config/config_4x0_G4_Kabylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_Kabylake_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Kabylake_hdmi.plist $@
	@printf "\n"

# ProBook_4x0_G5_Kabylake-R is same as 4x0_G4_Kabylake
config/config_4x0_G5_Kabylake-R.plist : config/config_4x0_G4_Kabylake.plist
	@printf "!! creating $@\n"
	cp config/config_4x0_G4_Kabylake.plist $@
	@printf "\n"

# EliteBook_8x0_G4_Kabylake is CX8200, Kabylake, DP
config/config_8x0_G4_Kabylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_Kabylake_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Kabylake_dp.plist $@
	@printf "\n"

# new hotpatch SSDTs

IASLOPTS=-vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr
# note: "-oe" is undocumented flag to turn off external opcode in iasl AML compilation result
# Snow Leopard cannot handle SSDTs with the external opcode, so Snow Leopard users must enable this flag
#IASLOPTS:=$(IASLOPTS) -oe

$(BUILDDIR)/%.aml : $(HOTPATCH)/%.dsl
	iasl $(IASLOPTS) -p $@ $<

$(BUILDDIR)/SSDT-IGPUH.aml : $(HOTPATCH)/SSDT-IGPU.dsl
	iasl -D HIRES $(IASLOPTS) -p $@ $<

$(BUILDDIR)/SSDT-FANQ.aml : $(HOTPATCH)/SSDT-FANQ.dsl
	iasl -D QUIET $(IASLOPTS) -p $@ $<

$(BUILDDIR)/SSDT-FANRM.aml : $(HOTPATCH)/SSDT-FANQ.dsl
	iasl -D REHABMAN $(IASLOPTS) -p $@ $<

$(BUILDDIR)/SSDT-FANGRAP.aml : $(HOTPATCH)/SSDT-FANQ.dsl
	iasl -D GRAPPLER $(IASLOPTS) -p $@ $<

#EOF
