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

For a step-by-step guide, see the wiki: https://github.com/RehabMan/HP-ProBook-4x30s-DSDT-Patch/wiki/How-to-patch-your-DSDT

And, of course, for more information, see the ProBook forums on tonymacx86.com.

Note: The folder dsdt4530s contains unpatched files from my machine running each
F20, F23, F27, and F28.  These are provided for reference only and are not intended
to be installed into /Extra nor should they be used for patching.  You should use
your own.  That is the whole purpose of the patches -- to use your own.  If something
doesn't seem right with your own, you can use these AML files for doing reference 
diffs against yours to help debug any problem you might have.
