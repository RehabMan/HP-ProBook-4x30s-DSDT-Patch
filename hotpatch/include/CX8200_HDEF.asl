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
        "CodecCommander", Package()
        {
            "Version", 0x020600,
            "14f1_2008", Package()
            {
                // the reset options must be disabled for use with AppleALC.kext
                "Perform Reset", ">n",
                "Perform Reset on External Wake", ">n",
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
