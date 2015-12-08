// Instead of providing patched DSDT/SSDT, just include a single SSDT
// and do the rest of the work in config.plist

// A bit experimental, and a bit more difficult with laptops, but
// still possible.

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
            Name(GIDL, Package()
            {
                // Sandy Bridge/HD3000
                0x0116, 0x0126, 0, Package()
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
                0x0166, 0, Package()
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
                0x0a1e, 0, Package()
                {
                    "model", Buffer() { "Intel HD Graphics 4200" },
                    "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                    "hda-gfx", Buffer() { "onboard-1" },
                    "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                },
                // Haswell/HD4400
                0x0a16, 0, Package()
                {
                    "model", Buffer() { "Intel HD Graphics 4400" },
                    "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                    "hda-gfx", Buffer() { "onboard-1" },
                    "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                },
                // Haswell/HD4600
                0x0416, 0, Package()
                {
                    "model", Buffer() { "Intel HD Graphics 4600" },
                    "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                    "hda-gfx", Buffer() { "onboard-1" },
                    "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                },
                // Haswell/HD5000/HD5100/HD5200
                0x0a26, 0x0a2e, 0x0d26, 0, Package()
                {
                    "hda-gfx", Buffer() { "onboard-1" },
                    "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                },
                // Broadwell/HD5300/HD5500/HD5600/HD6000
                0x161e, 0x1616, 0x1612, 0x1626, 0x162b, 0, Package()
                {
                    "hda-gfx", Buffer() { "onboard-1" },
                    "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
                },
            })

            // inject properties for integrated graphics on IGPU
            Method(_DSM, 4)
            {
                If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
                // search for matching device-id in device-id list
                Store(Match(GIDL, MEQ, GDID, MTR, 0, 0), Local0)
                If (LNotEqual(Local0, Ones))
                {
                    // start search for zero-terminator (prefix to injection package)
                    Increment(Local0)
                    Store(Match(GIDL, MEQ, 0, MTR, 0, Local0), Local0)
                    Increment(Local0)
                    Return (DerefOf(Index(GIDL,Local0)))
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
