// USBInjectAll configuration/override for ProBook 4x0s G2
//
// investigative work done by mo7a1995 (with direction from RehabMan)
//
// modifications based on Titanius 450 G2 Haswell.
// added HS08 for USB2 port reported not working by daniela-sammartino

//DefinitionBlock("", "SSDT", 2, "hack", "usb4x0g2", 0)
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
            "8086_9c31", Package()  // for G2 Haswell
            {
                //"port-count", Buffer() { 13, 0, 0, 0},
                "ports", Package()
                {
                    "HS01", Package() // USB2, (right back)
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HS02", Package() // HS component of SS port, (left back)
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HS03", Package() // HS component of SS port, (left front)
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HS04", Package() // bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    #if 0
                    "HS05", Package() // fingerprint reader (disabled)
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    #endif
                    "HS06", Package() // internal WWAN
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                    "HS07", Package() // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    "HS08", Package() // USB2, (right front)
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 8, 0, 0, 0 },
                    },
                    //HS09 not used
                    "SS01", Package() // SS USB3 (left front)
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 10, 0, 0, 0 },
                    },
                    "SS02", Package() // SS USB3 (left back)
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 11, 0, 0, 0 },
                    },
                    //SS03 not used
                    //SS04 not used
                },
            },
            "8086_9cb1", Package() // for G2 Broadwell
            {
                //"port-count", Buffer() { 15, 0, 0, 0},
                "ports", Package()
                {
                    "HS01", Package() // USB2 (right back)
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HS02", Package() // HS USB3 (left back)
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HS03", Package() // HS USB3 (left front)
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HS04", Package() // bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    #if 0
                    "HS05", Package() // fingerprint reader (disabled)
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    #endif
                    "HS06", Package() // internal WWAN
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                    "HS07", Package() // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    "HS08", Package() // USB2 port (right front)
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 8, 0, 0, 0 },
                    },
                    //HS09 not used
                    //HS10 not used
                    //HS11 not used
                    "SS01", Package() // SS USB3 (left front)
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 12, 0, 0, 0 },
                    },
                    "SS02", Package() // SS USB3 (left back)
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 13, 0, 0, 0 },
                    },
                    //SS03 not used
                    //SS04 not used
                },
            },
        })
    }

//}

//EOF
