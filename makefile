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
ALL = patches/4x30s.txt patches/4x40s_IvyBridge.txt patches/4x40s_SandyBridge.txt
MINI = Mini-SSDT.aml Mini-SSDT-DualLink.aml Mini-SSDT-IMEI.aml Mini-SSDT-DisableGraphics.aml Mini-SSDT-AR9285.aml

BUILDDIR=./build

MINI:=$(MINI) $(BUILDDIR)/SSDT-HACK.aml
MINI:=$(MINI) $(BUILDDIR)/SSDT-IGPU.aml $(BUILDDIR)/SSDT-IGPU-HIRES.aml
MINI:=$(MINI) $(BUILDDIR)/SSDT-BATT.aml $(BUILDDIR)/SSDT-BATT-G2.aml
MINI:=$(MINI) $(BUILDDIR)/SSDT-KEY87.aml $(BUILDDIR)/SSDT-KEY102.aml
MINI:=$(MINI) $(BUILDDIR)/SSDT-FAN-QUIET.aml $(BUILDDIR)/SSDT-FAN-MOD.aml $(BUILDDIR)/SSDT-FAN-SMOOTH.aml
MINI:=$(MINI) $(BUILDDIR)/SSDT-FAN-ORIG.aml $(BUILDDIR)/SSDT-FAN-READ.aml

PLIST:=config_4x0s_Gx.plist config_4x30s.plist config_4x40s.plist

.PHONY: all
all : $(ALL) $(MINI) $(PLIST)

.PHONY: clean
clean: 
	rm $(ALL) $(MINI) $(PLIST)

# generated config.plist files

config_4x0s_Gx.plist : config_master.plist config_ALC282.plist
	cp config_master.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_ALC282.plist $@

config_4x30s.plist : config_master.plist config_IDT76d1.plist config_non_Intel_USB3.plist
	cp config_master.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_IDT76d1.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_non_Intel_USB3.plist $@

config_4x40s.plist : config_master.plist config_IDT76d9.plist
	cp config_master.plist $@
	./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_IDT76d9.plist $@

# combo patches

patches/4x30s.txt : $(COMMON) $(EHCI6)
	cat $^ >$@ 

patches/4x40s_IvyBridge.txt : $(COMMON) $(EHCI7)
	cat $^ >$@ 

patches/4x40s_SandyBridge.txt : $(COMMON) $(EHCI7) $(IMEI)
	cat $^ >$@ 

# mini SSDTs

Mini-SSDT.aml : mini/Mini-SSDT.dsl
	iasl -p $@ $^

Mini-SSDT-DualLink.aml : mini/Mini-SSDT-DualLink.dsl
	iasl -p $@ $^

Mini-SSDT-IMEI.aml : mini/Mini-SSDT-IMEI.dsl
	iasl -p $@ $^

Mini-SSDT-DisableGraphics.aml : mini/Mini-SSDT-DisableGraphics.dsl
	iasl -p $@ $^

Mini-SSDT-AR9285.aml : mini/Mini-SSDT-AR9285.dsl
	iasl -p $@ $^

# new SSDT-HACK

$(BUILDDIR)/SSDT-HACK.aml : SSDT-HACK.dsl
	iasl -p $@ $^

$(BUILDDIR)/SSDT-IGPU.aml : SSDT-IGPU.dsl
	iasl -vw 2095 -p $@ $^

$(BUILDDIR)/SSDT-IGPU-HIRES.aml : SSDT-IGPU.dsl
	iasl -D HIRES -vw 2095 -p $@ $^

$(BUILDDIR)/SSDT-BATT.aml : SSDT-BATT.dsl
	iasl -vw 2146 -vw 2089 -p $@ $^

$(BUILDDIR)/SSDT-BATT-G2.aml : SSDT-BATT-G2.dsl
	iasl -vw 2146 -vw 2089 -p $@ $^

$(BUILDDIR)/SSDT-KEY87.aml : SSDT-KEY87.dsl
	iasl -p $@ $^

$(BUILDDIR)/SSDT-KEY102.aml : SSDT-KEY102.dsl
	iasl -p $@ $^

$(BUILDDIR)/SSDT-FAN-QUIET.aml : SSDT-FAN-QUIET.dsl
	iasl -D QUIET -p $@ $^

$(BUILDDIR)/SSDT-FAN-MOD.aml : SSDT-FAN-QUIET.dsl
	iasl -D REHABMAN -p $@ $^

$(BUILDDIR)/SSDT-FAN-SMOOTH.aml : SSDT-FAN-QUIET.dsl
	iasl -D GRAPPLER -p $@ $^

$(BUILDDIR)/SSDT-FAN-ORIG.aml : SSDT-FAN-ORIG.dsl
	iasl -p $@ $^

$(BUILDDIR)/SSDT-FAN-READ.aml : SSDT-FAN-READ.dsl
	iasl -p $@ $^

