// inject properties for audio

    External(_SB.PCI0.HDEF, DeviceObj)
    Method(_SB.PCI0.HDEF._DSM, 4)
    {
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Return(Package()
        {
            "layout-id", Buffer(4) { 17, 0, 0, 0 },
            "hda-gfx", Buffer() { "onboard-1" },
            "PinConfigurations", Buffer() { },
        })
    }

// CodecCommander configuration

    Name(_SB.PCI0.HDEF.RMCF, Package()
    {
        "CodecCommander", Package() { "Disable", ">y", },
        "CodecCommanderPowerHook", Package() { "Disable", ">y", },
        "CodecCommanderProbeInit", Package()
        {
            "Version", 0x020600,
            "111d_76e0", Package()
            {
                "PinConfigDefault", Package()
                {
                    Package(){},
                    Package()
                    {
                        "LayoutID", 17,
                        "PinConfigs", Package()
                        {
                            Package(){},
                            0x0a, 0x01811020,
                            0x0b, 0x01211050,
                            0x0c, 0x400000f0,
                            0x0d, 0x90100130,
                            0x0e, 0x400000f0,
                            0x0f, 0x400000f0,
                            0x10, 0x400000f0,
                            0x11, 0x90a00110,
                            0x1f, 0x400000f0,
                            0x20, 0x400000f0,
                        },
                    },
                },
            },
        },
    })

//EOF
