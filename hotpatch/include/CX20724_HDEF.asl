// Mirone version
#define LAYOUT_MIRONE 3

// InsanelyDeepak version
#define LAYOUT_INSANELYDEEPAK 13

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
            "RM,disable_FakePCIID", 1,
        })
    }

// CodecCommander configuration

    Name(_SB.PCI0.HDEF.RMCF, Package()
    {
        "//CodecCommanderProbeInit", Package()
        {
            "Version", 0x020600,
            "14f1_50f4", Package()
            {
                "PinConfigDefault", Package()
                {
                    Package(){},
                    Package()   // alternate Mirone version
                    {
                        "LayoutID", LAYOUT_MIRONE,
                        "PinConfigs", Package()
                        {
                            Package(){},
                            0x16, 0x02211010,
                            0x17, 0x91170020,
                            0x19, 0x02811030,
                            0x1a, 0x90a60040,
                        },
                    },
                    Package()   // InsanelyDeepak version
                    {
                        "LayoutID", LAYOUT_INSANELYDEEPAK,
                        "PinConfigs", Package()
                        {
                            Package(){},
                            0x17, 0x91170110,
                            0x19, 0x048b1030,
                            0x1a, 0x95a00120,
                            0x1d, 0x042b1040,
                        },
                    },
                },
            },
        },
    })

//EOF
