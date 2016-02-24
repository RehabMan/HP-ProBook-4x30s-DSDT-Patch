// USB configuration for 4x40s

DefinitionBlock ("SSDT-USB-4x40s.aml", "SSDT", 1, "hack", "usb", 0x00003000)
{
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
                    "HP12", Package()   // HS USB3 near left
                    {
                        //"UsbConnector", 3,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HP13", Package()   // HS USB3 far left
                    {
                        //"UsbConnector", 3,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HP14", Package()   // USB2 far right
                    {
                        //"UsbConnector", 0,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HP16", Package()   // bluetooth
                    {
                        //"UsbConnector", 255,
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
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    #endif
                    "HP22", Package()   // USB2 near right
                    {
                        //"UsbConnector", 0,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HP23", Package()   // camera
                    {
                        //"UsbConnector", 255,
                        "port", Buffer() { 3, 0, 0, 0 },
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
                    // SS05 not used
                    "SS06", Package()   // SS USB3 near left
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                    "SS07", Package()   // SS USB3 far left
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    // SS08 not used
                },
            },
        })
    }
}

//EOF