// inject properties for audio

    External(_SB.PCI0.HDEF, DeviceObj)
    Method(_SB.PCI0.HDEF._DSM, 4)
    {
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Return(Package()
        {
            "layout-id", Buffer(4) { 3, 0, 0, 0 },
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
            "10ec_0282", Package()
            {
                "Custom Commands", Package()
                {
                    Package(){}, // signifies Array instead of Dictionary
                    Package()
                    {
                        // set pin configs for ALC282
                        "Command", Buffer()
                        {
                            0x01, 0x27, 0x1c, 0x10, 0x01, 0x27, 0x1d, 0x00, 0x01, 0x27, 0x1e, 0xa0, 0x01, 0x27, 0x1f, 0x99,
                            0x01, 0x47, 0x1c, 0x20, 0x01, 0x47, 0x1d, 0x00, 0x01, 0x47, 0x1e, 0x13, 0x01, 0x47, 0x1f, 0x99,
                            0x02, 0x17, 0x1c, 0x50, 0x02, 0x17, 0x1d, 0x10, 0x02, 0x17, 0x1e, 0x21, 0x02, 0x17, 0x1f, 0x01,
                            0x01, 0x47, 0x0c, 0x02, 0x02, 0x17, 0x0c, 0x02
                        },
                        "On Probe", ">y",
                    },
                },
            },
        },
    })

//EOF
