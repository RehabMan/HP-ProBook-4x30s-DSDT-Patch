// for laptops that need 87-key layout

//DefinitionBlock ("", "SSDT", 2, "hack", "key87", 0)
//{
    External(\_SB.PCI0, DeviceObj)
    External(\_SB.PCI0.LPCB, DeviceObj)

    External(\_SB.PCI0.LPCB.PS2K, DeviceObj)
    Scope (\_SB.PCI0.LPCB.PS2K)
    {
        // Select specific keyboard map in VoodooPS2Keyboard.kext
        Method(_DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            Return (Package()
            {
                "RM,oem-id", "HPQOEM",
                "RM,oem-table-id", "ProBook-87",
            })
        }
    }
//}

//EOF
