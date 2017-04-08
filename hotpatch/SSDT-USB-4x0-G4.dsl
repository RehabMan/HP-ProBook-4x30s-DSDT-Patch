// USBInjectAll configuration/override for Probook 4x0 G3 (Skylake)
//
// Based on information provided from Mario's KabyLake ProBook 440 G4
// HS05 port added for Skylake ProBook 450 G3 (per data from mo7a1995)

DefinitionBlock ("", "SSDT", 2, "hack", "usb4x0g4", 0)
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
                    "HS01", Package()   // HS component of USB3 port (440 G4, right)
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HS02", Package()   // HS component of USB-C port (440 G4, right)
                    {
                        "UsbConnector", 10,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    //HS03 not used
                    "HS04", Package()   // USB2 port (440 G4, left)
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HS05", Package()   // USB2 port (not on 440 G4, but enabled for case of 450 G4 may have it)
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    "HS06", Package()   // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                    "HS07", Package()   // bluetooth
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
                    //HS09/HS10 not used
                    "SS01", Package()   // SS component of USB3 port (440 G4, right)
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 13, 0, 0, 0 },
                    },
                    "SS02", Package()   // SS1 component of USB-C port (440 G4, right)
                    {
                        "UsbConnector", 10,
                        "port", Buffer() { 14, 0, 0, 0 },
                    },
                    "SS03", Package()   // SS2 component of USB-C port (440 G4, right)
                    {
                        "UsbConnector", 10,
                        "port", Buffer() { 15, 0, 0, 0 },
                    },
                    //SS04-SS06 not used
                    //USR1/USR2 not used
                },
            },

        })
    }
}

//EOF
