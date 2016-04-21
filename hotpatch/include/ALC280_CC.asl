// ALC280 CodecCommander custom configuration

    External(_SB.PCI0.HDEF, DeviceObj)
    Name(_SB.PCI0.HDEF.RMCF, Package()
    {
        "CodecCommander", Package()
        {
            "Custom Commands", Package()
            {
                Package(){}, // signifies Array instead of Dictionary
                Package()
                {
                    // 0x15 SET_UNSOLICITED_ENABLE 0x83
                    "Command", Buffer() { 0x01, 0x57, 0x08, 0x83 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
                Package()
                {
                    // Node 0x1a - Pin Control (In Enable / VRefEn)
                    "Command", Buffer() { 0x01, 0x1a, 0x07, 0x24 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
            },
        },
    })
