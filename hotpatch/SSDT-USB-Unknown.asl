// USB configuration that disables USBInjectAll.kext
// This can be used for models which have correct ACPI for USB (_UPC/_PLD)

//DefinitionBlock("", "SSDT", 2, "hack", "usbunk", 0)
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
                "Disabled", ">y",
            },
            /// hub on port #1 EHCI#1
            "HUB1", Package()
            {
                "Disabled", ">y",
            },
            // EHCI#2
            "EH02", Package()
            {
                "Disabled", ">y",
            },
            // hub on port#1 EHCI#2
            "HUB2", Package()
            {
                "Disabled", ">y",
            },
            // XHC
            "XHC", Package()
            {
                "Disabled", ">y",
            },
        })
    }
//}

//EOF
