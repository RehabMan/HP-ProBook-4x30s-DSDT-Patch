// USBInjectAll configuration/override for EliteBook 1050 G1 (KabyLake-R)
//
// Based on information provided from Kuque KabyLake-R EliteBook 1050 G1

//DefinitionBlock("", "SSDT", 2, "hack", "usb1050g1", 0)
//{
//
// Override for USBInjectAll.kext
//
    Device(UIAC)
    {
        Name (_HID, "UIA00000")  // _HID: Hardware ID
        Name (RMCF, Package (0x02)
        {
            "8086_a36d", Package()
            {
                "port-count", Buffer() { 26, 0, 0, 0 },
                "ports", Package()
                {
                    "HS04", Package()   // rear USB3
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HS05", Package()   // front USB3
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    "HS07", Package()   // camera
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
                    "HS11", Package()   // rear type-C
                    {
                        "UsbConnector", 10,
                        "port", Buffer() { 11, 0, 0, 0 },
                    },
                    "HS13", Package()   // front type-C
                    {
                        "UsbConnector", 10,
                        "port", Buffer() { 13, 0, 0, 0 },
                    },
                    "HS14", Package()   // bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 14, 0, 0, 0 },
                    },
                    "SS03", Package()   // rear USB3
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 19, 0, 0, 0 },
                    },
                    "SS04", Package()   // front USB3
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 20, 0, 0, 0 },
                    },
#if 0 // up to 4 of these SS ports may be used by the front/rear type-C
                    "SS05", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 21, 0, 0, 0 },
                    },
                    "SS06", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 22, 0, 0, 0 },
                    },
                    "SS07", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 23, 0, 0, 0 },
                    },
                    "SS08", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 24, 0, 0, 0 },
                    },
                    "SS09", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 25, 0, 0, 0 },
                    },
                    "SS10", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 26, 0, 0, 0 },
                    },
                    "USR1", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 15, 0, 0, 0 },
                    },
                    "USR2", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 16, 0, 0, 0 },
                    },
#endif
                },
            },
        })
    }
//}

//EOF
