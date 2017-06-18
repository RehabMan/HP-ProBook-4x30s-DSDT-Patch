// "original" fan patch

DefinitionBlock ("", "SSDT", 2, "hack", "fan", 0)
{
    External(\_SB.PCI0, DeviceObj)
    External(\_SB.PCI0.LPCB, DeviceObj)
    External(\_SB.PCI0.LPCB.EC, DeviceObj)
    External(\_SB.PCI0.LPCB.EC.ECMX, MutexObj)
    External(\_SB.PCI0.LPCB.EC.CRZN, FieldUnitObj)
    External(\_SB.PCI0.LPCB.EC.TEMP, FieldUnitObj)
    External(\_SB.PCI0.LPCB.EC.FRDC, FieldUnitObj)
    External(\_SB.PCI0.LPCB.EC.DTMP, FieldUnitObj)
    External(\_SB.PCI0.LPCB.EC.FTGC, FieldUnitObj)
    External(\_SB.PCI0.LPCB.EC.ECRG, IntObj)

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
            If (!\_SB.PCI0.LPCB.EC.ECRG) { Return(0) }
            Local0 = \_SB.PCI0.LPCB.EC.FRDC
            If (Local0) { Local0 = (0x3C000 + (Local0 >> 1)) / Local0 }
            If (0x03C4 == Local0) { Return (0) }
            Return (Local0)
        }
        Method (TCPU, 0, Serialized)
        {
            If (!\_SB.PCI0.LPCB.EC.ECRG) { Return(0) }
            Acquire (\_SB.PCI0.LPCB.EC.ECMX, 0xFFFF)
            \_SB.PCI0.LPCB.EC.CRZN = 1
            Local0 = \_SB.PCI0.LPCB.EC.DTMP
            Release (\_SB.PCI0.LPCB.EC.ECMX)
            Return (Local0)
        }
        Method (TAMB, 0, Serialized)
        {
            If (!\_SB.PCI0.LPCB.EC.ECRG) { Return(0) }
            Acquire (\_SB.PCI0.LPCB.EC.ECMX, 0xFFFF)
            \_SB.PCI0.LPCB.EC.CRZN = 4
            Local0 = \_SB.PCI0.LPCB.EC.TEMP
            Release (\_SB.PCI0.LPCB.EC.ECMX)
            Return (Local0)
        }
        Method (FCPU, 0, Serialized)
        {
            If (!\_SB.PCI0.LPCB.EC.ECRG) { Return(0) }
            Local0 = TCPU()
            // Temp between 35 and 52: hold fan at lowest speed
            If (Local0 >= 35 && Local0 <= 52)
            {
                Acquire (\_SB.PCI0.LPCB.EC.ECMX, 0xFFFF)
                \_SB.PCI0.LPCB.EC.FTGC = 0x80
                Release (\_SB.PCI0.LPCB.EC.ECMX)
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
                    Acquire (\_SB.PCI0.LPCB.EC.ECMX, 0xFFFF)
                    \_SB.PCI0.LPCB.EC.FTGC = 0xFF
                    Release (\_SB.PCI0.LPCB.EC.ECMX)
                }
            }
            Return (Local0)
        }
    }
}
//EOF
