// USBInjectAll configuration/override for ProBook 4x0 G1 Haswell
//
// Based on information provided from ProBook 450 G1 Haswell (from Titanius)
//

//DefinitionBlock("", "SSDT", 2, "hack", "usb4x0g1", 0)
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
                    //HS01 not used
                    "HS02", Package()   // HS USB3 left back
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HS03", Package()   // HS USB3 left front
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HS04", Package()   // USB2 right front
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    //HS05 is finger print reader (disabled)
                    "HS06", Package()   // USB2 right back
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
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
                    //HS15 is phantom port (port address 15 not used)
                    //SSP1 not used
                    "SSP2", Package()   // SS USB3 left back
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 17, 0, 0, 0 },
                    },
                    "SSP3", Package()   // SS USB3 left front
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 18, 0, 0, 0 },
                    },
                    //SSP4/SSP5/SSP6 not used
                },
            },
        })
    }
//}

//EOF
