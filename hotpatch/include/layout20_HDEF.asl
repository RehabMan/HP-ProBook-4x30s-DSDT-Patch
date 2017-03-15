// inject properties for audio

    External(_SB.PCI0.HDEF, DeviceObj)
    Method(_SB.PCI0.HDEF._DSM, 4)
    {
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Return(Package()
        {
            "layout-id", Buffer(4) { 20, 0, 0, 0 },
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
            "14f1_2008", Package()
            {
                "PinConfigDefault", Package()
                {
                    Package(){},
                    Package()
                    {
                        "LayoutID", 20,
                        "PinConfigs", Package()
                        {
                            Package(){},
                            0x16, 0x012b1040,
                            0x17, 0x90170010,
                            0x19, 0x018b1030,
                            0x1a, 0x90a00020,
                        },
                    },
                },
                "Custom Commands", Package()
                {
                    Package(){},
                    Package()
                    {
                        "LayoutID", 20,
                        "Command", Buffer()
                        {
                            0x01, 0x77, 0x0c, 0x02,
                            0x01, 0x67, 0x0c, 0x02
                        },
                    },
                },
            },
        },
    })

//EOF
