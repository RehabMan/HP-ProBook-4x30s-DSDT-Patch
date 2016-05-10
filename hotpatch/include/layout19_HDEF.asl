// inject properties for audio

    External(_SB.PCI0.HDEF, DeviceObj)
    Method(_SB.PCI0.HDEF._DSM, 4)
    {
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Return(Package()
        {
            "layout-id", Buffer(4) { 19, 0, 0, 0 },
            "hda-gfx", Buffer() { "onboard-1" },
            "PinConfigurations", Buffer() { },
        })
    }

// CodecCommander configuration

    Name(_SB.PCI0.HDEF.RMCF, Package()
    {
        "CodecCommander", Package()
        {
            "Disable", ">y",
        },
        "CodecCommanderPowerHook", Package()
        {
            "Disable", ">y",
        },
        "CodecCommanderProbeInit", Package()
        {
            "Version", 0x020600,
            "111d_7695", Package()
            {
                "Custom Commands", Package()
                {
                    Package(){}, // signifies Array instead of Dictionary
                    Package()
                    {
                        // set pin configs for IDT 7695
                        "Command", Buffer()
                        {
                            0x00, 0xa7, 0x1c, 0x10, 0x00, 0xa7, 0x1d, 0x10, 0x00, 0xa7, 0x1e, 0x21, 0x00, 0xa7, 0x1f, 0x02,
                            0x00, 0xa7, 0x0c, 0x02, 0x00, 0xb7, 0x1c, 0x20, 0x00, 0xb7, 0x1d, 0x10, 0x00, 0xb7, 0x1e, 0xa1,
                            0x00, 0xb7, 0x1f, 0x02, 0x00, 0xb7, 0x0c, 0x02, 0x00, 0xd7, 0x1c, 0x30, 0x00, 0xd7, 0x1d, 0x01,
                            0x00, 0xd7, 0x1e, 0x17, 0x00, 0xd7, 0x1f, 0x90, 0x00, 0xd7, 0x0c, 0x02, 0x00, 0xe7, 0x1c, 0x40,
                            0x00, 0xe7, 0x1d, 0x01, 0x00, 0xe7, 0x1e, 0xa0, 0x00, 0xe7, 0x1f, 0x90
                        },
                        "On Probe", ">y",
                    },
                },
            },
        },
    })

//EOF
