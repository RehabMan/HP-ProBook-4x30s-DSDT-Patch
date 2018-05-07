// USBInjectAll configuration/override for EliteBook 8x0 G3 (Skylake)
//
// Based on information provided from kartoffelsalat_reloaded's Skylake EliteBook 840 G3
// modifications based on Titanious 840 G3 Skylake.

//DefinitionBlock("", "SSDT", 2, "hack", "usb8x0g3", 0)
//{
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
                    "HS01", Package()   // HS component of SS port, right
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HS02", Package()   // HS component of SS port, left
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    //HS03 not used
                    "HS04", Package()   // docking station hub
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HS05", Package()   // HS component of USB-C, right
                    {
                        "UsbConnector", 10,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    //HS06 not used
                    "HS07", Package()   // bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    //HS08 is fingerprint reader (disabled)
                    "HS09", Package()   // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 9, 0, 0, 0 },
                    },
                    //HS10 smart card reader (disabled)
                    "SS01", Package()   // SS, right
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 13, 0, 0, 0 },
                    },
                    "SS02", Package()   // SS, left
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 14, 0, 0, 0 },
                    },
                    "SS03", Package()   // SS1 component of USB-C, no switch, right
                    {
                        "UsbConnector", 10,
                        "port", Buffer() { 15, 0, 0, 0 },
                    },
                    "SS04", Package()   // docking station hub
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 16, 0, 0, 0 },
                    },
                    "SS05", Package()   // SS2 component of USB-C, no switch, right
                    {
                        "UsbConnector", 10,
                        "port", Buffer() { 17, 0, 0, 0 },
                    },
                    //SS06 not used
                    //USR1/USR2 not used
                },
            },

        })
    }
//}
//EOF
