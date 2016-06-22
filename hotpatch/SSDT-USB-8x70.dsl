// USB configuration for EliteBook 8x70
//
// This information from an EliteBook 8470p (courtesy freeweber).

DefinitionBlock ("", "SSDT", 2, "hack", "usb8x70", 0)
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
                    //HP11/HP12 not used
                    "HP13", Package()   // HS USB3 right near hinge
                    {
                        //"UsbConnector", 3,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HP14", Package()   // HS USB3 right far from hinge
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
                    "HP22", Package()   // USB2 left middle (near power button)
                    {
                        //"UsbConnector", 0,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HP23", Package()   // camera
                    {
                        //"UsbConnector", 255,
                        "portType", 4,  // fix for camera after sleep?
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    //HP26 not used
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
                    // SS05/SS06 not used
                    "SS07", Package()   // SS USB3 right near hinge
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    "SS08", Package()   // SS USB3 right far from hinge
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 8, 0, 0, 0 },
                    },
                },
            },
        })
    }
}

//EOF