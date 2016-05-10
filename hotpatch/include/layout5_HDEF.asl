// inject properties for audio

    External(_SB.PCI0.HDEF, DeviceObj)
    Method(_SB.PCI0.HDEF._DSM, 4)
    {
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Return(Package()
        {
            "layout-id", Buffer(4) { 5, 0, 0, 0 },
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
            "14f1_50f4", Package()
            {
                "Custom Commands", Package()
                {
                    Package(){}, // signifies Array instead of Dictionary
                    Package()
                    {
                        // set pin configs for CX20724
                        "Command", Buffer()
                        {
                            0x01, 0x67, 0x1c, 0x10, 0x01, 0x67, 0x1d, 0x10, 0x01, 0x67, 0x1e, 0x21, 0x01, 0x67, 0x1f, 0x02,
                            0x01, 0x77, 0x1c, 0x20, 0x01, 0x77, 0x1d, 0x00, 0x01, 0x77, 0x1e, 0x17, 0x01, 0x77, 0x1f, 0x91,
                            0x01, 0x97, 0x1c, 0x30, 0x01, 0x97, 0x1d, 0x10, 0x01, 0x97, 0x1e, 0x81, 0x01, 0x97, 0x1f, 0x02,
                            0x01, 0xa7, 0x1c, 0x40, 0x01, 0xa7, 0x1d, 0x00, 0x01, 0xa7, 0x1e, 0xa6, 0x01, 0xa7, 0x1f, 0x90
                        },
                        "On Probe", ">y",
                    },
                },
            },
        },
    })

//EOF
