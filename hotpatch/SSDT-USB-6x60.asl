// USB configuration for EliteBook 6x60
// Based on information from EliteBook 6460p

//DefinitionBlock ("", "SSDT", 2, "hack", "usb6x60", 0)
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
                    "HP11", Package()   // USB2 near left
                    {
                        //"UsbConnector", 0,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HP12", Package()   // USB2 near right
                    {
                        //"UsbConnector", 0,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HP13", Package()   // USB2 far left
                    {
                        //"UsbConnector", 0,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HP14", Package()   // camera
                    {
                        //"UsbConnector", 255,
                        "portType", 2,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HP16", Package()   // bluetooth
                    {
                        //"UsbConnector", 255,
                        "portType", 2,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                    //HP18 is smart card reader (disabled)
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
                    "HP22", Package()   // WWAN module
                    {
                        //"UsbConnector", 255,
                        "portType", 2,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HP23", Package()   // USB2 far right
                    {
                        //"UsbConnector", 0,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HP24", Package()   // USB2 4-port hub on docking station
                    {
                        //"UsbConnector", 0,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HP25", Package()   // extra USB2 on 6560b
                    {
                        //"UsbConnector", 0,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                },
            },
        })
    }
//}

//EOF
