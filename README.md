## DSDT patches for HP ProBook/EliteBook/ZBook series laptops

This set of patches/makefile can be used to patch your HP ProBook/EliteBook/ZBook DSDTs.  There are also post install scripts that can be used to create and install the kexts the are required for this laptop series.

A wide range of these HP laptops is supported, including Sandy Bridge, Ivy Bridge, Haswell, Broadwell, and now Skylake.

Although older versions of the repo had scripts to automate patching of DSDT/SSDTs, the current version does it all via config.plist hotpatching and SSDT-HACK.

Please refer to this guide thread on tonymacx86.com for a step-by-step process, feedback, and questions:

http://www.tonymacx86.com/el-capitan-laptop-guides/189416-guide-hp-probook-elitebook-zbook-using-clover-uefi-hotpatch-10-11-a.html


### Original non-hotpatch guide

The original patches for the 4x30/4x40 series are still present, and available through MaciASL as a patch source.

The guide for using those patches is still in the WiKi here:

https://github.com/RehabMan/HP-ProBook-4x30s-DSDT-Patch/wiki/How-to-patch-your-DSDT


### Change Log:

2016-04-20

- initial creation of this README

- current code here is a work-in-progress.

