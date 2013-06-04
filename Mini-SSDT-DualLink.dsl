DefinitionBlock("ssdt.aml", "SSDT", 2, "HPQOEM", "general", 0x00001000)
{
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
            Buffer() { 0x04, 0x00, 0x66, 0x01 },
        })
    }
}
