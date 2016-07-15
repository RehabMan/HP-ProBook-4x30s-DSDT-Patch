// USBInjectAll configuration/override for ProBook 640 G2 Skylake
//
// Based on information provided from chezyann's ProBook 640 G2 Skylake

DefinitionBlock ("", "SSDT", 2, "hack", "usb640g2s", 0)
{
    //
    // Override for USBInjectAll.kext
    //
    Device(UIAC)
    {
        Name(_HID, "UIA00000")
        Name(RMCF, Package()
        {
            // XHC overrides
            "8086_9d2f", Package()
            {
                "port-count", Buffer() { 18, 0, 0, 0 },
                "ports", Package()
                {
                    "HS01", Package()   // HS component of SS port
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HS02", Package()   // HS component of SS port
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    //HS03-HS06 not used
                    "HS07", Package()   // bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    //HS08 is fingerprint reader (disabled)
                    "HS09", Package()   // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 9, 0, 0, 0 },
                    },
                    //HS10 not used
                    "SS01", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 13, 0, 0, 0 },
                    },
                    "SS02", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 14, 0, 0, 0 },
                    },
                    //SS03-SS06 not used
                    //USR1/USR2 not used
                },
            },

        })
    }
}

//EOF