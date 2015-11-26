// Instead of providing patched DSDT/SSDT, just include a single SSDT
// and do the rest of the work in config.plist

// A bit experimental, and a bit more difficult with laptops, but
// still possible.

// ObjectType return values per ACPI spec
#define OBJECTTYPE_INTEGER 1
#define OBJECTTYPE_PACKAGE 4

DefinitionBlock ("SSDT-IGPU.aml", "SSDT", 1, "hack", "igpu", 0x00003000)
{
    External(\_SB.PCI0, DeviceObj)
    Scope (\_SB.PCI0)
    {
        External(IGPU, DeviceObj)
        Scope(IGPU)
        {
            // need the device-id from PCI_config to inject correct properties
            OperationRegion(IGD4, PCI_Config, 2, 2)
            Field(IGD4, AnyAcc, NoLock, Preserve)
            {
                GDID,16
            }

            // inject properties for integrated graphics on IGPU
            Method(_DSM, 4)
            {
                If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
                Store(Package()
                {
                    // Sandy Bridge/HD3000
                    Package() { 0x0116, 0x0126, }, Package()
                    {
                        "model", Buffer() { "Intel HD Graphics 3000" },
                        "hda-gfx", Buffer() { "onboard-1" },
                        "AAPL,snb-platform-id", Buffer() { 0x00, 0x00, 0x21, 0x00 },
                        "AAPL,os-info", Buffer() { 0x30, 0x49, 0x01, 0x11, 0x11, 0x11, 0x08, 0x00, 0x00, 0x01, 0xf0, 0x1f, 0x01, 0x00, 0x00, 0x00, 0x10, 0x07, 0x00, 0x00 },
                        #ifdef HIRES
                        "AAPL,DualLink", Buffer() { 0x01, 0x00, 0x00, 0x00 },         //900p/1080p
                        #endif
                    },
                    // Ivy Bridge/HD4000
                    0x0166, Package()
                    {
                        "model", Buffer() { "Intel HD Graphics 4000" },
                        "hda-gfx", Buffer() { "onboard-1" },
                        #ifndef HIRES
                        "AAPL,ig-platform-id", Buffer() { 0x03, 0x00, 0x66, 0x01 },   //768p
                        #else
                        "AAPL,ig-platform-id", Buffer() { 0x04, 0x00, 0x66, 0x01 },   //900p/1080p
                        #endif
                    },
                    // Haswell/HD4200
                    0x0a1e, Package()
                    {
                        "model", Buffer() { "Intel HD Graphics 4200" },
                        "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                        "hda-gfx", Buffer() { "onboard-1" },
                        "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                    },
                    // Haswell/HD4400
                    0x0a16, Package()
                    {
                        "model", Buffer() { "Intel HD Graphics 4400" },
                        "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                        "hda-gfx", Buffer() { "onboard-1" },
                        "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                    },
                    // Haswell/HD4600
                    0x0416, Package()
                    {
                        "model", Buffer() { "Intel HD Graphics 4600" },
                        "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                        "hda-gfx", Buffer() { "onboard-1" },
                        "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                    },
                    // Haswell/HD5000/HD5100/HD5200
                    Package() { 0x0a26, 0x0a2e, 0x0d26, }, Package()
                    {
                        "hda-gfx", Buffer() { "onboard-1" },
                        "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                    },
                    // Broadwell/HD5300/HD5500/HD5600/HD6000
                    Package() { 0x161e, 0x1616, 0x1612, 0x1626, 0x162b, }, Package()
                    {
                        "hda-gfx", Buffer() { "onboard-1" },
                        "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
                    },
                }, Local4)

                // looking for Local3 in Local4 array
                // Local2 is scratch
                // Local0 is current index
                // Local1 is size of array

                // search for package that matches device-id
                Store(GDID, Local3)
                Store(0, Local0)
                Store(SizeOf(Local4), Local1)
                While (LLess(Local0, Local1))
                {
                    // Local2 is object at current index
                    // Local5 is the type of that object
                    Store(DerefOf(Index(Local4,Local0)), Local2)
                    Store(ObjectType(Local2), Local5)
                    Increment(Local0) // Local0 now at result package entry
                    If (LEqual(OBJECTTYPE_INTEGER, Local5))
                    {
                        If (LEqual(Local3, Local2)) // matching device-id?
                        {
                            // Local0 already points to return package
                            Return (DerefOf(Index(Local4,Local0)))
                        }
                    }
                    ElseIf (LEqual(OBJECTTYPE_PACKAGE, Local5))
                    {
                        // Local6 is current index in subpackage
                        // Local7 is size of the subpackage
                        Store(0, Local6)
                        Store(SizeOf(Local2), Local7)
                        While (LLess(Local6, Local7))
                        {
                            If (LEqual(Local3, DerefOf(Index(Local2,Local6))))
                            {
                                // Local0 already points to return package
                                Return (DerefOf(Index(Local4,Local0)))
                            }
                            Increment(Local6)
                        }
                    }
                    Increment(Local0)
                }

                // should never happen, but inject nothing in this case
                Return (Package() { })
            }
        }

        Device(IMEI)
        {
            Name(_ADR, 0x00160000)

            // deal with mixed system, HD3000/7-series, HD4000/6-series
            OperationRegion(MMD4, PCI_Config, 2, 2)
            Field(MMD4, AnyAcc, NoLock, Preserve)
            {
                MDID,16
            }
            Method(_DSM, 4, Serialized)
            {
                If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
                Store(^^IGPU.GDID, Local1)
                Store(MDID, Local2)
                If (0x0166 == Local1 && 0x1c3a == Local2)
                {
                    // HD4000 on 6-series, inject 7-series IMEI device-id
                    Return (Package() { "device-id", Buffer() { 0x3a, 0x1e, 0, 0 } })
                }
                ElseIf ((0x0116 == Local1 || 0x0126 == Local1) && 0x1e3a == Local2)
                {
                    // HD3000 on 7-series, inject 6-series IMEI device-id
                    Return (Package() { "device-id", Buffer() { 0x3a, 0x1c, 0, 0 } })
                }
                Return (Package(){})
            }
        }
    }
}

//EOF
