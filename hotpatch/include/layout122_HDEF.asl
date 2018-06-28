// inject properties for audio

    External(_SB.PCI0.HDEF, DeviceObj)
    Method(_SB.PCI0.HDEF._DSM, 4)
    {
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Return(Package()
        {
            "layout-id", Buffer(4) { 122, 0, 0, 0 },
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
            "111d_76d1", Package()
            {
                "Custom Commands", Package()
                {
                    Package(){},
                    Package()
                    {
                        "LayoutID", 122,
                        "Command", Buffer()
                        {
                            0x00, 0xc7, 0x1e, 0x81,
                            0x00, 0xc7, 0x1f, 0x03
                        },
                    },
                },
            },
        },
    })

//EOF
