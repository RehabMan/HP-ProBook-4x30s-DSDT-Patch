GENERIC = 01_Compilation.txt 02_DSDTPatch.txt 04_FanPatch.txt 05_OSCheck.txt 06_BatteryPart0.txt 07_BatteryPart1.txt
HDMI = 03a_HDMI.txt
HDMI1080P = 03b_1080p+HDMI.txt

all : all.txt all1080.txt

all.txt : $(GENERIC) $(HDMI)
	cat $^ >$@ 

all1080.txt : $(GENERIC) $(HDMI1080P)
	cat $^ >$@

clean: 
	rm all.txt all1080.txt

