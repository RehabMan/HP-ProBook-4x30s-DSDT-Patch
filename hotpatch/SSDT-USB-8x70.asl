// USB configuration for EliteBook 8x70
//
// This information from an EliteBook 8470p (courtesy freeweber).

//DefinitionBlock("", "SSDT", 2, "hack", "usb8x70", 0)
//{
    //
    // Override for USBInjectAll.kext
    //
    Device(UIAC)
    {
        Name(_HID, "UIA00000")
        Name(RMCF, Package()
        {
            // EHCI#1
            "EH01", Package()
            {
                "port-count", Buffer() { 8, 0, 0, 0 },
                "ports", Package()
                {
                    "PR11", Package()
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                },
            },
            /// hub on port #1 EHCI#1
            "HUB1", Package()
            {
                "port-count", Buffer() { 8, 0, 0, 0 },
                "ports", Package()
                {
                    "HP11", Package()   // USB2 hub (on normal dock and advanced dock)
                    {
                        //"UsbConnector", 0,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HP12", Package()   // near display USB2 left
                    {
                        //"UsbConnector", 0,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HP13", Package()   // near display USB3 right
                    {
                        //"UsbConnector", 0,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HP14", Package()   // far display USB3 right
                    {
                        //"UsbConnector", 3,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HP16", Package()   // bluetooth
                    {
                        //"UsbConnector", 255,
                        "portType", 2,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                },
            },
            // EHCI#2
            "EH02", Package()
            {
                "port-count", Buffer() { 6, 0, 0, 0 },
                "ports", Package()
                {
                    "PR21", Package()
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                },
            },
            // hub on port#1 EHCI#2
            "HUB2", Package()
            {
                "port-count", Buffer() { 6, 0, 0, 0 },
                "ports", Package()
                {
                    #if 0
                    "HP21", Package()   // fingerprint reader (disabled)
                    {
                        //"UsbConnector", 255,
                        "portType", 2,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    #endif
                    "HP22", Package()   // far display USB2 left
                    {
                        //"UsbConnector", 0,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HP23", Package()   // camera
                    {
                        //"UsbConnector", 255,
                        "portType", 2,
                        //"portType", 4,  // fix for camera after sleep?
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HP24", Package()   //  USB3 port with hub (advanced dock)
                    {
                        //"UsbConnector", 3,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HP26", Package()   // eSata/USB2 port left
                    {
                        //"UsbConnector", 0,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                },
            },
            // XHC
            "8086_1e31", Package()
            {
                "port-count", Buffer() { 8, 0, 0, 0 },
                "ports", Package()
                {
                    // HS01 not used
                    // HS02-HS04 not used due to FakePCIID_XHCIMux
                    // HS02 HS USB3 near left
                    // HS03 HS USB3 far left
                    // HS04 USB2 far right
                    // SS05 USB3 advanced dock

                    "SS05", Package()   // SS USB3 hub advanced dock
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    "SS07", Package()   // near display SS USB3 right
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    "SS08", Package()   // far display SS USB3 right
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 8, 0, 0, 0 },
                    },
                },
            },
        })
    }
//}

//EOF
