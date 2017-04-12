// USBInjectAll configuration/override for ZBook G3 (Skylake)
//
// Based on information provided from hackintoshking's Skylake ZBook G3

//DefinitionBlock ("", "SSDT", 2, "hack", "usbzbg3", 0)
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
            "8086_a12f", Package()
            {
                "port-count", Buffer() { 21, 0, 0, 0 },
                "ports", Package()
                {
                    "HS01", Package()   // HS component of SS01 port
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    //HS02/HS03 not used
                    "HS04", Package()   // HS component of SS04 port
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HS05", Package()   // HS component of SS05 port
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    //HS06 not used
                    "HS07", Package()   // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    //HS08/HS09/HS10/HS11 not used
                    "HS12", Package()   // bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 12, 0, 0, 0 },
                    },
                    //HS13/HS14 not used
                    "SS01", Package()   // USB3
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 17, 0, 0, 0 },
                    },
                    //SS02/SS03 not used
                    "SS04", Package()   // USB3
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 20, 0, 0, 0 },
                    },
                    "SS05", Package()   // USB3
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 21, 0, 0, 0 },
                    },
                    //SS06/SS07/SS08/SS09/SS10 not used
                    //USR1/USR2 not used
                },
            },

        })
    }
//}
//EOF
