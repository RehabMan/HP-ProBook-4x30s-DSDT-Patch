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
                "PinConfigDefault", Package()
                {
                    Package(){},
                    Package()
                    {
                        "LayoutID", 19,
                        "PinConfigs", Package()
                        {
                            Package(){},
                            0x0a, 0x02211010,
                            0x0b, 0x02a11020,
                            0x0d, 0x90170130,
                            0x0e, 0x90a00140,
                        },
                    },
                },
                "Custom Commands", Package()
                {
                    Package(){},
                    Package()
                    {
                        "LayoutID", 19,
                        "Command", Buffer()
                        {
                            0x00, 0xa7, 0x0c, 0x02,
                            0x00, 0xb7, 0x0c, 0x02,
                            0x00, 0xd7, 0x0c, 0x02
                        },
                    },
                },
            },
        },
    })

//EOF
