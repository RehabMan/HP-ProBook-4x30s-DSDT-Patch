// USBInjectAll configuration/override for EliteBook 820 G2 Broadwell
//   and EliteBook 850 G2 Broadwell
//

//REVIEW: preliminary data for G2.  Note that it has a hub on XHC, which
//  may need further work.

// Based on information provided from EliteBook Pro 820 G2
// This same configuration is also valid for EliteBook 850 G2 Broadwell

//REVIEW: rename to SSDT-USB-8x0-G2

//DefinitionBlock("", "SSDT", 2, "hack", "usb820g2", 0)
//{
//
// Override for USBInjectAll.kext
//
    Device(UIAC)
    {
        Name(_HID, "UIA00000")
        Name(RMCF, Package()
        {
            // EliteBook 820 G2
            "8086_9cb1", Package()
            {
                //"port-count", Buffer() { 0x0f, 0, 0, 0},
                "ports", Package()
                {
                    "HS01", Package() // 4-port USB2 hub (dockingstation)
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x01, 0, 0, 0 },
                    },
                    "HS02", Package() // USB2 (SSP2 is USB3)
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 0x02, 0, 0, 0 },
                    },
                    "HS03", Package() // internal 4-port USB2 hub (SSP3 is USB3)
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x03, 0, 0, 0 },
                    },
                    "HS04", Package() // bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x04, 0, 0, 0 },
                    },
                    //HS05 is fingerprint reader (disabled)
                    //HS06 not used
                    "HS07", Package() // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x07, 0, 0, 0 },
                    },
                    // HS08/HS09/HS10/HS11 not used
                    "SSP1", Package() // 4-port USB3 hub (dockingstation)
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x0c, 0, 0, 0 },
                    },
                    "SSP2", Package() // SS USB3 port
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x0d, 0, 0, 0 },
                    },
                    "SSP3", Package() // SS USB3 hub (HS03.port2 is USB2?)
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x0e, 0, 0, 0 },
                    },
                    // SSP4 not used
                },
            },
            // EliteBook 840 G2
            "8086_9xxx", Package()
            {
                //"port-count", Buffer() { 0x0d, 0, 0, 0},
                "ports", Package()
                {
                    // HS01 not used
                    "HS02", Package() // USB2
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 0x02, 0, 0, 0 },
                    },
                    "HS03", Package() // internal 4-port USB2 hub (SSP3 is USB3)
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x03, 0, 0, 0 },
                    },
                    "HS04", Package() // bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x04, 0, 0, 0 },
                    },
                    // HS05/HS06 not used
                    "HS07", Package() // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x07, 0, 0, 0 },
                    },
                    // HS08/HS09 not used
                    // SSP1/SSP2/SSP3 not used
                    "SSP4", Package() // SS USB3 (HS03.port2 is USB2?)
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x0d, 0, 0, 0 },
                    },
                },
            },
        })
    }

//}

//EOF
