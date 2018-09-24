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
            "RM,disable_FakePCIID", 1,  //SKL spoof: remove or set zero
        })
    }

// CodecCommander configuration

    Name(_SB.PCI0.HDEF.RMCF, Package()
    {
        //REVIEW: seems like nonsense:
        //"CodecCommander", Package() { "Disable", ">y", },
        "CodecCommanderPowerHook", Package() { "Disable", ">y", },
        "//CodecCommanderProbeInit", Package()
        {
            "Version", 0x020600,
            "14f1_2008", Package()
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
                            0x16, 0x012b1040,
                            0x17, 0x90170010,
                            0x18, 0x400000f0,
                            0x19, 0x018b1030,
                            0x1a, 0x90a60020,
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
                            0x01, 0x77, 0x0c, 0x02,
                        },
                    },
                },
            },
        },
        //REVIEW (continued from above review): see.. should not have two "CodecCommander" configs!
        "CodecCommander", Package()
        {
            "Version", 0x00020600,
            "14f1_2008", Package()
            {
                "Custom Commands", Package()
                {
                    Package(){},
                    Package()
                    {
                        //Node 0x19 Set Pin Widget Control "In Enable", "VRefEn Signal Level 80%"
                        "Command", Buffer() { 0x01, 0x97, 0x07, 0x24 },
                        "On Init", ">y",
                        "On Sleep", ">n",
                        "On Wake", ">y",
                    },
                },
            },
        },
    })

//EOF
