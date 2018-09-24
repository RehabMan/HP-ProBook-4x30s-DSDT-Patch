LayoutID and PathMapID mappings for AppleHDA_ProBook.kext and applicable AppleALC.kext

ALC282: 33 (was 3 prior to 10.14)
	AppleALC: 3,4,13,27,28,29,76,86,127

ALC280: 4
	AppleALC: 3,(4),11,13,15

CX20724: 5(Mirone version) or 7(InsanelyDeepak version)
	AppleALC: 3(Mirone), 13(InsanelyDeepak)

ALC286: 6
	AppleALC: 3

CX8200: 20 (extracted from AppleALC)
	AppleALC: 3

IDT_76d1 (IDT92HD87B1_3): 122 (was 12 prior to 10.14)
	AppleALC: 12, 13

IDT_76d9 (IDT92HD87B2_4): 123 (was 13 prior to 10.14)
	AppleALC: 13

IDT_76e0 (IDT92HD91BXX): 17
	AppleALC: 3, 12(envy), 13, 33, 84

IDT_7605 (IDT92HD81B1X5): 128 (was 18 prior to 10.14) (has alternate: IDT92HD87B1)
	AppleALC: 3, 11, (12), 20, 21, 28

IDT_7695 (IDT92HD95): 19
	AppleALC: 12


Note: Layout-id 14,15,16 may not be able to be used due to AppleHDA not using them (there may be a whitelist)

Note: macOS Mojave removes layout-id that were used: 3, 12, 13, 18.

Note: AppleALC removes layout-id restriction with a bit of trickery/patching.


--

Model/Audio mapping


ALC282: 4x0G2 Haswell, 8x0G2 Haswell, 4x0G2 Broadwell

ALC280: Zbook G2 Haswell/Broadwell, HP Folio 9480m Haswell, 8x0G2 Broadwell

ALC286: EliteBook Folio 1020 G1/Broadwell

CX20724: 4x0sG3 Skylake

76d1: 4x30s,

76d9: 4x40s

76e0: 4x0G0, 4x0G1, 9x70m, 4x0G1, 8x0G1, 1040G1,

7605: 6x60s, 6x70s, 6x70AMD, 6x60wAMD, 6x60wNVIDIA, 8x70p, 2x70

7695: 3x0G1,

CX8200: 4x0s G4 Kabylake


--

Note regarding ALC280 combo jack and difference between original and for G2.

From Mirone: http://www.tonymacx86.com/el-capitan-laptop-support/191207-hp-elitebook-g2-alc280-combo-jack-wip-7.html#post1242688

To the kext to ALC280 of @zirkaiva I had to add in: Headphones/MuteGPIO=4 in Layout-ID, to your Headphone work, to be honest this is an exception for most the ALC codec for Laptops works without it in Layout-ID, and this is your case I should have tried the first time, When you said that ALC280_Original worked, least headphones. We have two slightly different scenarios, the first in which HP Elitebook 9480m Folio need Headphones/MuteGPIO=4 in Layout-ID, for your Headphone works and the second where HP Elitebook G2, not must have these values in its Layout-ID so your headset work correctly, RehabMan keep this in mind when updating your repository.
