// for including into RMCF at PCI0.LPCB.PS2K.RMCF
// this could be used for laptops with I2C trackpad...
// it disables the Synaptics PS2 trackpad kext

    "Synaptics TouchPad", Package()
    {
        "DisableDevice", ">y",
    },

