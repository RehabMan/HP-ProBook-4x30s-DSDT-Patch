DefinitionBlock("", "SSDT", 2, "HPQOEM", "general", 0x00001000)
{
    Method(_SB.PCI0.GFX0._DSM, 4, NotSerialized)
    {
        If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
        Return (Package()
        {
            "device-id", Buffer() { 0x22, 0x01, 0x00, 0x00 },
            "compatible", Buffer() { "pci8086,122" },
            "name", Buffer() { "pci8086,122" },
        })
    }
}

