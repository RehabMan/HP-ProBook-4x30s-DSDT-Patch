#define LAYOUTID 3

// inject properties for audio

    External(_SB.PCI0.HDEF, DeviceObj)
    Method(_SB.PCI0.HDEF._DSM, 4)
    {
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Return(Package()
        {
            "layout-id", Buffer(4) { LAYOUTID, 0, 0, 0 },
            "hda-gfx", Buffer() { "onboard-1" },
            "PinConfigurations", Buffer() { },
        })
    }

// CodecCommander configuration

    Name(_SB.PCI0.HDEF.RMCF, Package()
    {
        "//CodecCommanderProbeInit", Package()
        {
            "Version", 0x020600,
            "10ec_0286", Package()
            {
                "PinConfigDefault", Package()
                {
                    Package(){},
                    Package()
                    {
                        "LayoutID", LAYOUTID,
                        "PinConfigs", Package()
                        {
                            Package(){},
                            0x12, 0xb0a60010,
                            0x14, 0x90170020,
                            0x18, 0x048b1030,
                            0x21, 0x042b1040,
                        },
                    },
                },
                "Custom Commands", Package()
                {
                    Package(){},
                    Package()
                    {
                        "LayoutID", LAYOUTID,
                        "Command", Buffer()
                        {
                            0x01, 0x47, 0x0c, 0x02
                        },
                    },
                },
            },
        },
    })

//EOF
