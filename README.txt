These set of patches can be used in the DSDT Editor to apply all required patches 
to your HP ProBook 4x30s native DSDT so you may run Mac OS X on the laptop. The 
original copy of the patches is of unknown origin, but I took them, made some
corrections, and additions to match what is currently being used at tonymacx86.com
for the HP ProBook Installer v5 (supports Lion and Mountain Lion).

These patches are applicable to the 4x30s series laptop computers from HP's ProBook 
line. That includes the ProBook 4330s, 4430s, 4530s, and 4730s. The patches may 
have some applicability to the other models in the ProBook series, but further 
analysis of your native DSDT would be necessary.

To use these patches, extract your native DSDT binary, then use the Intel AML compiler
(iasl) to disassemble the DSDT. From there you can apply each patch one by one. For
patch #3, apply only 3a or 3b, depending on whether you have replaced the standard 
screen with a 1080p screen.

And, of course, for more information, see the ProBook forums on tonymacx86.com.

