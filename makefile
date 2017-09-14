# makefile

#
# Patches/Installs/Builds DSDT patches for HP ProBook/EliteBook/ZBook
#
# Created by RehabMan
#

BUILDDIR=./build
HDA=ProBook
RESOURCES=./Resources_$(HDA)
HDAINJECT=AppleHDA_$(HDA).kext
HDAHCDINJECT=AppleHDAHCD_$(HDA).kext
HDAZML=AppleHDA_$(HDA)_Resources

VERSION_ERA=$(shell ./print_version.sh)
ifeq "$(VERSION_ERA)" "10.10-"
	INSTDIR=/System/Library/Extensions
else
	INSTDIR=/Library/Extensions
endif
SLE=/System/Library/Extensions

HOTPATCH=./hotpatch
HACK=$(wildcard $(HOTPATCH)/*.dsl)
HACK:=$(subst $(HOTPATCH),$(BUILDDIR),$(HACK))
HACK:=$(subst .dsl,.aml,$(HACK))
HACK:=$(HACK) $(BUILDDIR)/SSDT-IGPU-HIRES.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-FAN-QUIET.aml $(BUILDDIR)/SSDT-FAN-MOD.aml $(BUILDDIR)/SSDT-FAN-SMOOTH.aml

# system specfic config.plist
PLIST:=config/config_4x30s.plist config/config_4x40s.plist \
	config/config_4x0s_G0.plist config/config_4x0s_G1_Ivy.plist config/config_ZBook_G0.plist \
	config/config_8x0s_G1_Ivy.plist config/config_9x70m.plist \
	config/config_9x80m.plist \
	config/config_2x60p.plist config/config_6x60p.plist config/config_8x60p.plist config/config_5x30m.plist \
	config/config_6x70p.plist config/config_8x70p.plist config/config_2x70p.plist \
	config/config_3x0_G1.plist \
	config/config_8x0s_G1_Haswell.plist config/config_4x0s_G1_Haswell.plist \
	config/config_4x0s_G2_Haswell.plist config/config_8x0s_G2_Haswell.plist \
	config/config_4x0s_G2_Broadwell.plist config/config_8x0s_G2_Broadwell.plist \
	config/config_1020_G1_Broadwell.plist \
	config/config_ZBook_G1_Haswell.plist config/config_ZBook_G2_Haswell.plist config/config_ZBook_G2_Broadwell.plist \
	config/config_ZBook_G3_Skylake.plist \
	config/config_4x0s_G3_Skylake.plist \
	config/config_8x0_G3_Skylake.plist \
	config/config_6x0_G2_Skylake.plist \
	config/config_1040_G1_Haswell.plist config/config_6x0s_G1_Haswell.plist \
	config/config_1040_G3_Skylake.plist \
	config/config_4x0s_G4_Kabylake.plist config/config_8x0_G4_Kabylake.plist

.PHONY: all
all : $(HACK) $(PLIST) $(HDAHCDINJECT) $(HDAINJECT)

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

$(HDAINJECT) $(HDAHCDINJECT) : $(RESOURCES)/*.plist ./patch_hda.sh
	./patch_hda.sh $(HDA)

.PHONY: clean_hda
clean_hda:
	rm -rf $(HDAINJECT) $(HDAHCDINJECT) $(HDAZML)

.PHONY: hda
hda: $(HDAINJECT) $(HDAHCDINJECT)

.PHONY: update_kernelcache
update_kernelcache:
	sudo touch $(SLE)
	sudo kextcache -update-volume /

# install_hdadummy must be used on <= 10.7.5
.PHONY: install_hdadummy
install_hdadummy:
	sudo rm -Rf $(INSTDIR)/$(HDAINJECT)
	sudo rm -Rf $(INSTDIR)/$(HDAHCDINJECT)
	sudo cp -R ./$(HDAINJECT) $(INSTDIR)
	if [ "`which tag`" != "" ]; then sudo tag -a Blue $(INSTDIR)/$(HDAINJECT); fi
	make update_kernelcache

# install_hda can be used only on >= 10.8
.PHONY: install_hda
install_hda:
	sudo rm -Rf $(INSTDIR)/$(HDAINJECT)
	sudo rm -Rf $(INSTDIR)/$(HDAHCDINJECT)
	#sudo cp -R ./$(HDAHCDINJECT) $(INSTDIR)
	#if [ "`which tag`" != "" ]; then sudo tag -a Blue $(INSTDIR)/$(HDAHCDINJECT); fi
	sudo cp $(HDAZML)/*.zml* $(SLE)/AppleHDA.kext/Contents/Resources
	if [ "`which tag`" != "" ]; then sudo tag -a Blue $(SLE)/AppleHDA.kext/Contents/Resources/*.zml*; fi
	make update_kernelcache

# dependencies for model specific SSDTs

$(BUILDDIR)/SSDT-4x30s.aml: $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout12_HDEF.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY102.asl $(HOTPATCH)/SSDT-USB-4x30s.asl $(HOTPATCH)/SSDT-EH01.asl $(HOTPATCH)/SSDT-EH02.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-4x40s.aml: $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout12_HDEF.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY102.asl $(HOTPATCH)/SSDT-USB-4x40s.asl $(HOTPATCH)/SSDT-EH01.asl $(HOTPATCH)/SSDT-EH02.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-5x30s.aml: $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout18_HDEF.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-EH01.asl $(HOTPATCH)/SSDT-EH02.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-2x60.aml: $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout18_HDEF.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY102.asl $(HOTPATCH)/SSDT-USB-6x60.asl $(HOTPATCH)/SSDT-EH01.asl $(HOTPATCH)/SSDT-EH02.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-6x60.aml: $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout18_HDEF.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-6x60.asl $(HOTPATCH)/SSDT-EH01.asl $(HOTPATCH)/SSDT-EH02.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-8x60.aml: $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout18_HDEF.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-8x60.asl $(HOTPATCH)/SSDT-EH01.asl $(HOTPATCH)/SSDT-EH02.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-2x70.aml: $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout18_HDEF.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-EH01.asl $(HOTPATCH)/SSDT-EH02.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-6x70.aml: $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout18_HDEF.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-6x70.asl $(HOTPATCH)/SSDT-EH01.asl $(HOTPATCH)/SSDT-EH02.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-8x70.aml: $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout18_HDEF.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-8x70.asl $(HOTPATCH)/SSDT-EH01.asl $(HOTPATCH)/SSDT-EH02.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-9x70.aml: $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout17_HDEF.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-9x70.asl $(HOTPATCH)/SSDT-EH01.asl $(HOTPATCH)/SSDT-EH02.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-9x80.aml: $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout4_HDEF.asl $(HOTPATCH)/include/layout4_HDAU.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-9x80.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-4x0-G0.aml: $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout17_HDEF.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-4x0-G0.asl $(HOTPATCH)/SSDT-EH01.asl $(HOTPATCH)/SSDT-EH02.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-3x0-G1.aml: $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout19_HDEF.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-EH01.asl $(HOTPATCH)/SSDT-EH02.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-4x0-G1-Ivy.aml: $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout17_HDEF.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-EH01.asl $(HOTPATCH)/SSDT-EH02.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-8x0-G1-Ivy.aml: $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout17_HDEF.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY102.asl $(HOTPATCH)/SSDT-EH01.asl $(HOTPATCH)/SSDT-EH02.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-4x0-G1-Haswell.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout17_HDEF.asl $(HOTPATCH)/include/layout17_HDAU.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-4x0-G1.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-6x0-G1-Haswell.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/include/ig_0d260007.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout17_HDEF.asl $(HOTPATCH)/include/layout17_HDAU.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-6x0-G1.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-8x0-G1-Haswell.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/include/ig_04260000.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout17_HDEF.asl $(HOTPATCH)/include/layout17_HDAU.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-8x0-G1.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT.asl $(HOTPATCH)/SSDT-RP05_DGFX_RDSS.asl

$(BUILDDIR)/SSDT-1040-G1-Haswell.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout17_HDEF.asl $(HOTPATCH)/include/layout17_HDAU.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY102.asl $(HOTPATCH)/SSDT-EH01.asl $(HOTPATCH)/SSDT-EH02.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-4x0-G2-Haswell.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout3_HDEF.asl $(HOTPATCH)/include/layout3_HDAU.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-4x0-G2.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT-G2.asl $(HOTPATCH)/SSDT-RP05_DGFX_RDSS.asl

$(BUILDDIR)/SSDT-4x0-G2-Haswell.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout3_HDEF.asl $(HOTPATCH)/include/layout3_HDAU.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-4x0-G2.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT-G2.asl $(HOTPATCH)/SSDT-RP05_DGFX_RDSS.asl

$(BUILDDIR)/SSDT-8x0-G2-Haswell.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout3_HDEF.asl $(HOTPATCH)/include/layout3_HDAU.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY102.asl $(HOTPATCH)/SSDT-USB-8x0-G2.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT-G2.asl $(HOTPATCH)/SSDT-RP05_DGFX_RDSS.asl

$(BUILDDIR)/SSDT-4x0-G2-Broadwell.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout3_HDEF.asl $(HOTPATCH)/include/layout3_HDAU.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-4x0-G2.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT-G2.asl $(HOTPATCH)/SSDT-RP05_DGFX_RDSS.asl

$(BUILDDIR)/SSDT-8x0-G2-Broadwell.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/include/xhc_pmee.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout4_HDEF.asl $(HOTPATCH)/include/layout4_HDAU.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-8x0-G2.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT-G2.asl $(HOTPATCH)/SSDT-RP05_DGFX_RDSS.asl

$(BUILDDIR)/SSDT-1020-G1-Broadwell.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout6_HDEF.asl $(HOTPATCH)/include/layout6_HDAU.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-1020-G1.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT-G2.asl $(HOTPATCH)/SSDT-RP05_DGFX_RDSS.asl

$(BUILDDIR)/SSDT-4x0-G3-Skylake.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/include/xhc_pmee.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout7_HDEF.asl $(HOTPATCH)/include/disable_HECI.asl $(HOTPATCH)/include/key86_PS2K.asl $(HOTPATCH)/SSDT-KEY102.asl $(HOTPATCH)/SSDT-USB-4x0-G3.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT-G4.asl $(HOTPATCH)/SSDT-RP01_PEGP_RDSS.asl $(HOTPATCH)/SSDT-USBX.asl

$(BUILDDIR)/SSDT-6x0-G2-Skylake.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/include/xhc_pmee.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout7_HDEF.asl $(HOTPATCH)/include/disable_HECI.asl $(HOTPATCH)/include/key86_PS2K.asl $(HOTPATCH)/SSDT-KEY102.asl $(HOTPATCH)/SSDT-USB-640-G2.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT-G2.asl $(HOTPATCH)/SSDT-RP05_PEGP_RDSS.asl $(HOTPATCH)/SSDT-USBX.asl

$(BUILDDIR)/SSDT-8x0-G3-Skylake.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/include/xhc_pmee.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout7_HDEF.asl $(HOTPATCH)/include/disable_HECI.asl $(HOTPATCH)/include/key86_PS2K.asl $(HOTPATCH)/SSDT-KEY102.asl $(HOTPATCH)/SSDT-USB-8x0-G3.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT-G4.asl $(HOTPATCH)/SSDT-RP05_PEGP_RDSS.asl $(HOTPATCH)/SSDT-USBX.asl

$(BUILDDIR)/SSDT-1040-G3-Skylake.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/include/xhc_pmee.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout7_HDEF.asl $(HOTPATCH)/include/disable_HECI.asl $(HOTPATCH)/include/key86_PS2K.asl $(HOTPATCH)/SSDT-KEY102.asl $(HOTPATCH)/SSDT-USB-1040-G3.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT-G4.asl $(HOTPATCH)/SSDT-USBX.asl

$(BUILDDIR)/SSDT-ZBook-G1-Haswell.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout17_HDEF.asl $(HOTPATCH)/include/layout17_HDAU.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-ZBook-G1.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT.asl

$(BUILDDIR)/SSDT-ZBook-G2-Haswell.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout17_HDEF.asl $(HOTPATCH)/include/layout17_HDAU.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-ZBook-G2.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT-G2.asl

$(BUILDDIR)/SSDT-ZBook-G2-Broadwell.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout4_HDEF.asl $(HOTPATCH)/include/layout4_HDAU.asl $(HOTPATCH)/include/standard_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-ZBook-G2.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT-G2.asl $(HOTPATCH)/SSDT-RP05_DGFX_RDSS.asl

$(BUILDDIR)/SSDT-ZBook-G3-Skylake.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/include/xhc_pmee.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout7_HDEF.asl $(HOTPATCH)/include/disable_HECI.asl $(HOTPATCH)/include/key86_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-ZBook-G3.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT-G4.asl $(HOTPATCH)/SSDT-RP01_PEGP_RDSS.asl $(HOTPATCH)/SSDT-USBX.asl

$(BUILDDIR)/SSDT-4x0-G4-Kabylake.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/include/xhc_pmee.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout20_HDEF.asl $(HOTPATCH)/include/disable_HECI.asl $(HOTPATCH)/include/key86_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-4x0-G4.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT-G4.asl $(HOTPATCH)/SSDT-RP01_PXSX_RDSS.asl $(HOTPATCH)/SSDT-USBX.asl

$(BUILDDIR)/SSDT-8x0-G4-Kabylake.aml: $(HOTPATCH)/SSDT-PluginType1.asl $(HOTPATCH)/SSDT-RMCF.asl $(HOTPATCH)/include/xhc_pmee.asl $(HOTPATCH)/SSDT-HACK.asl $(HOTPATCH)/include/layout20_HDEF.asl $(HOTPATCH)/include/disable_HECI.asl $(HOTPATCH)/include/key86_PS2K.asl $(HOTPATCH)/SSDT-KEY87.asl $(HOTPATCH)/SSDT-USB-8x0-G4.asl $(HOTPATCH)/SSDT-XHC.asl $(HOTPATCH)/SSDT-BATT-G4.asl $(HOTPATCH)/SSDT-RP01_PXSX_RDSS.asl $(HOTPATCH)/SSDT-USBX.asl

# generated config.plist files

PARTS=config_parts

# 4x30s is IDT76d1, HD3000, HDMI, non-Intel USB3
config/config_4x30s.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76d1.plist $(PARTS)/config_HD3000.plist $(PARTS)/config_HD3000_hdmi_audio.plist $(PARTS)/config_non_Intel_USB3.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:KernelPm false" $@
	/usr/libexec/PlistBuddy -c "Set SMBIOS:ProductName MacBookPro8,1" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD3000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD3000_hdmi_audio.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76d1.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_non_Intel_USB3.plist $@
	@printf "\n"

# 4x40s is IDT76d9, HD3000 or HD4000, HDMI
config/config_4x40s.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76d9.plist $(PARTS)/config_HD3000.plist $(PARTS)/config_HD3000_hdmi_audio.plist $(PARTS)/config_HD4000.plist $(PARTS)/config_HD4000_hdmi_audio.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD3000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD3000_hdmi_audio.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD4000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD4000_hdmi_audio.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76d9.plist $@
	@printf "\n"

# 4x0s_G0 is IDT 76e0, HD4000, HDMI
config/config_4x0s_G0.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76e0.plist $(PARTS)/config_HD4000.plist $(PARTS)/config_HD4000_hdmi_audio.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD4000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD4000_hdmi_audio.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76e0.plist $@
	@printf "\n"

# 4x0s_G1_Ivy is same as 4x0s_G0
config/config_4x0s_G1_Ivy.plist: config/config_4x0s_G0.plist
	@printf "!! creating $@\n"
	cp config/config_4x0s_G0.plist $@
	@printf "\n"

# 8x0s_G1_Ivy is IDT 76e0, HD4000, DP
config/config_8x0s_G1_Ivy.plist: $(PARTS)/config_master.plist $(PARTS)/config_IDT76e0.plist $(PARTS)/config_HD4000.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD4000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76e0.plist $@
	@printf "\n"

# ZBook_G0 is same as 8x0s_G1_Ivy
config/config_ZBook_G0.plist: config/config_8x0s_G1_Ivy.plist
	@printf "!! creating $@\n"
	cp config/config_8x0s_G1_Ivy.plist $@
	@printf "\n"

# 9x70m is IDT 76e0, HD4000, DP
config/config_9x70m.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76e0.plist $(PARTS)/config_HD4000.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD4000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76e0.plist $@
	@printf "\n"

# 9x80m is ALC280, HD4400, DP
config/config_9x80m.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC280.plist $(PARTS)/config_Haswell.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Haswell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC280.plist $@
	@printf "\n"

# 4x0s_G1_Haswell is IDT 76e0, HD4400, HDMI
config/config_4x0s_G1_Haswell.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76e0.plist $(PARTS)/config_Haswell.plist $(PARTS)/config_Haswell_hdmi_audio.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Haswell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Haswell_hdmi_audio.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76e0.plist $@
	@printf "\n"

# 8x0s_G1_Haswell is IDT 76e0, HD4400, DP
config/config_8x0s_G1_Haswell.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76e0.plist $(PARTS)/config_Haswell.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Haswell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76e0.plist $@
	@printf "\n"

# 6x0s_G1_Haswell is same as 8x0s_G1_Haswell
config/config_6x0s_G1_Haswell.plist : config/config_8x0s_G1_Haswell.plist
	@printf "!! creating $@\n"
	cp config/config_8x0s_G1_Haswell.plist $@
	@printf "\n"

# 1040_G1_Haswell is same as 8x0s_G1_Haswell
config/config_1040_G1_Haswell.plist : config/config_8x0s_G1_Haswell.plist
	@printf "!! creating $@\n"
	cp config/config_8x0s_G1_Haswell.plist $@
	@printf "\n"

# 6x60p is IDT7605, HD3000, non-Intel USB3, DP
config/config_6x60p.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT7605.plist $(PARTS)/config_HD3000.plist $(PARTS)/config_non_Intel_USB3.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:KernelPm false" $@
	/usr/libexec/PlistBuddy -c "Set SMBIOS:ProductName MacBookPro8,1" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD3000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT7605.plist $@
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
config/config_5x30m.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT7605.plist $(PARTS)/config_HD3000.plist $(PARTS)/config_HD3000_hdmi_audio.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:KernelPm false" $@
	/usr/libexec/PlistBuddy -c "Set SMBIOS:ProductName MacBookPro8,1" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD3000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD3000_hdmi_audio.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT7605.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_non_Intel_USB3.plist $@
	@printf "\n"

# 6x70p is IDT7605, HD4000, DP
config/config_6x70p.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT7605.plist $(PARTS)/config_HD4000.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD4000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT7605.plist $@
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
config/config_3x0_G1.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT7695.plist $(PARTS)/config_HD4000.plist $(PARTS)/config_HD4000_hdmi_audio.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD4000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD4000_hdmi_audio.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT7695.plist $@
	@printf "\n"

# 4x0s_G2_Haswell is ALC282, Haswell, HDMI
config/config_4x0s_G2_Haswell.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC282.plist $(PARTS)/config_Haswell.plist $(PARTS)/config_Haswell_hdmi_audio.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Haswell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Haswell_hdmi_audio.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC282.plist $@
	@printf "\n"

# 8x0s_G2_Haswell is ALC282, Haswell, DP
config/config_8x0s_G2_Haswell.plist: $(PARTS)/config_master.plist $(PARTS)/config_ALC282.plist $(PARTS)/config_Haswell.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Haswell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC282.plist $@
	@printf "\n"

# 4x0s_G2_Broadwell is ALC282, Broadwell, HDMI
config/config_4x0s_G2_Broadwell.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC282.plist $(PARTS)/config_Broadwell.plist $(PARTS)/config_Broadwell_hdmi_audio.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir7,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Broadwell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Broadwell_hdmi_audio.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC282.plist $@
	@printf "\n"

# 8x0s_G2_Broadwell is ALC280, Broadwell, DP
config/config_8x0s_G2_Broadwell.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC280.plist $(PARTS)/config_Broadwell.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir7,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Broadwell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC280.plist $@
	@printf "\n"

# 1020_G1_Broadwell is ALC286, Broadwell, HDMI
config/config_1020_G1_Broadwell.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC286.plist $(PARTS)/config_Broadwell.plist $(PARTS)/config_Broadwell_hdmi_audio.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookAir7,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Broadwell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Broadwell_hdmi_audio.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC286.plist $@
	@printf "\n"

# ZBook_G2_Haswell is IDT 76e0, Haswell, DP
# confirmed here: http://www.tonymacx86.com/el-capitan-laptop-guides/189416-guide-hp-probook-elitebook-zbook-using-clover-uefi-hotpatch-10-11-a-76.html#post1242529
config/config_ZBook_G2_Haswell.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76e0.plist $(PARTS)/config_Haswell.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Haswell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76e0.plist $@
	@printf "\n"

# ZBook_G1_Haswell is same as ZBook_G2_Haswell
config/config_ZBook_G1_Haswell.plist : config/config_ZBook_G2_Haswell.plist
	@printf "!! creating $@\n"
	cp config/config_ZBook_G2_Haswell.plist $@
	@printf "\n"

# ZBook_G2_Broadwell is ALC280, Broadwell, DP
config/config_ZBook_G2_Broadwell.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC280.plist $(PARTS)/config_Broadwell.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Broadwell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC280.plist $@
	@printf "\n"

# ProBook_4x0s_G3_Skylake is CX20724, Skylake, HDMI
config/config_4x0s_G3_Skylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_CX20724.plist $(PARTS)/config_Skylake.plist $(PARTS)/config_Skylake_hdmi_audio.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Skylake.plist $@
	./merge_plist.sh "KernelAndKextPatches:KernelToPatch" $(PARTS)/config_Skylake.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Skylake_hdmi_audio.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_CX20724.plist $@
	@printf "\n"

# ProBook_8x0s_G3_Skylake is CX20724, Skylake, DP
config/config_8x0_G3_Skylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_CX20724.plist $(PARTS)/config_Skylake.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Skylake.plist $@
	./merge_plist.sh "KernelAndKextPatches:KernelToPatch" $(PARTS)/config_Skylake.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_CX20724.plist $@
	@printf "\n"

# ZBook_G3_Skylake is same as 8x0_G3_Skylake
config/config_ZBook_G3_Skylake.plist : config/config_8x0_G3_Skylake.plist
	@printf "!! creating $@\n"
	cp config/config_8x0_G3_Skylake.plist $@
	@printf "\n"

# ProBook_6x0s_G2_Skylake is CX20724, Skylake, DP
config/config_6x0_G2_Skylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_CX20724.plist $(PARTS)/config_Skylake.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Skylake.plist $@
	./merge_plist.sh "KernelAndKextPatches:KernelToPatch" $(PARTS)/config_Skylake.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_CX20724.plist $@
	@printf "\n"

# EliteBook 1040_G3_Skylake is CX20724, Skylake, DP
config/config_1040_G3_Skylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_CX20724.plist $(PARTS)/config_Skylake.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Skylake.plist $@
	./merge_plist.sh "KernelAndKextPatches:KernelToPatch" $(PARTS)/config_Skylake.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_CX20724.plist $@
	@printf "\n"

# ProBook_4x0s_G4_Kabylake is CX8200, Kabylake (or spoofed Skylake), HDMI
config/config_4x0s_G4_Kabylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_CX20724.plist $(PARTS)/config_Skylake.plist $(PARTS)/config_Kabylake.plist $(PARTS)/config_Skylake_hdmi_audio.plist $(PARTS)/config_Kabylake_hdmi_audio.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "KernelAndKextPatches" $(PARTS)/config_Kabylake.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Skylake.plist $@
	./merge_plist.sh "KernelAndKextPatches:KernelToPatch" $(PARTS)/config_Skylake.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Skylake_hdmi_audio.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Kabylake_hdmi_audio.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_CX8200.plist $@
	@printf "\n"

# EliteBook_8x0_G4_Kabylake is CX8200, Kabylake (or spoofed Skylake), DP
config/config_8x0_G4_Kabylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_CX20724.plist $(PARTS)/config_Skylake.plist $(PARTS)/config_Kabylake.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/PlistBuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "KernelAndKextPatches" $(PARTS)/config_Kabylake.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Skylake.plist $@
	./merge_plist.sh "KernelAndKextPatches:KernelToPatch" $(PARTS)/config_Skylake.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_CX8200.plist $@
	@printf "\n"

# new hotpatch SSDTs

IASLOPTS=-vw 2095 -vw 2146 -vw 2089 -vr
# note: "-oe" is undocumented flag to turn off external opcode in iasl AML compilation result
# Snow Leopard cannot handle SSDTs with the external opcode, so Snow Leopard users must enable this flag
#IASLOPTS:=$(IASLOPTS) -oe

$(BUILDDIR)/%.aml : $(HOTPATCH)/%.dsl
	iasl $(IASLOPTS) -p $@ $<

$(BUILDDIR)/SSDT-IGPU-HIRES.aml : $(HOTPATCH)/SSDT-IGPU.dsl
	iasl -D HIRES $(IASLOPTS) -p $@ $<

$(BUILDDIR)/SSDT-FAN-QUIET.aml : $(HOTPATCH)/SSDT-FAN-QUIET.dsl
	iasl -D QUIET $(IASLOPTS) -p $@ $<

$(BUILDDIR)/SSDT-FAN-MOD.aml : $(HOTPATCH)/SSDT-FAN-QUIET.dsl
	iasl -D REHABMAN $(IASLOPTS) -p $@ $<

$(BUILDDIR)/SSDT-FAN-SMOOTH.aml : $(HOTPATCH)/SSDT-FAN-QUIET.dsl
	iasl -D GRAPPLER $(IASLOPTS) -p $@ $<


