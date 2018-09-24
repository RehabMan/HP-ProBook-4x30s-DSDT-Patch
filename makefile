# makefile

#
# Patches/Installs/Builds DSDT patches for HP ProBook/EliteBook/ZBook
#
# Created by RehabMan
#

HDA=ProBook
BUILDDIR=./build
RESOURCES=./Resources_$(HDA)
HDAINJECT=AppleHDA_$(HDA).kext
HDAINJECT_MARK=_hdainject_marker.txt
HDAZML=AppleHDA_$(HDA)_Resources
HDAZML_MARK=_hdazml_marker.txt
HDA_PRODUCTS=$(HDAZML_MARK) $(HDAINJECT_MARK)

LE=/Library/Extensions
SLE=/System/Library/Extensions
VERSION_ERA=$(shell ./tools/print_version.sh)
ifeq "$(VERSION_ERA)" "10.10-"
	INSTDIR=$SLE
else
	INSTDIR=$LE
endif

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
all : $(HACK) $(PLIST) $(HDA_PRODUCTS)

.PHONY: clean
clean: 
	rm -f $(HACK) $(PLIST)
	make clean_hda

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

$(HDAZML_MARK): $(RESOURCES)/*.plist tools/patch_hdazml.sh tools/_hda_subs.sh
	./tools/patch_hdazml.sh $(HDA)
	touch $(HDAZML_MARK)

$(HDAINJECT_MARK): $(RESOURCES)/*.plist tools/patch_hdazml.sh tools/_hda_subs.sh
	./tools/patch_hdainject.sh $(HDA)
	touch $(HDAINJECT_MARK)

.PHONY: clean_hda
clean_hda:
	rm -rf $(HDAZML) $(HDAINJECT)
	rm -f $(HDAZML_MARK) $(HDAINJECT_MARK)

.PHONY: update_kernelcache
	update_kernelcache:
	sudo touch $(SLE) && sudo kextcache -update-volume /

.PHONY: install_hda
install_hda:
	sudo rm -Rf $(INSTDIR)/$(HDAINJECT)
	sudo rm -f $(SLE)/AppleHDA.kext/Contents/Resources/*.zml*
	sudo cp $(HDAZML)/* $(SLE)/AppleHDA.kext/Contents/Resources
	if [ "`which tag`" != "" ]; then sudo tag -a Blue $(SLE)/AppleHDA.kext/Contents/Resources/*.zml*; fi
	make update_kernelcache

.PHONY: install_hdadummy
install_hdadummy:
	sudo rm -Rf $(INSTDIR)/$(HDAINJECT)
	sudo cp -R ./$(HDAINJECT) $(INSTDIR)
	sudo rm -f $(SLE)/AppleHDA.kext/Contents/Resources/*.zml*
	if [ "`which tag`" != "" ]; then sudo tag -a Blue $(INSTDIR)/$(HDAINJECT); fi
	make update_kernelcache

# dependencies for model specific SSDTs
include makefile.d

# generated config.plist files

PARTS=config_parts

# 4x30s is IDT76d1, HD3000, HDMI, non-Intel USB3
config/config_4x30.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76d1.plist $(PARTS)/config_HD3000-4000_hdmi.plist $(PARTS)/config_non_Intel_USB3.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:KernelPm false" $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set SMBIOS:ProductName MacBookPro8,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_hdmi.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76d1.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_non_Intel_USB3.plist $@
	@printf "\n"

# 4x40s is IDT76d9, HD3000 or HD4000, HDMI
config/config_4x40.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76d9.plist $(PARTS)/config_HD3000-4000_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_hdmi.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76d9.plist $@
	@printf "\n"

# 4x0_G0 is IDT 76e0, HD4000, HDMI
config/config_4x0_G0.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76e0.plist $(PARTS)/config_HD3000-4000_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_hdmi.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76e0.plist $@
	@printf "\n"

# 4x0_G1_Ivy is same as 4x0_G0
config/config_4x0_G1_Ivy.plist: config/config_4x0_G0.plist
	@printf "!! creating $@\n"
	cp config/config_4x0_G0.plist $@
	@printf "\n"

# 8x0_G1_Ivy is IDT 76e0, HD4000, DP
config/config_8x0_G1_Ivy.plist: $(PARTS)/config_master.plist $(PARTS)/config_IDT76e0.plist $(PARTS)/config_HD3000-4000_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_dp.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76e0.plist $@
	@printf "\n"

# ZBook_G0 is same as 8x0_G1_Ivy
config/config_ZBook_G0.plist: config/config_8x0_G1_Ivy.plist
	@printf "!! creating $@\n"
	cp config/config_8x0_G1_Ivy.plist $@
	@printf "\n"

# 9x70m is IDT 76e0, HD4000, DP
config/config_9x70m.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76e0.plist $(PARTS)/config_HD3000-4000_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_dp.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76e0.plist $@
	@printf "\n"

# 9x80m is ALC280, HD4400, DP
config/config_9x80m.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC280.plist $(PARTS)/config_Haswell_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Haswell_dp.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC280.plist $@
	@printf "\n"

# 4x0_G1_Haswell is IDT 76e0, HD4400, HDMI
config/config_4x0_G1_Haswell.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76e0.plist $(PARTS)/config_Haswell_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Haswell_hdmi.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76e0.plist $@
	@printf "\n"

# 8x0_G1_Haswell is IDT 76e0, HD4400, DP
config/config_8x0_G1_Haswell.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76e0.plist $(PARTS)/config_Haswell_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Haswell_dp.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76e0.plist $@
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
config/config_6x60p.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT7605.plist $(PARTS)/config_HD3000-4000_dp.plist $(PARTS)/config_non_Intel_USB3.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:KernelPm false" $@
	/usr/libexec/PlistBuddy -c "Set SMBIOS:ProductName MacBookPro8,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_dp.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT7605.plist $@
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
config/config_5x30m.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT7605.plist $(PARTS)/config_HD3000-4000_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:KernelPm false" $@
	/usr/libexec/PlistBuddy -c "Set SMBIOS:ProductName MacBookPro8,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_hdmi.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT7605.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_non_Intel_USB3.plist $@
	@printf "\n"

# 6x70p is IDT7605, HD4000, DP
config/config_6x70p.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT7605.plist $(PARTS)/config_HD3000-4000_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_dp.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT7605.plist $@
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
config/config_3x0_G1.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT7695.plist $(PARTS)/config_HD3000-4000_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set ACPI:SSDT:Generate:PluginType false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_HD3000-4000_hdmi.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT7695.plist $@
	@printf "\n"

# 4x0_G2_Haswell is ALC282, Haswell, HDMI
config/config_4x0_G2_Haswell.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC282.plist $(PARTS)/config_Haswell_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Haswell_hdmi.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC282.plist $@
	@printf "\n"

# 8x0_G2_Haswell is ALC282, Haswell, DP
config/config_8x0_G2_Haswell.plist: $(PARTS)/config_master.plist $(PARTS)/config_ALC282.plist $(PARTS)/config_Haswell_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Haswell_dp.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC282.plist $@
	@printf "\n"

# 4x0_G2_Broadwell is ALC282, Broadwell, HDMI
config/config_4x0_G2_Broadwell.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC282.plist $(PARTS)/config_Broadwell_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir7,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Broadwell_hdmi.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC282.plist $@
	@printf "\n"

# 8x0_G2_Broadwell is ALC280, Broadwell, DP
config/config_8x0_G2_Broadwell.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC280.plist $(PARTS)/config_Broadwell_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir7,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Broadwell_dp.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC280.plist $@
	@printf "\n"

# 1020_G1_Broadwell is ALC286, Broadwell, HDMI
config/config_1020_G1_Broadwell.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC286.plist $(PARTS)/config_Broadwell_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir7,2" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Broadwell_hdmi.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC286.plist $@
	@printf "\n"

# ZBook_G2_Haswell is IDT 76e0, Haswell, no external ports for Intel graphics
# confirmed here: http://www.tonymacx86.com/el-capitan-laptop-guides/189416-guide-hp-probook-elitebook-zbook-using-clover-uefi-hotpatch-10-11-a-76.html#post1242529
config/config_ZBook_G2_Haswell.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76e0.plist $(PARTS)/config_Haswell_no_hdmi_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Haswell_no_hdmi_dp.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76e0.plist $@
	@printf "\n"

# ZBook_G1_Haswell is same as ZBook_G2_Haswell
config/config_ZBook_G1_Haswell.plist : config/config_ZBook_G2_Haswell.plist
	@printf "!! creating $@\n"
	cp config/config_ZBook_G2_Haswell.plist $@
	@printf "\n"

# ZBook_G2_Haswell_ALC280 is ALC280, Haswell, DP
config/config_ZBook_G2_Haswell_ALC280.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC280.plist $(PARTS)/config_Haswell_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Haswell_dp.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC280.plist $@
	@printf "\n"

# ZBook_G2_Broadwell is ALC280, Broadwell, DP
config/config_ZBook_G2_Broadwell.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC280.plist $(PARTS)/config_Broadwell_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Broadwell_dp.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC280.plist $@
	@printf "\n"

# ProBook_4x0_G3_Skylake is CX20724, Skylake, HDMI
config/config_4x0_G3_Skylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_CX20724.plist $(PARTS)/config_Skylake_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Skylake_hdmi.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_CX20724.plist $@
	@printf "\n"

# ProBook_8x0_G3_Skylake is CX20724, Skylake, DP
config/config_8x0_G3_Skylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_CX20724.plist $(PARTS)/config_Skylake_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Skylake_dp.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_CX20724.plist $@
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
config/config_6x0_G2_Skylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_CX20724.plist $(PARTS)/config_Skylake_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Skylake_dp.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_CX20724.plist $@
	@printf "\n"

# EliteBook 1040_G3_Skylake is CX20724, Skylake, DP
config/config_1040_G3_Skylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_CX20724.plist $(PARTS)/config_Skylake_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Skylake_dp.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_CX20724.plist $@
	@printf "\n"

#REVIEW: CX20724 is not correct for the 1050 (it uses a new audio codec)
# EliteBook 1050_G1_KabyLake-R is CX20724, KabyLake-R, DP
config/config_1050_G1_KabyLake-R.plist : $(PARTS)/config_master.plist $(PARTS)/config_CX20724.plist $(PARTS)/config_Kabylake_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Kabylake_dp.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_CX20724.plist $@
	@printf "\n"

# ProBook_4x0_G4_Kabylake is CX8200, Kabylake, HDMI
config/config_4x0_G4_Kabylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_CX20724.plist $(PARTS)/config_Kabylake_hdmi.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Kabylake_hdmi.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_CX8200.plist $@
	@printf "\n"

# ProBook_4x0_G5_Kabylake-R is same as 4x0_G4_Kabylake
config/config_4x0_G5_Kabylake-R.plist : config/config_4x0_G4_Kabylake.plist
	@printf "!! creating $@\n"
	cp config/config_4x0_G4_Kabylake.plist $@
	@printf "\n"

# EliteBook_8x0_G4_Kabylake is CX8200, Kabylake, DP
config/config_8x0_G4_Kabylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_CX20724.plist $(PARTS)/config_Kabylake_dp.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AppleIntelCPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "Devices:Properties" $(PARTS)/config_Kabylake_dp.plist $@
#	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_CX8200.plist $@
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
