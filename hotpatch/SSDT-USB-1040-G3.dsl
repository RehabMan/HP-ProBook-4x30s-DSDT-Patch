// USBInjectAll configuration/override for EliteBook 1040 G3 (Skylake)
//
// Based on information provided from expastname's Skylake EliteBook 1040 G3

DefinitionBlock ("", "SSDT", 2, "hack", "usb1040g3", 0)
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
                //"port-count", Buffer() { 18, 0, 0, 0 },
                "ports", Package()
                {
                    "HS01", Package() //USB2 External port Right
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HS02", Package() //USB2 External port Left
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HS07", Package() //Bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    // HS08 is finger print reader (disabled)
                    "HS09", Package()  //Camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 9, 0, 0, 0 },
                    },
                    "SS01", Package() //USB3 External port Right
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 13, 0, 0, 0 },
                    },
                    "SS02", Package() //USB3 External port Left
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 14, 0, 0, 0 },
                    },
                },
            },
        })
    }
}

//EOF
