// USBInjectAll configuration/override for EliteBook 1030 G1 (Skylake)
//
// data from livacore's EliteBook 1030 G1

//DefinitionBlock("", "SSDT", 2, "hack", "usb1030g1", 0)
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
                    "HS01", Package()   // HS USB3, left rear
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    #if 0 // disabled
                    "HS02", Package()   // Fingerprint Reader
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    #endif
                    "HS03", Package()   // HP HD Camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    // HS04 not used
                    "HS05", Package()   // HS USB3, right & HS USB3, hub on dock
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    // HS06 not used
                    "HS07", Package()   // HS USB-C, left front
                    {
                        "UsbConnector", 10,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    // HS08 not used
                    "HS09", Package()   // BT
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 9, 0, 0, 0 },
                    },
                    //HS10 not used
                    //USR1 not used
                    //USR2 not used
                    "SS01", Package()   // SS USB3, left rear
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 13, 0, 0, 0 },
                    },
                    "SS02", Package()   // SS USB3, right
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 14, 0, 0, 0 },
                    },
                    "SS03", Package()   // USB-C, left front
                    {
                        "UsbConnector", 10,
                        "port", Buffer() { 15, 0, 0, 0 },
                    },
                    "SS04", Package()   // USB-C, left front
                    {
                        "UsbConnector", 10,
                        "port", Buffer() { 16, 0, 0, 0 },
                    },
                    "SS05", Package()   // SS USB3, hub on dock
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 17, 0, 0, 0 },
                    },
                    // SS06 not used
                },
            },
        })
    }
//}
//EOF

