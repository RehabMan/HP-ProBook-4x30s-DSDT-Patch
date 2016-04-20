// "original" fan patch

DefinitionBlock ("", "SSDT", 2, "hack", "fan", 0)
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
            Local0 = \_SB.PCI0.LPCB.EC0.FRDC
            If (Local0) { Local0 = (0x3C000 + (Local0 >> 1)) / Local0 }
            If (0x03C4 == Local0) { Return (0) }
            Return (Local0)
        }
        Method (TCPU, 0, Serialized)
        {
            Acquire (\_SB.PCI0.LPCB.EC0.ECMX, 0xFFFF)
            \_SB.PCI0.LPCB.EC0.CRZN = 1
            Local0 = \_SB.PCI0.LPCB.EC0.DTMP
            Release (\_SB.PCI0.LPCB.EC0.ECMX)
            Return (Local0)
        }
        Method (TAMB, 0, Serialized)
        {
            Acquire (\_SB.PCI0.LPCB.EC0.ECMX, 0xFFFF)
            \_SB.PCI0.LPCB.EC0.CRZN = 4
            Local0 = \_SB.PCI0.LPCB.EC0.TEMP
            Release (\_SB.PCI0.LPCB.EC0.ECMX)
            Return (Local0)
        }
        Method (FCPU, 0, Serialized)
        {
            Local0 = TCPU()
            // Temp between 35 and 52: hold fan at lowest speed
            If (Local0 >= 35 && Local0 <= 52)
            {
                If (\_SB.PCI0.LPCB.EC0.ECRG)
                {
                    Acquire (\_SB.PCI0.LPCB.EC0.ECMX, 0xFFFF)
                    \_SB.PCI0.LPCB.EC0.FTGC = 0x80
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
                If (Local0 < 32 || Local0 >= 55)
                {
                    If (\_SB.PCI0.LPCB.EC0.ECRG)
                    {
                        Acquire (\_SB.PCI0.LPCB.EC0.ECMX, 0xFFFF)
                        \_SB.PCI0.LPCB.EC0.FTGC = 0xFF
                        Release (\_SB.PCI0.LPCB.EC0.ECMX)
                    }
                }
            }
            Return (Local0)
        }
    }
}
//EOF
