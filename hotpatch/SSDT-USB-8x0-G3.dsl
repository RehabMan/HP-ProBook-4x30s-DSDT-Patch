// USBInjectAll configuration/override for EliteBook 8x0 G3 (Skylake)
//
//REVIEW: this is currently wrong (copied from ProBook 4x0 G3)

// Based on information provided from kartoffelsalat_reloaded's Skylake EliteBook 840 G3

DefinitionBlock ("", "SSDT", 2, "hack", "usb8x0g3", 0)
{
    //
    // Override for USBInjectAll.kext
    //
    Device(UIAC)
    {
        Name(_HID, "UIA00000")
        Name(RMCF, Package()
        {
            // XHC overrides
            "8086_9d2f", Package()
            {
                "port-count", Buffer() { 18, 0, 0, 0 },
                "ports", Package()
                {
                    "HS01", Package()   // HS component of SS port
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HS02", Package()   // HS component of SS port
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    //HS03 not used
                    "HS04", Package()   // USB2 port
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    //HS05 not used
                    "HS06", Package()   // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                    "HS07", Package()   // bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    #if 0
                    "HS08", Package()   // finger print reader (disabled)
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 8, 0, 0, 0 },
                    },
                    #endif
                    //HS09/HS10 not used
                    "SS01", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 13, 0, 0, 0 },
                    },
                    "SS02", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 14, 0, 0, 0 },
                    },
                    //SS03-SS06 not used
                    //USR1/USR2 not used
                },
            },

        })
    }
}

//EOF