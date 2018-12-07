// USBInjectAll configuration/override for ZBook G1 Haswell
//
// Based on secret-sounds' HP ZBook 17 G1 (Haswell)
// Also based on matrining's ZBook 14 G1 (Haswell) (8086:9c31)

//DefinitionBlock("", "SSDT", 2, "hack", "usbzbg1", 0)
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
            "8086_8c31", Package()
            {
                //"port-count", Buffer() { 0x0d, 0, 0, 0},
                "ports", Package()
                {
                    // HS01 not used
                    "HS02", Package() // HS on USB3 port SS02
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
                    "HS09", Package() // HS on USB3 port SS05
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x09, 0, 0, 0 },
                    },
                    "HS10", Package() // HS on USB3 port SS06
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
                    // SS01 not used
                    "SS02", Package() // USB3, right front
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x11, 0, 0, 0 },
                    },
                    // SS03/SS04 not used
                    "SS05", Package() // USB3, right back
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x14, 0, 0, 0 },
                    },
                    "SS06", Package() // USB3, left back
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x15, 0, 0, 0 },
                    },
                },
            },
            "8086_9c31", Package()
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
                    "HS04", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    #if 0   // finger print reader (disabled)
                    "HS05", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    #endif
                    // HS06 not used
                    "HS07", Package()   // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    // HS08/HS09 not used
                    // SS01 not used
                    "SS02", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 11, 0, 0, 0 },
                    },
                    "SS03", Package()   // internal USB3 hub
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 12, 0, 0, 0 },
                    },
                    "SS04", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 13, 0, 0, 0 },
                    },
                },
            },
        })
    }
//}

//EOF
