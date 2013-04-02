DefinitionBlock("ssdt-1.aml", "SSDT", 2, "HPQOEM", "general", 0x00001000)
{
    External(_SB.PCI0, DeviceObj)
    
    Device (_SB.PCI0.IMEI)
    {
        Name (_ADR, 0x00160000)
        Method (_DSM, 4, NotSerialized)
        {
            If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
            Return (Package()
            {
                "device-id",
                Buffer (0x04) { 0x3A, 0x1C, 0x00, 0x00 }
            })
        }
    }
}
