DefinitionBlock("ssdt.aml", "SSDT", 2, "HPQOEM", "general", 0x00001000)
{
    External(_SB.PCI0.GFX0, DeviceObj)
    External(_SB.PCI0.RP04.WNIC, DeviceObj)
    
    Method(_SB.PCI0.GFX0._DSM, 4, NotSerialized)
    {
        If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
        Return (Package()
        {
            "AAPL00,DualLink", 
            Buffer() { 0x01, 0x00, 0x00, 0x00 },
            "AAPL,snb-platform-id",
            Buffer() { 0x00, 0x00, 0x01, 0x00 },
            "AAPL,ig-platform-id",
            Buffer (0x04) { 0x04, 0x00, 0x66, 0x01 },
        })
    }

    Method (_SB.PCI0.RP04.WNIC._DSM, 4, NotSerialized)
    {
        If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
        Return (Package()
        {
            "AAPL,slot-name",
            Buffer (0x08) { "AirPort" },
            "device-id", 
            Unicode ("*"),
            "device_type",
            Buffer (0x08) { "AirPort" },
            "model", 
            Buffer (0x33) { "Atheros 9285 802.11 b/g/n Wireless Network Adapter" },
            "subsystem-id", 
            Buffer (0x04) { 0x8F, 0x00, 0x00, 0x00 },
            "subsystem-vendor-id", 
            Buffer (0x04) { 0x6B, 0x10, 0x00, 0x00 },
        })
    }
}
