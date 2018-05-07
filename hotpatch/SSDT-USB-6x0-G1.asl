// USBInjectAll configuration/override for ProBook 6x0 G1 Haswell
//

// Based on information provided from ProBook 650 G1

//DefinitionBlock("", "SSDT", 2, "hack", "usb6x0g1", 0)
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
                //"port-count", Buffer() { 21, 0, 0, 0 },
                "ports", Package()
                {
                    "HS01", Package()   // HS USB3 hub, docking station
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HS02", Package()   // HS USB3 right back
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HS03", Package()   // HS USB3 right front
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HS04", Package()   // HS USB3 left center
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    //HS05 is finger print reader (disabled)
                    //HS06 not used
                    "HS07", Package()   // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    //HS08 not used
                    "HS09", Package()   // HS USB3 left back
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 9, 0, 0, 0 },
                    },
                    "HS10", Package()   // HS USB3 left front
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 10, 0, 0, 0 },
                    },
                    "HS11", Package()   // WWAN card
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 11, 0, 0, 0 },
                    },
                    "HS12", Package()   // bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 12, 0, 0, 0 },
                    },
                    //HS13 not used
                    //HS14 is smart card reader (disabled)
                    //HS15 is phantom port (port address 15 not used)
                    "SSP1", Package()   // SS USB3 hub, docking station
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 16, 0, 0, 0 },
                    },
                    "SSP2", Package()   // SS USB3 right back
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 17, 0, 0, 0 },
                    },
                    "SSP3", Package()   // SS USB3 right front
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 18, 0, 0, 0 },
                    },
                    "SSP4", Package()   // SS USB3 left center
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 19, 0, 0, 0 },
                    },
                    "SSP5", Package()   // SS USB3 left back
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 20, 0, 0, 0 },
                    },
                    "SSP6", Package()   // SS USB3 left front
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 21, 0, 0, 0 },
                    },
                },
            },
        })
    }

//}

//EOF
