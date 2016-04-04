# makefile

#
# Patches/Installs/Builds DSDT patches for HP ProBook
#
# Created by RehabMan
#

BUILDDIR=./build
HDA=ProBook
RESOURCES=./Resources_$(HDA)
HDAINJECT=AppleHDA_$(HDA).kext

VERSION_ERA=$(shell ./print_version.sh)
ifeq "$(VERSION_ERA)" "10.10-"
	INSTDIR=/System/Library/Extensions
else
	INSTDIR=/Library/Extensions
endif
SLE=/System/Library/Extensions

COMMON = patches/00_Optimize.txt patches/01_Compilation.txt patches/02_DSDTPatch.txt patches/05_OSCheck.txt patches/06_Battery.txt
FANPATCH = patches/04a_FanPatch.txt
QUIET = patches/04b_FanQuiet.txt
FANREAD = patches/04c_FanSpeed.txt
HDMI = patches/03a_HDMI.txt
HDMIDUAL = patches/03b_1080p+HDMI.txt
EHCI6 = patches/02a_EHCI_4x30s.txt
EHCI7 = patches/02b_EHCI_4x40s.txt
IMEI = patches/07_MEI_4x40s_Sandy.txt
AR9285 = patches/08_AR9285.txt
STATIC = patches/4x30s.txt patches/4x40s_IvyBridge.txt patches/4x40s_SandyBridge.txt
MINI = Mini-SSDT.aml Mini-SSDT-DualLink.aml Mini-SSDT-IMEI.aml Mini-SSDT-DisableGraphics.aml Mini-SSDT-AR9285.aml
#//REVIEW: stop building MINI for now
MINI=

HACK:=$(HACK) $(BUILDDIR)/SSDT-HACK.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-IGPU.aml $(BUILDDIR)/SSDT-IGPU-HIRES.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-BATT.aml $(BUILDDIR)/SSDT-BATT-G2.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-KEY87.aml $(BUILDDIR)/SSDT-KEY102.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-FAN-QUIET.aml $(BUILDDIR)/SSDT-FAN-MOD.aml $(BUILDDIR)/SSDT-FAN-SMOOTH.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-FAN-ORIG.aml $(BUILDDIR)/SSDT-FAN-READ.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-USB-4x0s-G2.aml $(BUILDDIR)/SSDT-USB-4x40s.aml $(BUILDDIR)/SSDT-USB-4x30s.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-USB-8x0s-G1.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-USB-820-G2.aml $(BUILDDIR)/SSDT-USB-840-G2.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-USB-6x70.aml

PLIST:=$(PLIST) config/config_4x30s.plist config/config_4x40s.plist
PLIST:=$(PLIST) config/config_4x0s_G0.plist config/config_4x0s_G1.plist
PLIST:=$(PLIST) config/config_8x0s_G1.plist config/config_9x70m.plist
PLIST:=$(PLIST) config/config_6x60s.plist config/config_6x70s.plist config/config_3x0_G1.plist
PLIST:=$(PLIST) config/config_8x0s_G1_Haswell.plist
PLIST:=$(PLIST) config/config_4x0s_G2_Haswell.plist config/config_8x0s_G2_Haswell.plist
PLIST:=$(PLIST) config/config_4x0s_G2_Broadwell.plist config/config_8x0s_G2_Broadwell.plist
PLIST:=$(PLIST) config/config_ZBook_G2_Haswell.plist

.PHONY: all
all : $(STATIC) $(MINI) $(HACK) $(PLIST) $(HDAINJECT)

.PHONY: clean
clean: 
	rm -f $(STATIC) $(HACK) $(MINI) $(PLIST)
	make clean_hda

$(HDAINJECT): $(RESOURCES)/*.plist ./patch_hda.sh
	./patch_hda.sh $(HDA)
	touch $@

.PHONY: clean_hda
clean_hda:
	rm -rf $(HDAINJECT)

.PHONY: hda
hda: $(HDAINJECT)

.PHONY: update_kernelcache
update_kernelcache:
	sudo touch $(SLE)
	sudo kextcache -update-volume /

.PHONY: install_hda
install_hda: $(HDAINJECT)
	sudo rm -Rf $(INSTDIR)/$(HDAINJECT)
	sudo cp -R ./$(HDAINJECT) $(INSTDIR)
	if [ "`which tag`" != "" ]; then sudo tag -a Blue $(INSTDIR)/$(HDAINJECT); fi
	make update_kernelcache

# generated config.plist files

# 4x30s is IDT76d1, HD3000, non-Intel USB3
config/config_4x30s.plist : config_master.plist config_IDT76d1.plist config_HD3000.plist config_non_Intel_USB3.plist
	@printf "!! creating $@\n"
	cp config_master.plist $@
	/usr/libexec/plistbuddy -c "Set KernelAndKextPatches:KernelPm false" $@
	/usr/libexec/plistbuddy -c "Set SMBIOS:ProductName MacBookPro8,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_HD3000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_IDT76d1.plist $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:0:CustomProperties:0:Value 12" $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:1:CustomProperties:0:Value 12" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_non_Intel_USB3.plist $@
	@printf "\n"

# 4x40s is IDT76d9, HD3000 or HD4000
config/config_4x40s.plist : config_master.plist config_IDT76d9.plist config_HD3000.plist config_HD4000.plist
	@printf "!! creating $@\n"
	cp config_master.plist $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_HD3000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_HD4000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_IDT76d9.plist $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:0:CustomProperties:0:Value 13" $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:1:CustomProperties:0:Value 13" $@
	@printf "\n"

# 4x0s_G0 (and ZBook) is IDT 76e0, HD4000
config/config_4x0s_G0.plist : config_master.plist config_IDT76e0.plist config_HD4000.plist
	@printf "!! creating $@\n"
	cp config_master.plist $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_HD4000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_IDT76e0.plist $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:0:CustomProperties:0:Value 14" $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:1:CustomProperties:0:Value 14" $@
	@printf "\n"

# 4x0s_G1 is same as 4x0s_G0
config/config_4x0s_G1.plist: config/config_4x0s_G0.plist
	@printf "!! creating $@\n"
	cp config/config_4x0s_G0.plist $@
	@printf "\n"

# 8x0s_G1 is same as 4x0s_G0
config/config_8x0s_G1.plist: config/config_4x0s_G0.plist
	@printf "!! creating $@\n"
	cp config/config_4x0s_G0.plist $@
	@printf "\n"

# 8x0s_G1_Haswell is IDT 76e0, HD4400
config/config_8x0s_G1_Haswell.plist : config_master.plist config_IDT76e0.plist config_Haswell.plist
	@printf "!! creating $@\n"
	cp config_master.plist $@
	/usr/libexec/plistbuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_Haswell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_IDT76e0.plist $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:0:CustomProperties:0:Value 17" $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:1:CustomProperties:0:Value 17" $@
	@printf "\n"

# 9x70m is same as 4x0s_G0
config/config_9x70m.plist: config/config_4x0s_G0.plist
	@printf "!! creating $@\n"
	cp config/config_4x0s_G0.plist $@
	@printf "\n"

# 6x60s is IDT7605, HD3000, non-Intel USB3
config/config_6x60s.plist : config_master.plist config_IDT7605.plist config_HD3000.plist config_non_Intel_USB3.plist
	@printf "!! creating $@\n"
	cp config_master.plist $@
	/usr/libexec/plistbuddy -c "Set KernelAndKextPatches:KernelPm false" $@
	/usr/libexec/plistbuddy -c "Set SMBIOS:ProductName MacBookPro8,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_HD3000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_IDT7605.plist $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:0:CustomProperties:0:Value 18" $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:1:CustomProperties:0:Value 18" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_non_Intel_USB3.plist $@
	@printf "\n"

# 6x70s is IDT7605, HD4000
config/config_6x70s.plist : config_master.plist config_IDT7605.plist config_HD4000.plist
	@printf "!! creating $@\n"
	cp config_master.plist $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_HD4000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_IDT7605.plist $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:0:CustomProperties:0:Value 18" $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:1:CustomProperties:0:Value 18" $@
	@printf "\n"

# 3x0_G1 is IDT7695, HD4000 (//review)
config/config_3x0_G1.plist : config_master.plist config_IDT7695.plist config_HD4000.plist
	@printf "!! creating $@\n"
	cp config_master.plist $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_HD4000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_IDT7695.plist $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:0:CustomProperties:0:Value 19" $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:1:CustomProperties:0:Value 19" $@
	@printf "\n"

# 4x0s_G2_Haswell is ALC282, Haswell
config/config_4x0s_G2_Haswell.plist : config_master.plist config_ALC282.plist config_Haswell.plist
	@printf "!! creating $@\n"
	cp config_master.plist $@
	/usr/libexec/plistbuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_Haswell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_ALC282.plist $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:0:CustomProperties:0:Value 3" $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:1:CustomProperties:0:Value 3" $@
	@printf "\n"

# 8x0s_G2_Haswell is same as 4x0s_G2_Haswell
config/config_8x0s_G2_Haswell.plist: config/config_4x0s_G2_Haswell.plist
	@printf "!! creating $@\n"
	cp config/config_4x0s_G2_Haswell.plist $@
	@printf "\n"

# 4x0s_G2_Broadwell is ALC282, Broadwell
config/config_4x0s_G2_Broadwell.plist : config_master.plist config_ALC282.plist config_Broadwell.plist
	@printf "!! creating $@\n"
	cp config_master.plist $@
	/usr/libexec/plistbuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookAir7,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_Broadwell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_ALC282.plist $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:0:CustomProperties:0:Value 3" $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:1:CustomProperties:0:Value 3" $@
	@printf "\n"

# 8x0s_G2_Broadwell is ALC280, Broadwell
config/config_8x0s_G2_Broadwell.plist : config_master.plist config_ALC280.plist config_Broadwell.plist
	@printf "!! creating $@\n"
	cp config_master.plist $@
	/usr/libexec/plistbuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookAir7,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_Broadwell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_ALC280.plist $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:0:CustomProperties:0:Value 4" $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:1:CustomProperties:0:Value 4" $@
	@printf "\n"

# ZBook_G2_Haswell is ALC280, Haswell
config/config_ZBook_G2_Haswell.plist : config_master.plist config_ALC280.plist config_Haswell.plist
	@printf "!! creating $@\n"
	cp config_master.plist $@
	/usr/libexec/plistbuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_Haswell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_ALC280.plist $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:0:CustomProperties:0:Value 4" $@
	/usr/libexec/plistbuddy -c "Set Devices:Arbitrary:1:CustomProperties:0:Value 4" $@
	@printf "\n"

# combo patches

patches/4x30s.txt : $(COMMON) $(EHCI6)
	cat $^ >$@ 

patches/4x40s_IvyBridge.txt : $(COMMON) $(EHCI7)
	cat $^ >$@ 

patches/4x40s_SandyBridge.txt : $(COMMON) $(EHCI7) $(IMEI)
	cat $^ >$@ 

# mini SSDTs

%.aml : mini/%.dsl
	iasl -p $@ $<

# new hotpatch SSDTs

IASLOPTS=-vw 2095 -vw 2146 -vw 2089

$(BUILDDIR)/%.aml : %.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-IGPU-HIRES.aml : SSDT-IGPU.dsl
	iasl -D HIRES $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-FAN-QUIET.aml : SSDT-FAN-QUIET.dsl
	iasl -D QUIET $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-FAN-MOD.aml : SSDT-FAN-QUIET.dsl
	iasl -D REHABMAN $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-FAN-SMOOTH.aml : SSDT-FAN-QUIET.dsl
	iasl -D GRAPPLER $(IASLOPTS) -p $@ $^

