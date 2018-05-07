// "quiet" fan patch

DefinitionBlock("", "SSDT", 2, "hack", "_FANQ", 0)
{
    External(\_SB.PCI0, DeviceObj)
    External(\_SB.PCI0.LPCB, DeviceObj)
    External(\_SB.PCI0.LPCB.EC, DeviceObj)
    External(\_SB.PCI0.LPCB.EC.ECMX, MutexObj)
    External(\_SB.PCI0.LPCB.EC.CRZN, FieldUnitObj)
    External(\_SB.PCI0.LPCB.EC.TEMP, FieldUnitObj)

    // This is created by 04b_FanQuietMod.txt
    // It is my preferred Fan patch
    Device (SMCD)
    {
        External(\_SB.PCI0.LPCB.EC.FRDC, FieldUnitObj)
        External(\_SB.PCI0.LPCB.EC.DTMP, FieldUnitObj)
        External(\_SB.PCI0.LPCB.EC.FTGC, FieldUnitObj)
        External(\_SB.PCI0.LPCB.EC.ECRG, IntObj)
        
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
#ifdef DEBUG
            "Mainboard", "TSYS",
            "CPU Proximity", "TCPP",
#endif
        })
        // Actual methods to implement fan/temp readings/control
        Method (FAN0, 0, Serialized)
        {
            If (!\_SB.PCI0.LPCB.EC.ECRG) { Return(0) }
            Local0 = \_SB.PCI0.LPCB.EC.FRDC
            If (Local0) { Divide (Add(0x3C000, ShiftRight(Local0,1)), Local0,, Local0) }
            If (0x03C4 == Local0) { Return (Zero) }
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
#ifdef DEBUG
        // for debugging fan control\n
        Method (TCPP, 0, Serialized)  // Average temp\n
        {
            Local0 = FNUM
            if (Local0) { Local0 = FSUM / Local0 }
            Return (Local0)
        }
        Method (TSYS, 0, Serialized)  // fan counter\n
        {
            Return (FCNT)
        }
#endif
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
             /*35,*/  57,  58,  59,  57,  60,  61,  62,  63,  64,
             65,  66,  67,  68,  69,  70,  71,  72,  73,  74,
             75, 0xFF
        })
        Name(FTA2, Package()
        {
            /*255,*/ 128, 122, 115, 110, 109, 103,  96,  90,  87,
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
            If (!\_SB.PCI0.LPCB.EC.ECRG) { Return(0) }
            Acquire(\_SB.PCI0.LPCB.EC.ECMX, 0xFFFF)
            // setup fake temperature (this is the key to controlling the fan!)
            \_SB.PCI0.LPCB.EC.CRZN = 1  // select CPU temp
            \_SB.PCI0.LPCB.EC.TEMP = 31 // write fake value there (31C)
            // get current temp into Local0 for eventual return
            // Note: reading from DTMP here instead of TEMP because we wrote
            //  a fake temp to TEMP to trick the system into running the fan
            //	at a lower speed than it otherwise would.
            \_SB.PCI0.LPCB.EC.CRZN = 1  // select CPU temp
            Local0 = \_SB.PCI0.LPCB.EC.DTMP // Local0 is current temp
            Release(\_SB.PCI0.LPCB.EC.ECMX)

            // calculate average temperature
            Local1 = Local0 + FSUM
            Local2 = FIDX
            Local1 -= DerefOf(FHST[Local2])
            FHST[Local2] = Local0
            FSUM = Local1  // Local1 is new sum
            // adjust current index into temperature history table
            Local2++
            if (Local2 >= SizeOf(FHST)) { Local2 = 0 }
            FIDX = Local2
            // adjust total items collected in temp table
            Local2 = FNUM
            if (Local2 != SizeOf(FHST))
            {
                Local2++
                FNUM = Local2
            }
            // Local1 is new sum, Local2 is number of entries in sum
            Local0 = Local1 / Local2 // Local0 is now average temp

            // table based search (use avg temperature to search)
            if (Local0 > 255) { Local0 = 255 }
            Local2 = Match(FTA1, MGE, Local0, MTR, 0, 0)

            // calculate difference between current and found index
            if (Local2 > FLST)
            {
                Local1 = Local2 - FLST
                Local4 = FCTU
            }
            else
            {
                Local1 = FLST - Local2
                Local4 = FCTD
            }

            // set new fan speed, if necessary
            if (!Local1)
            {
                // no difference, so leave current fan speed and reset count
                FCNT = 0
            }
            else
            {
                // there is a difference, start/continue process of changing fan
                Local3 = FCNT
                FCNT++
                // how long to wait depends on how big the difference
                // 20 secs if diff is 2, 5 secs if diff is 4, etc.
                Local1 = Local4 / Local1
                if (Local3 >= Local1)
                {
                    // timeout expired, so set new fan speed
                    FLST = Local2
                    \_SB.PCI0.LPCB.EC.FTGC = DerefOf(FTA2[Local2])
                    FCNT = 0
                }
            }
            Return (Local0)  // returns average temp
        }
    }
}

//EOF
