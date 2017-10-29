// USBInjectAll configuration/override for ZBook G2 Broadwell
//
// Based on nandystam's HP ZBook 15 G2 (Broadwell)

//DefinitionBlock ("", "SSDT", 2, "hack", "usbzbg2", 0)
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
            "8086_9cb1", Package()
            {
                //"port-count", Buffer() { 13, 0, 0, 0 },
                "ports", Package()
                {
                    // HS01 not used
                    "HS02", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HS03", Package()   // internal USB2 hub
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HS04", Package()   // bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    #if 0   // finger print reader (disabled)
                    "HS05", Package()
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    #endif
                    // HS06 not used
                    "HS07", Package()   // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    // HS08/HS09/HS10/HS11 not used
                    // SSP1 not used
                    "SSP2", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 13, 0, 0, 0 },
                    },
                    "SSP3", Package()   // internal USB3 hub
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 14, 0, 0, 0 },
                    },
                    // SSP4 not used
                },
            },
            // Some ZBook G2 Haswell have 8c31 like G1 Haswell
            "8086_8c31", Package()
            {
                //"port-count", Buffer() { 0x0d, 0, 0, 0},
                "ports", Package()
                {
                    // HS01 not used
                    "HS02", Package() // HS on USB3 port SSP2
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x02, 0, 0, 0 },
                    },
                    // HS03,HS04 not used
                    // HS05 fingerprint reader
                    "HS06", Package() // USB2, left back
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 0x06, 0, 0, 0 },
                    },
                    "HS07", Package() // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x07, 0, 0, 0 },
                    },
                    // HS08 not used
                    "HS09", Package() // HS on USB3 port SSP5
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x09, 0, 0, 0 },
                    },
                    "HS10", Package() // HS on USB3 port SSP6
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x0a, 0, 0, 0 },
                    },
                    // HS11 not used
                    "HS12", Package() // bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x0c, 0, 0, 0 },
                    },
                    // HS13,HS14 not used
                    // SSP1 not used
                    "SSP2", Package() // USB3, right front
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x11, 0, 0, 0 },
                    },
                    // SSP3/SSP4 not used
                    "SSP5", Package() // USB3, right back
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x14, 0, 0, 0 },
                    },
                    "SSP6", Package() // USB3, left back
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x15, 0, 0, 0 },
                    },
                },
            },
        })
    }
//}

//EOF
