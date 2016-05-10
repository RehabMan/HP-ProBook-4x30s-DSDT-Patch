// Disable native HECI (Intel MEI) identity by injecting _STA=0

    External(_SB.PCI0.HECI, DeviceObj)
    Name(_SB.PCI0.HECI._STA, 0)

//EOF
