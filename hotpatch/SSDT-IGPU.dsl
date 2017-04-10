// IGPU injections for Intel graphics

DefinitionBlock ("", "SSDT", 2, "hack", "igpu", 0)
{
    //
    // IGPU injection
    // From SSDT-IGPU.dsl
    //
    External(_SB.PCI0.IGPU, DeviceObj)
    Scope(_SB.PCI0.IGPU)
    {
        // need the device-id from PCI_config to inject correct properties
        OperationRegion(IGD4, PCI_Config, 0, 0x14)
        Field(IGD4, AnyAcc, NoLock, Preserve)
        {
            Offset(0x02), GDID,16,
            Offset(0x10), BAR1,32,
        }
        Name(GIDL, Package()
        {
            // Sandy Bridge/HD3000
            0x0116, 0x0126, 0, Package()
            {
                "model", Buffer() { "Intel HD Graphics 3000" },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,snb-platform-id", Buffer() { 0x00, 0x00, 0x01, 0x00 },
                "AAPL,os-info", Buffer() { 0x30, 0x49, 0x01, 0x11, 0x11, 0x11, 0x08, 0x00, 0x00, 0x01, 0xf0, 0x1f, 0x01, 0x00, 0x00, 0x00, 0x10, 0x07, 0x00, 0x00 },
                #ifdef HIRES
                "AAPL00,DualLink", Buffer() { 0x01, 0x00, 0x00, 0x00 },       //900p/1080p
                #else
                "AAPL00,DualLink", Buffer() { 0x00, 0x00, 0x00, 0x00 },       //768p
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
            // Broadwell/HD5300
            0x161e, 0, Package()
            {
                "model", Buffer() { "Intel HD Graphics 5300" },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
            },
            // Broadwell/HD5500
            0x1616, 0, Package()
            {
                "model", Buffer() { "Intel HD Graphics 5500" },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
            },
            // Broadwell/HD5600
            0x1612, 0, Package()
            {
                "model", Buffer() { "Intel HD Graphics 5600" },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
            },
            // Broadwell/HD6000/HD6100/HD6200
            0x1626, 0x162b, 0x1622, 0, Package()
            {
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
            },
            // Skylake/HD520
            0x1916, 0, Package()
            {
                "model", Buffer() { "Intel HD Graphics 520" },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x16, 0x19 },
                "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
            },
            // Skylake/HD530
            0x191b, 0, Package()
            {
                "model", Buffer() { "Intel HD Graphics 530" },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1b, 0x19 },
                "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
            },
            // Skylake/P530
            0x191d, 0, Package()
            {
                "model", Buffer() { "Intel HD Graphics P530" },
                "device-id", Buffer() { 0x1b, 0x19, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1b, 0x19 },
                "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
            },
            // Kaby Lake/HD620
            0x5916, 0, Package()
            {
                "model", Buffer() { "Intel HD Graphics 620" },
                "device-id", Buffer() { 0x1b, 0x19, 0x00, 0x00 },
                //"hda-gfx", Buffer() { "onboard-1" },
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1b, 0x19 },
                "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
            },
            // Kaby Lake/HD630
            0x5912, 0x591b, 0, Package()
            {
                "model", Buffer() { "Intel HD Graphics 630" },
                "device-id", Buffer() { 0x1b, 0x19, 0x00, 0x00 },
                //"hda-gfx", Buffer() { "onboard-1" },
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1b, 0x19 },
                "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
            },
        })

        // inject properties for integrated graphics on IGPU
        Method(_DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            // search for matching device-id in device-id list
            Local0 = Match(GIDL, MEQ, GDID, MTR, 0, 0)
            If (Ones != Local0)
            {
                // start search for zero-terminator (prefix to injection package)
                Local0 = Match(GIDL, MEQ, 0, MTR, 0, Local0+1)
                Return (DerefOf(GIDL[Local0+1]))
            }
            // should never happen, but inject nothing in this case
            Return (Package() { })
        }
    }

    Device(_SB.PCI0.IMEI)
    {
        Name(_ADR, 0x00160000)

        // deal with mixed system, HD3000/7-series, HD4000/6-series
        OperationRegion(MMD4, PCI_Config, 2, 2)
        Field(MMD4, AnyAcc, NoLock, Preserve)
        {
            MDID,16
        }
        Method(_DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            Local1 = ^^IGPU.GDID
            Local2 = MDID
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

//EOF
