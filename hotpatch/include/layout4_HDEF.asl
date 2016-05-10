// inject properties for audio

    External(_SB.PCI0.HDEF, DeviceObj)
    Method(_SB.PCI0.HDEF._DSM, 4)
    {
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Return(Package()
        {
            "layout-id", Buffer(4) { 4, 0, 0, 0 },
            "hda-gfx", Buffer() { "onboard-1" },
            "PinConfigurations", Buffer() { },
        })
    }

// CodecCommander configuration

    Name(_SB.PCI0.HDEF.RMCF, Package()
    {
        "CodecCommanderProbeInit", Package()
        {
            "Version", 0x020600,
            "10ec_0280", Package()
            {
                "Custom Commands", Package()
                {
                    Package(){}, // signifies Array instead of Dictionary
                    Package()
                    {
                        // set pin configs for ALC280
                        "Command", Buffer()
                        {
                            0x01, 0x27, 0x1c, 0x10, 0x01, 0x27, 0x1d, 0x00, 0x01, 0x27, 0x1e, 0xa0, 0x01, 0x27, 0x1f, 0x90,
                            0x01, 0x47, 0x1c, 0x20, 0x01, 0x47, 0x1d, 0x00, 0x01, 0x47, 0x1e, 0x17, 0x01, 0x47, 0x1f, 0x90,
                            0x01, 0x57, 0x1c, 0x30, 0x01, 0x57, 0x1d, 0x10, 0x01, 0x57, 0x1e, 0x21, 0x01, 0x57, 0x1f, 0x02,
                            0x01, 0xa7, 0x1c, 0x40, 0x01, 0xa7, 0x1d, 0x10, 0x01, 0xa7, 0x1e, 0x81, 0x01, 0xa7, 0x1f, 0x02,
                            0x01, 0x47, 0x0c, 0x02, 0x01, 0x57, 0x0c, 0x02
                        },
                        "On Probe", ">y",
                    },
                },
            },
        },
        "CodecCommander", Package()
        {
            "Version", 0x020600,
            "10ec_0280", Package()
            {
                "Custom Commands", Package()
                {
                    Package(){}, // signifies Array instead of Dictionary
                    Package()
                    {
                        // 0x1a SET_PIN_WIDGET_CONTROL 0x25
                        // Node 0x1a - Pin Control (In Enable / VRefEn)
                        "Command", Buffer() { 0x01, 0x1a, 0x07, 0x25 },
                        "On Init", ">y",
                        "On Sleep", ">n",
                        "On Wake", ">y",
                    },
                    Package()
                    {
                        // 0x15 SET_UNSOLICITED_ENABLE 0x83
                        "Command", Buffer() { 0x01, 0x57, 0x08, 0x83 },
                        "On Init", ">y",
                        "On Sleep", ">n",
                        "On Wake", ">y",
                    },
                },
            },
        },
    })

//EOF
