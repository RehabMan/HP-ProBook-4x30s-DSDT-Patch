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
#ifdef QUIET
        // original quiet table by RehabMan
        Name(FTA1, Package()
        {
            50,  57,  63,  68,  72,  75, 0xFF
        })
        Name(FTA2, Package()
        {
            255,  128, 82,  74,  59,  49, 0,
        })
        Name (FCTU, 20)		// timeout for changes (fan rpm going up)
        Name (FCTD, 40)		// timeout for changes (fan rpm going down)
#endif
#ifdef REHABMAN
        // another alternate by RehabMan
        Name(FTA1, Package()
        {
             35,  57,  58,  59,  57,  60,  61,  62,  63,  64,
             65,  66,  67,  68,  69,  70,  71,  72,  73,  74,
             75, 0xFF
        })
        Name(FTA2, Package()
        {
            255, 128, 122, 115, 110, 109, 103,  96,  90,  87,
            85,   82,  80,  77,  73,  68,  64,  59,  56,  52,
            49, 0
        })
        Name (FCTU, 20)		// timeout for changes (fan rpm going up)
        Name (FCTD, 40)		// timeout for changes (fan rpm going down)
#endif
#ifdef GRAPPLER
        // Smooth fan table by Don_Grappler
        Name(FTA1, Package()
        {
            35,  42,  44,  45,  46,  47,  48,  49,  50,  51,
            52,  53,  54,  55,  56,  57,  58,  59,  60,  61,
            62,  63,  64,  65,  66,  67,  68,  69,  70,  71,
            72,  73,  0xFF,
        })
        Name(FTA2, Package()
        {
            255, 128, 127, 126, 125, 124, 123, 122, 121, 120,
            119, 118, 117, 116, 115, 113, 111, 109, 107, 102,
            99,  96,  93,  90,  86,  82,  78,  74,  70,  65,
            60,  55,   0,
        })
        Name (FCTU, 2) // timeout for changes (fan rpm going up)   --   modified by Don_Grappler
        Name (FCTD, 5) // timeout for changes (fan rpm going down)   --   modified by Don_Grappler
#endif
        // Table to keep track of past temperatures (to track average)
        Name (FHST, Buffer(16) { 0x0, 0, 0, 0, 0x0, 0, 0, 0, 0x0, 0, 0, 0, 0x0, 0, 0, 0 })
        Name (FIDX, 0) 	// current index in buffer above
        Name (FNUM, 0) 	// number of entries in above buffer to count in avg
        Name (FSUM, 0) 	// current sum of entries in buffer
        // Keeps track of last fan speed set, and counter to set new one
        Name (FLST, 0xFF)	// last index for fan control
        Name (FCNT, 0)		// count of times it has been "wrong", 0 means no counter

        // Fan control for CPU -- expects to be evaluated 1-per second
        Method(FCPU, 0)
        {
            Acquire(\_SB.PCI0.LPCB.EC0.ECMX, 0xFFFF)
            // setup fake temperature (this is the key to controlling the fan!)
            Store(1, \_SB.PCI0.LPCB.EC0.CRZN)  // select CPU temp
            Store(31, \_SB.PCI0.LPCB.EC0.TEMP) // write fake value there (31C)
            // get current temp into Local0 for eventual return
            // Note: reading from DTMP here instead of TEMP because we wrote
            //  a fake temp to TEMP to trick the system into running the fan
            //	at a lower speed than it otherwise would.
            Store(1, \_SB.PCI0.LPCB.EC0.CRZN)  // select CPU temp
            Store(\_SB.PCI0.LPCB.EC0.DTMP, Local0) // Local0 is current temp
            Release(\_SB.PCI0.LPCB.EC0.ECMX)

            // calculate average temperature
            Add(Local0, FSUM, Local1)
            Store(FIDX, Local2)
            Subtract(Local1, DerefOf(Index(FHST,Local2)), Local1)
            Store(Local0, Index(FHST,Local2))
            Store(Local1, FSUM)  // Local1 is new sum
            // adjust current index into temperature history table
            Increment(Local2)
            if (LGreaterEqual(Local2, SizeOf(FHST))) { Store(0, Local2) }
            Store(Local2, FIDX)
            // adjust total items collected in temp table
            Store(FNUM, Local2)
            if (LNotEqual(Local2, SizeOf(FHST)))
            {
                Increment(Local2)
                Store(Local2, FNUM)
            }
            // Local1 is new sum, Local2 is number of entries in sum
            Divide(Local1, Local2,, Local0)  // Local0 is now average temp

            // table based search (use avg temperature to search)
            if (LGreater(Local0, 255)) { Store(255, Local0) }
            Store(Match(FTA1, MGE, Local0, MTR, 0, 0), Local2)

            // calculate difference between current and found index
            if (LGreater(Local2, FLST))
            {
                Subtract(Local2, FLST, Local1)
                Store(FCTU, Local4)
            }
            else
            {
                Subtract(FLST, Local2, Local1)
                Store(FCTD, Local4)
            }

            // set new fan speed, if necessary
            if (LNot(Local1))
            {
                // no difference, so leave current fan speed and reset count
                Store(0, FCNT)
            }
            else
            {
                // there is a difference, start/continue process of changing fan
                Store(FCNT, Local3)
                Increment(FCNT)
                // how long to wait depends on how big the difference
                // 20 secs if diff is 2, 5 secs if diff is 4, etc.
                Divide(Local4, Local1,, Local1)
                if (LGreaterEqual(Local3, Local1))
                {
                    // timeout expired, so set new fan speed
                    Store(Local2, FLST)
                    Store(DerefOf(Index(FTA2,Local2)), \_SB.PCI0.LPCB.EC0.FTGC)
                    Store(0, FCNT)
                }
            }
            Return (Local0)  // returns average temp
        }
    }
}

//EOF
