// inject properties for HDMI audio

    External(_SB.PCI0.HDAU, DeviceObj)
    Method(_SB.PCI0.HDAU._DSM, 4)
    {
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Return(Package()
        {
            "layout-id", Buffer(4) { 6, 0, 0, 0 },
            "hda-gfx", Buffer() { "onboard-1" },
        })
    }

//EOF
