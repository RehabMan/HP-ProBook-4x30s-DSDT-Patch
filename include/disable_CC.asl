// disable CodecCommander.kext

    External(_SB.PCI0.HDEF, DeviceObj)
    Name(_SB.PCI0.HDEF.RMCF, Package()
    {
        "CodecCommander", Package()
        {
            "Disabled", ">y",
        },
        "CodecCommanderPowerHook", Package()
        {
            "Disabled", ">y",
        },
    })
