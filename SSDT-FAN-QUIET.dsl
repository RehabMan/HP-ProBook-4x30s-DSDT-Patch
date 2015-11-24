// Instead of providing patched DSDT/SSDT, just include a single SSDT
// and do the rest of the work in config.plist

// A bit experimental, and a bit more difficult with laptops, but
// still possible.

DefinitionBlock ("SSDT-FAN-QUIET.aml", "SSDT", 1, "hack", "fan", 0x00003000)
{
    External(\_SB.PCI0, DeviceObj)
    External(\_SB.PCI0.LPCB, DeviceObj)
    External(\_SB.PCI0.LPCB.EC0, DeviceObj)
    External(\_SB.PCI0.LPCB.EC0.ECMX, MutexObj)
    External(\_SB.PCI0.LPCB.EC0.CRZN, FieldUnitObj)
    External(\_SB.PCI0.LPCB.EC0.TEMP, FieldUnitObj)

    // This is created by 04b_FanQuietMod.txt
    // It is my preferred Fan patch
    Device (SMCD)
    {
        External(\_SB.PCI0.LPCB.EC0.FRDC, FieldUnitObj)
        External(\_SB.PCI0.LPCB.EC0.DTMP, FieldUnitObj)
        External(\_SB.PCI0.LPCB.EC0.FTGC, FieldUnitObj)
        
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
            "Mainboard", "TSYS",
            "CPU Proximity", "TCPP",
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
        // Fan Control Table (pairs of temp, fan control byte)
        Name (FTAB, Buffer()
        {
            35, 255,  // commented this out to have always on
            57, 128,
            58, 122,
            59, 115,
            57, 115,
            60, 109,
            61, 103,
            62, 96,
            63, 90,
            64, 87,
            65, 85,
            66, 82,
            67, 80,
            68, 77,
            69, 73,
            70, 68,
            71, 64,
            72, 59,
            73, 56,
            74, 52,
            75, 49,
            0xFF, 0
        })
        // Table to keep track of past temperatures (to track average)
        Name (FHST, Buffer(16) { 0x0, 0, 0, 0, 0x0, 0, 0, 0, 0x0, 0, 0, 0, 0x0, 0, 0, 0 })
        Name (FIDX, Zero) 	// current index in buffer above
        Name (FNUM, Zero) 	// number of entries in above buffer to count in avg
        Name (FSUM, Zero) 	// current sum of entries in buffer
        // Keeps track of last fan speed set, and counter to set new one
        Name (FLST, 0xFF)	// last index for fan control
        Name (FCNT, 0)		// count of times it has been "wrong", 0 means no counter
        Name (FCTU, 20)		// timeout for changes (fan rpm going up)
        Name (FCTD, 40)		// timeout for changes (fan rpm going down)
        // Fan control for CPU -- expects to be evaluated 1-per second
        Method (FCPU, 0, Serialized)
        {
            Acquire (\_SB.PCI0.LPCB.EC0.ECMX, 0xFFFF)
            // setup fake temperature (this is the key to controlling the fan!)
            Store (1, \_SB.PCI0.LPCB.EC0.CRZN)  // select CPU temp
            Store (31, \_SB.PCI0.LPCB.EC0.TEMP) // write fake value there (31C)
            // get current temp into Local0 for eventual return
            // Note: reading from DTMP here instead of TEMP because we wrote
            //  a fake temp to TEMP to trick the system into running the fan
            //	at a lower speed than it otherwise would.
            Store (1, \_SB.PCI0.LPCB.EC0.CRZN)  // select CPU temp
            Store (\_SB.PCI0.LPCB.EC0.DTMP, Local0) // Local0 is current temp
            // calculate average temperature
            Add (Local0, FSUM, Local1)
            Store (FIDX, Local2)
            Subtract (Local1, DerefOf (Index (FHST, Local2)), Local1)
            Store (Local0, Index (FHST, Local2))
            Store (Local1, FSUM)  // Local1 is new sum
            // adjust current index into temp table
            Increment (Local2)
            if (LGreaterEqual (Local2, SizeOf(FHST))) { Store (0, Local2) }
            Store (Local2, FIDX)
            // adjust total items collected in temp table
            Store (FNUM, Local2)
            if (LNotEqual (Local2, SizeOf (FHST)))
            {
                Increment (Local2)
                Store (Local2, FNUM)
            }
            // Local1 is new sum, Local2 is number of entries in sum
            Divide (Local1, Local2,, Local0)  // Local0 is now average temp
            // table based search (use avg temperature to search)
            if (LGreater (Local0, 255)) { Store (255, Local0) }
            Store (Zero, Local2)
            while (LGreater (Local0, DerefOf (Index (FTAB, Local2)))) { Add (Local2, 2, Local2) }
            // calculate difference between current and found index
            if (LGreater (Local2, FLST))
            {
                Subtract(Local2, FLST, Local1)
                Store(FCTU, Local4)
            }
            Else
            {
                Subtract(FLST, Local2, Local1)
                Store(FCTD, Local4)
            }
            // set new fan speed, if necessary
            if (LEqual (Local1, 0))
            {
                // no difference, so leave current fan speed and reset count
                Store (0, FCNT)
            }
            Else
            {
                // there is a difference, start/continue process of changing fan
                Store (FCNT, Local3)
                Increment (Local3)
                Store (Local3, FCNT)
                // how long to wait depends on how big the difference
                // 20 secs if diff is 2, 5 secs if diff is 4, etc.
                Divide (ShiftLeft (Local4, 1), Local1,, Local1)
                if (LGreaterEqual (Local3, Local1))
                {
                    // timeout expired, so set new fan speed
                    Store (Local2, FLST)
                    Increment (Local2)
                    Store (DerefOf (Index (FTAB, Local2)), \_SB.PCI0.LPCB.EC0.FTGC)
                    Store (0, FCNT)
                }
            }
            Release (\_SB.PCI0.LPCB.EC0.ECMX)
            return (Local0)  // returns average temp
        }
        // for debugging fan control
        Method (TCPP, 0, Serialized)  // Average temp
        {
            Store (FNUM, Local0)
            if (LNotEqual (Local0, 0))
            {
                Store (FSUM, Local1)
                Divide (Local1, Local0,, Local0)
            }
            Return (Local0)
        }
        Method (TSYS, 0, Serialized)  // fan counter
        {
            Return (FCNT)
        }
    }
}

//EOF
