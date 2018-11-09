// USBInjectAll configuration/override for EliteBook 8x0s G1 Haswell
//

// Current data includes HS01/SS01 from the optional docking station.
// still missing a port for bluetooth

//DefinitionBlock("", "SSDT", 2, "hack", "usb8x0g1", 0)
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
            "8086_9xxx", Package()
            {
                //"port-count", Buffer() { 0x0d, 0, 0, 0},
                "ports", Package()
                {
                    "HS01", Package() // HS componnent of SS01 (dock)
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x01, 0, 0, 0 },
                    },
                    "HS02", Package() // HS component of SS02
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x02, 0, 0, 0 },
                    },
                    "HS03", Package() // internal 4-port USB2 hub (SS03 is USB3)
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x03, 0, 0, 0 },
                    },
                    "HS04", Package() // HS component of SS04
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x04, 0, 0, 0 },
                    },
                    #if 0
                    "HS05", Package() // fingerprint reader (disabled)
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x05, 0, 0, 0 },
                    },
                    #endif
                    "HS06", Package() // internal WWAN
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x06, 0, 0, 0 },
                    },
                    "HS07", Package() // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x07, 0, 0, 0 },
                    },
                    // HS08/HS09 not used
                    "SS01", Package() // SS component on dock USB3
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x0a, 0, 0, 0 },
                    },
                    "SS02", Package() // left side USB3
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x0b, 0, 0, 0 },
                    },
                    "SS03", Package() // internal 4-port USB3 hub (HS03 is USB2)
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x0c, 0, 0, 0 },
                    },
                    "SS04", Package() // SS USB3 (HS04 is USB2)
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x0d, 0, 0, 0 },
                    },
                    //REVIEW: what port is bluetooth?
                },
            },
        })
    }

//}

//EOF
