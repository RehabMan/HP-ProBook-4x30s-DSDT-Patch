// fan/temperature readings only (fan behavior is BIOS)

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

    // This is created by 04c_FanSpeed.txt
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
    }
}
//EOF
