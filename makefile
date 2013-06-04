COMMON = 00_Optimize.txt 01_Compilation.txt 02_DSDTPatch.txt 05_OSCheck.txt 06_Battery.txt
FANPATCH = 04a_FanPatch.txt
QUIET = 04b_FanQuiet.txt
FANREAD = 04c_FanSpeed.txt
HDMI = 03a_HDMI.txt
HDMIDUAL = 03b_1080p+HDMI.txt
EHCI6 = 02a_EHCI_4x30s.txt
EHCI7 = 02b_EHCI_4x40s.txt
IMEI = 07_MEI_4x40s_Sandy.txt
AR9285 = 08_AR9285.txt
ALL = 4x30s.txt 4x40s_IvyBridge.txt 4x40s_SandyBridge.txt
MINI = Mini-SSDT.aml Mini-SSDT-DualLink.aml Mini-SSDT-IMEI.aml Mini-SSDT-DisableGraphics.aml Mini-SSDT-AR9285.aml

.PHONY: all
all : $(ALL) $(MINI)

.PHONY: clean
clean: 
	rm $(ALL) $(MINI)


# combo patches

4x30s.txt : $(COMMON) $(EHCI6)
	cat $^ >$@ 

4x40s_IvyBridge.txt : $(COMMON) $(EHCI7)
	cat $^ >$@ 

4x40s_SandyBridge.txt : $(COMMON) $(EHCI7) $(IMEI)
	cat $^ >$@ 


# mini SSDTs

Mini-SSDT.aml : Mini-SSDT.dsl
	iasl -p $@ $^

Mini-SSDT-DualLink.aml : Mini-SSDT-DualLink.dsl
	iasl -p $@ $^

Mini-SSDT-IMEI.aml : Mini-SSDT-IMEI.dsl
	iasl -p $@ $^

Mini-SSDT-DisableGraphics.aml : Mini-SSDT-DisableGraphics.dsl
	iasl -p $@ $^

Mini-SSDT-AR9285.aml : Mini-SSDT-AR9285.dsl
	iasl -p $@ $^

