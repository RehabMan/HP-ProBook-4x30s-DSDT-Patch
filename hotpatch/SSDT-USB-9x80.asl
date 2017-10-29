// USBInjectAll configuration/override for EliteBook 9x80m Haswell
//

// Based on information provided from an EliteBook 9480m Haswell

//DefinitionBlock ("", "SSDT", 2, "hack", "usb9x80", 0)
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
            "8086_9c31", Package()
            {
                //"port-count", Buffer() { 0x0f, 0, 0, 0},
                "ports", Package()
                {
                    // HS01 not used
                    "HS02", Package() // USB2 (SSP2 is USB3)
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HS03", Package() // internal 4-port USB2 hub (SSP3 is USB3)
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HS04", Package() // bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    //HS05 is fingerprint reader (disabled)
                    //HS06 not used
                    "HS07", Package() // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    // HS08/HS09/HS10/HS11 not used
                    // SSP1 not used
                    "SSP2", Package() // SS USB3 port
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 11, 0, 0, 0 },
                    },
                    "SSP3", Package() // SS USB3 hub (HS03.port2 is USB2?)
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 12, 0, 0, 0 },
                    },
                    // SSP4 not used
                },
            },
        })
    }
//}

//EOF
