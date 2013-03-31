This set of patches can be used in DSDT Editor or (preferably) MaciASL to apply
all required patches to your HP ProBook 4x30s or HP ProBook 4x40s native DSDT,
so you may run Mac OS X on the laptop.

The original copy of the patches is of unknown origin, but I copied them, made some
corrections, and additions to match what was then being used at tonymacx86.com
for the HP ProBook Installer v5 (supports Lion and Mountain Lion).  This version
brings compatibility with the ProBook 4x40s (thanks to BigDonkey).  Currently,
the ProBook Installer is up to version 6.1 with support for ProBook 4x40s and
OS X 10.8.3.

These patches are applicable to the 4x30s, 4x40s series laptop computers from HP's 
ProBook line. That includes the ProBook 4330s, 4430s, 4530s, and 4730s, 4340s, 4440s,
4540s, and 4740s, including 4x40s ProBooks with Sandy Bridge CPUs. The patches
may have some applicability to the other models in the ProBook series, but further
analysis of your native DSDT would be necessary.

For a step-by-step guide in using these patches the wiki: 
    https://github.com/RehabMan/HP-ProBook-4x30s-DSDT-Patch/wiki/How-to-patch-your-DSDT
    
Or, see this post on tonymacx86.com:
    http://www.tonymacx86.com/hp-probook/83573-patching-your-dsdt-probook-4x30s-using-maciasl.html

And, of course, for more information, see the ProBook forums on tonymacx86.com.

Note: The folder dsdt4530s contains unpatched files from my machine running each
F20, F23, F27, F28, F29, F30, and F40.  These are provided for reference and historical 
purposes only and are not intended to be installed into /Extra nor should they be used for
patching.  You should use your own.  That is the whole purpose of the patches -- to use 
your own.  If something doesn't seem right with your own, you can use these AML files
for doing reference diffs against yours to help debug any problem you might have.
