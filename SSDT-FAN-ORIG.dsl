// Instead of providing patched DSDT/SSDT, just include a single SSDT
// and do the rest of the work in config.plist

// A bit experimental, and a bit more difficult with laptops, but
// still possible.

DefinitionBlock ("SSDT-FAN-ORIG.aml", "SSDT", 1, "hack", "fan", 0x00003000)
{
    External(\_SB.PCI0, DeviceObj)
    External(\_SB.PCI0.LPCB, DeviceObj)
    External(\_SB.PCI0.LPCB.EC0, DeviceObj)
    External(\_SB.PCI0.LPCB.EC0.ECMX, MutexObj)
    External(\_SB.PCI0.LPCB.EC0.CRZN, FieldUnitObj)
    External(\_SB.PCI0.LPCB.EC0.TEMP, FieldUnitObj)
    External(\_SB.PCI0.LPCB.EC0.FRDC, FieldUnitObj)
    External(\_SB.PCI0.LPCB.EC0.DTMP, FieldUnitObj)
    External(\_SB.PCI0.LPCB.EC0.FTGC, FieldUnitObj)
    External(\_SB.PCI0.LPCB.EC0.ECRG, FieldUnitObj)

    // This is created by 04a_FanPatch.txt
    Device (SMCD)
    {
        Name (_HID, "FAN00000") // _HID: Hardware ID
        // ACPISensors.kext configuration
        Name (TACH, Package()
        {
            "System Fan", "FAN0",
        })
        Name (TEMP, Package()
        {
            "CPU Heatsink", "TCPU",
            "Ambient", "TAMB",
            //"Mainboard", "TSYS",
            //"CPU Proximity", "TCPP",
        })
        // Actual methods to implement fan/temp readings/control
        Method (FAN0, 0, Serialized)
        {
            Store (\_SB.PCI0.LPCB.EC0.FRDC, Local0)
            If (Local0) { Divide (Add(0x3C000, ShiftRight(Local0,1)), Local0,, Local0) }
            If (LEqual (0x03C4, Local0)) { Return (Zero) }
            Return (Local0)
        }
        Method (TCPU, 0, Serialized)
        {
            Acquire (\_SB.PCI0.LPCB.EC0.ECMX, 0xFFFF)
            Store (1, \_SB.PCI0.LPCB.EC0.CRZN)
            Store (\_SB.PCI0.LPCB.EC0.DTMP, Local0)
            Release (\_SB.PCI0.LPCB.EC0.ECMX)
            Return (Local0)
        }
        Method (TAMB, 0, Serialized)
        {
            Acquire (\_SB.PCI0.LPCB.EC0.ECMX, 0xFFFF)
            Store (4, \_SB.PCI0.LPCB.EC0.CRZN)
            Store (\_SB.PCI0.LPCB.EC0.TEMP, Local0)
            Release (\_SB.PCI0.LPCB.EC0.ECMX)
            Return (Local0)
        }
        Method (FCPU, 0, Serialized)
        {
            Store (TCPU(), Local0)
            // Temp between 35 and 52: hold fan at lowest speed
            If (And (LGreaterEqual (Local0, 35), LLessEqual (Local0, 52)))
            {
                If (\_SB.PCI0.LPCB.EC0.ECRG)
                {
                    Acquire (\_SB.PCI0.LPCB.EC0.ECMX, 0xFFFF)
                    Store (0x80, \_SB.PCI0.LPCB.EC0.FTGC)
                    Release (\_SB.PCI0.LPCB.EC0.ECMX)
                }
            }
            Else
            {
                // Temp 31 or lower, or above 54: put fan into "automatic mode"
                // Note: for temps 32, 33, 34 fan stays in whatever mode it was
                //  in previously.
                // Note: for temps 53, 54 fan stays in whatever mode it was in
                //  previously.
                If (Or (LLess (Local0, 32), LGreaterEqual (Local0, 55)))
                {
                    If (\_SB.PCI0.LPCB.EC0.ECRG)
                    {
                        Acquire (\_SB.PCI0.LPCB.EC0.ECMX, 0xFFFF)
                        Store (0xFF, \_SB.PCI0.LPCB.EC0.FTGC)
                        Release (\_SB.PCI0.LPCB.EC0.ECMX)
                    }
                }
            }
            Return (Local0)
        }
    }
}
//EOF
