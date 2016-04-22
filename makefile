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

MINIDIR=./mini/build

ifeq "$(FANPREF)" ""
FANPREF=READ
endif

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
MINI = $(MINIDIR)/Mini-SSDT.aml $(MINIDIR)/Mini-SSDT-DualLink.aml $(MINIDIR)/Mini-SSDT-IMEI.aml $(MINIDIR)/Mini-SSDT-$(MINIDIR)/DisableGraphics.aml $(MINIDIR)/Mini-SSDT-AR9285.aml
#//REVIEW: stop building MINI for now
MINI=

# core files
HACK:=$(HACK) $(BUILDDIR)/SSDT-HACK.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-USB.aml
# core files (from hotpatch in laptop Clover guide/repo)
HACK:=$(HACK) $(BUILDDIR)/SSDT-XOSI.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-LPC.aml $(BUILDDIR)/SSDT-SATA.aml $(BUILDDIR)/SSDT-SMBUS.aml $(BUILDDIR)/SSDT-PNLF.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-PRW.aml $(BUILDDIR)/SSDT-LANC_PRW.aml
CORE:=$(HACK)

# depends on hardware
HACK:=$(HACK) $(BUILDDIR)/SSDT-IGPU.aml $(BUILDDIR)/SSDT-IGPU-HIRES.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-BATT.aml $(BUILDDIR)/SSDT-BATT-G2.aml $(BUILDDIR)/SSDT-BATT-G3.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-KEY87.aml $(BUILDDIR)/SSDT-KEY102.aml
# depends on hardware (USB optimization)
HACK:=$(HACK) $(BUILDDIR)/SSDT-USB-4x0-G2.aml $(BUILDDIR)/SSDT-USB-4x40s.aml $(BUILDDIR)/SSDT-USB-4x30s.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-USB-8x0-G1.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-USB-820-G2.aml $(BUILDDIR)/SSDT-USB-840-G2.aml $(BUILDDIR)/SSDT-USB-850-G2.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-USB-6x60.aml $(BUILDDIR)/SSDT-USB-6x70.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-USB-8x60.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-USB-4x0-G3.aml

# depends on personal choices
HACK:=$(HACK) $(BUILDDIR)/SSDT-FAN-QUIET.aml $(BUILDDIR)/SSDT-FAN-MOD.aml $(BUILDDIR)/SSDT-FAN-SMOOTH.aml $(BUILDDIR)/SSDT-FAN-ORIG.aml $(BUILDDIR)/SSDT-FAN-READ.aml

# system specific SSDTs
HACK:=$(HACK) $(BUILDDIR)/SSDT-4x30s.aml $(BUILDDIR)/SSDT-4x40s.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-6x60.aml $(BUILDDIR)/SSDT-8x60.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-2x70.aml $(BUILDDIR)/SSDT-6x70.aml $(BUILDDIR)/SSDT-8x70.aml $(BUILDDIR)/SSDT-9x70.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-1040-G1-Haswell.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-3x0-G1.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-4x0-G0.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-4x0-G1-Ivy.aml $(BUILDDIR)/SSDT-8x0-G1-Ivy.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-4x0-G1-Haswell.aml $(BUILDDIR)/SSDT-8x0-G1-Haswell.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-4x0-G2-Haswell.aml $(BUILDDIR)/SSDT-8x0-G2-Haswell.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-4x0-G2-Broadwell.aml $(BUILDDIR)/SSDT-8x0-G2-Broadwell.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-ZBook-G2-Haswell.aml $(BUILDDIR)/SSDT-ZBook-G2-Broadwell.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-4x0-G3-Skylake.aml

# system specfic config.plist
PLIST:=$(PLIST) config/config_4x30s.plist config/config_4x40s.plist
PLIST:=$(PLIST) config/config_4x0s_G0.plist config/config_4x0s_G1_Ivy.plist
PLIST:=$(PLIST) config/config_8x0s_G1_Ivy.plist config/config_9x70m.plist
PLIST:=$(PLIST) config/config_6x60p.plist config/config_8x60p.plist config/config_6x70p.plist config/config_8x70p.plist
PLIST:=$(PLIST) config/config_2x70p.plist
PLIST:=$(PLIST) config/config_3x0_G1.plist
PLIST:=$(PLIST) config/config_8x0s_G1_Haswell.plist config/config_4x0s_G1_Haswell.plist
PLIST:=$(PLIST) config/config_4x0s_G2_Haswell.plist config/config_8x0s_G2_Haswell.plist
PLIST:=$(PLIST) config/config_4x0s_G2_Broadwell.plist config/config_8x0s_G2_Broadwell.plist
PLIST:=$(PLIST) config/config_ZBook_G2_Haswell.plist config/config_ZBook_G2_Broadwell.plist
PLIST:=$(PLIST) config/config_4x0s_G3_Skylake.plist
PLIST:=$(PLIST) config/config_1040_G1_Haswell.plist

.PHONY: all
all : $(STATIC) $(MINI) $(HACK) $(PLIST) $(HDAINJECT) $(HDAHCDINJECT)

.PHONY: clean
clean: 
	rm -f $(STATIC) $(HACK) $(MINI) $(PLIST)
	make clean_hda

.PHONY: install_help # lists all the 'install' targets
install_help:
	@grep PHONY.*install makefile | grep -v grep

# install core SSDTs
.PHONY: install # installs 'core' SSDTs (low resolution)
install:
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	rm -f $(EFIDIR)/EFI/CLOVER/ACPI/patched/SSDT-*.aml
	cp $(CORE) $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-IGPU.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-BATT.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-FAN-$(FANPREF).aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_hires # installs 'core' SSDTs (high resolution)
install_hires:
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	rm -f $(EFIDIR)/EFI/CLOVER/ACPI/patched/SSDT-*.aml
	cp $(CORE) $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-IGPU-HIRES.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-BATT.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-FAN-$(FANPREF).aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_batt_g2
install_batt_g2:
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	rm -f $(EFIDIR)/EFI/CLOVER/ACPI/patched/SSDT-BATT*.aml
	cp $(BUILDDIR)/SSDT-BATT-G2.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_batt_g3
install_batt_g3:
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	rm -f $(EFIDIR)/EFI/CLOVER/ACPI/patched/SSDT-BATT*.aml
	cp $(BUILDDIR)/SSDT-BATT-G3.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

# system specfic SSDT installs
.PHONY: install_4x30s
install_4x30s:
	make install
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-4x30s.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-4x30s.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_4x30s_hires
install_4x30s_hires:
	make install_hires
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-4x30s.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-4x30s.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_4x40s
install_4x40s:
	make install
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-4x40s.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-4x40s.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_4x40s_hires
install_4x40s_hires:
	make install_hires
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-4x40s.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-4x40s.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_6x60
install_6x60:
	make install
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-6x60.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY87.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-6x60.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_6x60_hires
install_6x60_hires:
	make install_hires
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-6x60.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY87.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-6x60.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_8x60
install_8x60:
	make install
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-8x60.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY87.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-8x60.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_8x60_hires
install_8x60_hires:
	make install_hires
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-8x60.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY87.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-8x60.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_2x70
install_2x70:
	make install
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-2x70.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY87.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-2x70.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_2x70_hires
install_2x70_hires:
	make install_hires
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-2x70.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY87.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-2x70.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_6x70
install_6x70:
	make install
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-6x70.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY87.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-6x70.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_6x70_hires
install_6x70_hires:
	make install_hires
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-6x70.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY87.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-6x70.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_8x70
install_8x70:
	make install
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-8x70.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY87.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-8x70.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_6x70_hires
install_8x70_hires:
	make install_hires
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-8x70.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY87.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-8x70.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_9x70
install_9x70:
	make install
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-9x70.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY87.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-9x70.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_9x70_hires
install_9x60_hires:
	make install_hires
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-9x70.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY87.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-9x70.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_4x0g0
install_4x0g0:
	make install
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-4x0-G0.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY87.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-4x0-G0.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_4x0g0_hires
install_4x0g0_hires:
	make install_hires
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-4x0-G0.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-4x0-G0.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_3x0g1
install_3x0g1:
	make install
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-3x0-G1.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-3x0-G1.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_3x0g1_hires
install_3x0g1_hires:
	make install_hires
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-3x0-G1.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-3x0-G1.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_4x0g1_ivy
install_4x0g1_ivy:
	make install
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-4x0-G1-Ivy.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-4x0-G1-Ivy.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_4x0g1_ivy_hires
install_4x0g1_ivy_hires:
	make install_hires
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-4x0-G1-Ivy.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-4x0-G1-Ivy.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_8x0g1_ivy
install_8x0g1_ivy:
	make install
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-8x0-G1-Ivy.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-8x0-G1.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_8x0g1_ivy_hires
install_8x0g1_ivy_hires:
	make install_hires
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-8x0-G1-Ivy.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-8x0-G1.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_4x0g1_haswell
install_4x0g1_haswell:
	make install
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-4x0-G1-Haswell.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-4x0-G1.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_8x0g1_haswell
install_8x0g1_haswell:
	make install
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-8x0-G1-Haswell.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-8x0s-G1.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_1040g1_haswell
install_1040g1_haswell:
	make install
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-1040-G1-Haswell.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-1040-G1.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_4x0g2_haswell
install_4x0g2_haswell:
	make install
	make install_batt_g2
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-4x0-G2-Haswell.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-4x0-G2.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_8x0g2_haswell
install_8x0g2_haswell:
	make install
	make install_batt_g2
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-8x0-G2-Haswell.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-8x0s-G2.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_4x0g2_broadwell
install_4x0g2_broadwell:
	make install
	make install_batt_g2
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-4x0-G2-Broadwell.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-4x0-G2.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_820g2_broadwell
install_820g2_broadwell:
	make install
	make install_batt_g2
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-8x0-G2-Broadwell.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-820-G2.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_840g2_broadwell
install_840g2_broadwell:
	make install
	make install_batt_g2
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-8x0-G2-Broadwell.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-840-G2.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_850g2_broadwell
install_850g2_broadwell:
	make install
	make install_batt_g2
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-8x0-G2-Broadwell.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-850-G2.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_ZBook_G2_haswell
install_ZBook_G2_haswell:
	make install
	make install_batt_g2
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-ZBook-G2-Haswell.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-ZBook-G2.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_ZBook_G2_broadwell
install_ZBook_G2_broadwell:
	make install
	make install_batt_g2
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-ZBook-G2-Broadwell.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
#	cp $(BUILDDIR)/SSDT-USB-ZBook-G2.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

.PHONY: install_4x0g3_skylake
install_4x0g3_skylake:
	make install
	make install_batt_g3
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-4x0-G3-Skylake.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-KEY102.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/SSDT-USB-4x0-G3.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched

$(HDAINJECT) $(HDAHCDINJECT): $(RESOURCES)/*.plist ./patch_hda.sh
	./patch_hda.sh $(HDA)
	touch $@

.PHONY: clean_hda
clean_hda:
	rm -rf $(HDAINJECT) $(HDAHCDINJECT) $(HDAZML)

.PHONY: hda
hda: $(HDAINJECT) $(HDAHCDINJECT)

.PHONY: update_kernelcache
update_kernelcache:
	sudo touch $(SLE)
	sudo kextcache -update-volume /

.PHONY: install_dummy
install_hdadummy:
	sudo rm -Rf $(INSTDIR)/$(HDAINJECT)
	sudo rm -Rf $(INSTDIR)/$(HDAHCDINJECT)
	sudo cp -R ./$(HDAINJECT) $(INSTDIR)
	if [ "`which tag`" != "" ]; then sudo tag -a Blue $(INSTDIR)/$(HDAINJECT); fi
	make update_kernelcache

.PHONY: install_hda
install_hda:
	sudo rm -Rf $(INSTDIR)/$(HDAINJECT)
	sudo rm -Rf $(INSTDIR)/$(HDAHCDINJECT)
	sudo cp -R ./$(HDAHCDINJECT) $(INSTDIR)
	if [ "`which tag`" != "" ]; then sudo tag -a Blue $(INSTDIR)/$(HDAHCDINJECT); fi
	sudo cp $(HDAZML)/*.zml* $(SLE)/AppleHDA.kext/Contents/Resources
	if [ "`which tag`" != "" ]; then sudo tag -a Blue $(SLE)/AppleHDA.kext/Contents/Resources/*.zml*; fi
	make update_kernelcache

# generated config.plist files

PARTS=config_parts

# 4x30s is IDT76d1, HD3000, non-Intel USB3
config/config_4x30s.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76d1.plist $(PARTS)/config_HD3000.plist $(PARTS)/config_non_Intel_USB3.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/plistbuddy -c "Set KernelAndKextPatches:KernelPm false" $@
	/usr/libexec/plistbuddy -c "Set SMBIOS:ProductName MacBookPro8,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD3000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76d1.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_non_Intel_USB3.plist $@
	@printf "\n"

# 4x40s is IDT76d9, HD3000 or HD4000
config/config_4x40s.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76d9.plist $(PARTS)/config_HD3000.plist $(PARTS)/config_HD4000.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD3000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD4000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76d9.plist $@
	@printf "\n"

# 4x0s_G0 (and ZBook) is IDT 76e0, HD4000
config/config_4x0s_G0.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76e0.plist $(PARTS)/config_HD4000.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD4000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76e0.plist $@
	@printf "\n"

# 4x0s_G1_Ivy is same as 4x0s_G0
config/config_4x0s_G1_Ivy.plist: config/config_4x0s_G0.plist
	@printf "!! creating $@\n"
	cp config/config_4x0s_G0.plist $@
	@printf "\n"

# 8x0s_G1_Ivy is same as 4x0s_G0
config/config_8x0s_G1_Ivy.plist: config/config_4x0s_G0.plist
	@printf "!! creating $@\n"
	cp config/config_4x0s_G0.plist $@
	@printf "\n"

# 8x0s_G1_Haswell is IDT 76e0, HD4400
config/config_8x0s_G1_Haswell.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT76e0.plist $(PARTS)/config_Haswell.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/plistbuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Haswell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT76e0.plist $@
	@printf "\n"

# 4x0s_G1_Haswell is same as 8x0s_G1_Haswell
config/config_4x0s_G1_Haswell.plist : config/config_8x0s_G1_Haswell.plist
	@printf "!! creating $@\n"
	cp config/config_8x0s_G1_Haswell.plist $@
	@printf "\n"

# 1040_G1_Haswell is same as 8x0s_G1_Haswell
config/config_1040_G1_Haswell.plist : config/config_8x0s_G1_Haswell.plist
	@printf "!! creating $@\n"
	cp config/config_8x0s_G1_Haswell.plist $@
	@printf "\n"

# 9x70m is same as 4x0s_G0
config/config_9x70m.plist : config/config_4x0s_G0.plist
	@printf "!! creating $@\n"
	cp config/config_4x0s_G0.plist $@
	@printf "\n"

# 6x60p is IDT7605, HD3000, non-Intel USB3
config/config_6x60p.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT7605.plist $(PARTS)/config_HD3000.plist $(PARTS)/config_non_Intel_USB3.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/plistbuddy -c "Set KernelAndKextPatches:KernelPm false" $@
	/usr/libexec/plistbuddy -c "Set SMBIOS:ProductName MacBookPro8,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD3000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT7605.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_non_Intel_USB3.plist $@
	@printf "\n"

# 8x60p is same as 6x60p
config/config_8x60p.plist : config/config_6x60p.plist
	@printf "!! creating $@\n"
	cp config/config_6x60p.plist $@
	@printf "\n"

# 6x70p is IDT7605, HD4000
config/config_6x70p.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT7605.plist $(PARTS)/config_HD4000.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
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

# 3x0_G1 is IDT7695, HD4000 (//review)
config/config_3x0_G1.plist : $(PARTS)/config_master.plist $(PARTS)/config_IDT7695.plist $(PARTS)/config_HD4000.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookPro9,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_HD4000.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_IDT7695.plist $@
	@printf "\n"

# 4x0s_G2_Haswell is ALC282, Haswell
config/config_4x0s_G2_Haswell.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC282.plist $(PARTS)/config_Haswell.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/plistbuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookAir6,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Haswell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC282.plist $@
	@printf "\n"

# 8x0s_G2_Haswell is same as 4x0s_G2_Haswell
config/config_8x0s_G2_Haswell.plist: config/config_4x0s_G2_Haswell.plist
	@printf "!! creating $@\n"
	cp config/config_4x0s_G2_Haswell.plist $@
	@printf "\n"

# 4x0s_G2_Broadwell is ALC282, Broadwell
config/config_4x0s_G2_Broadwell.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC282.plist $(PARTS)/config_Broadwell.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/plistbuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookAir7,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Broadwell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC282.plist $@
	@printf "\n"

# 8x0s_G2_Broadwell is ALC280, Broadwell
config/config_8x0s_G2_Broadwell.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC280.plist $(PARTS)/config_Broadwell.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/plistbuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookAir7,2" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Broadwell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC280.plist $@
	@printf "\n"

# ZBook_G2_Haswell is ALC280, Haswell
config/config_ZBook_G2_Haswell.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC280.plist $(PARTS)/config_Haswell.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/plistbuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Haswell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC280.plist $@
	@printf "\n"

# ZBook_G2_Broadwell is ALC280, Broadwell
config/config_ZBook_G2_Broadwell.plist : $(PARTS)/config_master.plist $(PARTS)/config_ALC280.plist $(PARTS)/config_Broadwell.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/plistbuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Broadwell.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_ALC280.plist $@
	@printf "\n"

# ProBook_4x0s_G3_Skylake is CX20724, Skylake
config/config_4x0s_G3_Skylake.plist : $(PARTS)/config_master.plist $(PARTS)/config_CX20724.plist $(PARTS)/config_Skylake.plist
	@printf "!! creating $@\n"
	cp $(PARTS)/config_master.plist $@
	/usr/libexec/plistbuddy -c "Set KernelAndKextPatches:AsusAICPUPM false" $@
	/usr/libexec/plistbuddy -c "Set :SMBIOS:ProductName MacBookPro11,1" $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_Skylake.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" $(PARTS)/config_CX20724.plist $@
	@printf "\n"

# combo patches

patches/4x30s.txt : $(COMMON) $(EHCI6)
	cat $^ >$@ 

patches/4x40s_IvyBridge.txt : $(COMMON) $(EHCI7)
	cat $^ >$@ 

patches/4x40s_SandyBridge.txt : $(COMMON) $(EHCI7) $(IMEI)
	cat $^ >$@ 

# mini SSDTs

$(MINIDIR)/%.aml : mini/%.dsl
	iasl -p $@ $<

# new hotpatch SSDTs

IASLOPTS=-vw 2095 -vw 2146 -vw 2089

$(BUILDDIR)/%.aml : hotpatch/%.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-IGPU-HIRES.aml : hotpatch/SSDT-IGPU.dsl
	iasl -D HIRES $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-FAN-QUIET.aml : hotpatch/SSDT-FAN-QUIET.dsl
	iasl -D QUIET $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-FAN-MOD.aml : hotpatch/SSDT-FAN-QUIET.dsl
	iasl -D REHABMAN $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-FAN-SMOOTH.aml : hotpatch/SSDT-FAN-QUIET.dsl
	iasl -D GRAPPLER $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-USB-850-G2.aml : hotpatch/SSDT-USB-820-G2.dsl
	iasl $(IASLOPTS) -p $@ $^
