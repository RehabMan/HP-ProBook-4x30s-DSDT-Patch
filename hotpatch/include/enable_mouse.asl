// for including into RMCF at PCI0.LPCB.PS2K.RMCF
// this to be used for laptops without Synaptics, such that VoodooPS2Mouse.kext is enabled

    "Mouse", Package()
    {
        "DisableDevice", ">n",
    },

