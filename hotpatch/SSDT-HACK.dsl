// Instead of providing patched DSDT/SSDT, just include a add-on
// SSDTs and the rest of the work done in config.plist.

// A bit experimental, and a bit more difficult with laptops, but
// still possible.

DefinitionBlock ("", "SSDT", 2, "hack", "hack", 0)
{
    External(\_SB.PCI0, DeviceObj)

//
// Configuration data
//
    Device(RMCF)
    {
        Name(_ADR, 0)   // do not remove
        Method(HELP)
        {
            Store("DGPU indicates whether discrete GPU should be disabled. 1: yes, 0: no", Debug)
            Store("BKLT indicates the type of backlight control. 0: IntelBacklight, 1: AppleBacklight", Debug)
            Store("LMAX indicates max for IGPU PWM backlight. Ones: Use default, other values must match framebuffer", Debug)
            Store("SHUT enables shutdown fix. 1: disables _PTS code when Arg0==5", Debug)
        }

        // DGPU: Controls whether the DGPU is disabled via ACPI or not
        // 1: (default) DGPU is disabled at startup, enabled in _PTS, disabled in _WAK
        // 0: DGPU is not manipulated
        Name(DGPU, 1)

        // BKLT: Backlight control type
        //
        // 0: Using IntelBacklight.kext
        // 1: Using AppleBacklight.kext + AppleBacklightInjector.kext
        Name(BKLT, 1)

        // LMAX: Backlight PWM MAX.  Must match framebuffer in use.
        //
        // Ones: Default will be used (0x710 for Ivy/Sandy, 0xad9 for Haswell/Broadwell)
        // Other values: must match framebuffer
        Name(LMAX, Ones)

        // SHUT: Shutdown fix, disable _PTS code when Arg0==5 (shutdown)
        //
        //  0: does not affect _PTS behavior during shutdown
        //  1: disables _PTS code during shutdown
        Name(SHUT, 1)
    }

//
// Simulate Windows for _OSI calls
//
    // All _OSI calls in DSDT are routed to XOSI...
    // XOSI simulates "Windows 2009" (which is Windows 7)
    // Note: According to ACPI spec, _OSI("Windows") must also return true
    //  Also, it should return true for all previous versions of Windows.
    Method(XOSI, 1)
    {
        // simulation targets
        // source: (google 'Microsoft Windows _OSI')
        //  http://download.microsoft.com/download/7/E/7/7E7662CF-CBEA-470B-A97E-CE7CE0D98DC2/WinACPI_OSI.docx
        Local0 = Package()
        {
            "Windows",              // generic Windows query
            "Windows 2001",         // Windows XP
            "Windows 2001 SP2",     // Windows XP SP2
            //"Windows 2001.1",     // Windows Server 2003
            //"Windows 2001.1 SP1", // Windows Server 2003 SP1
            "Windows 2006",         // Windows Vista
            "Windows 2006 SP1",     // Windows Vista SP1
            "Windows 2006.1",       // Windows Server 2008
            "Windows 2009",         // Windows 7/Windows Server 2008 R2
            //"Windows 2012",       // Windows 8/Windows Server 2012
            //"Windows 2013",       // Windows 8.1/Windows Server 2012 R2
            //"Windows 2015",       // Windows 10/Windows Server TP
        }
        Return (Ones != Match(Local0, MEQ, Arg0, MTR, 0, 0))
    }

//
// DGPU disable (and related shutdown fix)
//
    External(\_SB_.PCI0.PEGP.DGFX._OFF, MethodObj)
    External(\_SB_.PCI0.PEGP.DGFX._ON, MethodObj)
    External(\_SB_.PCI0.PEG0.PEGP._OFF, MethodObj)
    External(\_SB_.PCI0.PEG0.PEGP._ON, MethodObj)
    External(\_SB_.PCI0.RP05.DGFX._OFF, MethodObj)
    External(\_SB_.PCI0.RP05.DGFX._ON, MethodObj)
    External(\_SB_.PCI0.RP01.PEGP._OFF, MethodObj)
    External(\_SB_.PCI0.RP01.PEGP._ON, MethodObj)
    External(\_SB_.PCI0.RP01.PXSX._OFF, MethodObj)
    External(\_SB_.PCI0.RP01.PXSX._ON, MethodObj)

    // In DSDT, native _PTS and _WAK are renamed ZPTS/ZWAK
    // As a result, calls to these methods land here.
    Method(_PTS, 1)
    {
        If (\RMCF.SHUT && 5 == Arg0) { Return }
        If (1 == \RMCF.DGPU)
        {
            If (CondRefOf(\_SB_.PCI0.PEGP.DGFX._ON)) { \_SB_.PCI0.PEGP.DGFX._ON() }
            If (CondRefOf(\_SB_.PCI0.PEG0.PEGP._ON)) { \_SB_.PCI0.PEG0.PEGP._ON() }
            If (CondRefOf(\_SB_.PCI0.RP05.DGFX._ON)) { \_SB_.PCI0.RP05.DGFX._ON() }
            If (CondRefOf(\_SB_.PCI0.RP01.PEGP._ON)) { \_SB_.PCI0.RP01.PEGP._ON() }
            If (CondRefOf(\_SB_.PCI0.RP01.PXSX._ON)) { \_SB_.PCI0.RP01.PXSX._ON() }
        }
        External(\ZPTS, MethodObj)
        ZPTS(Arg0)
    }
    Method(_WAK, 1)
    {
        If (Arg0 < 1 || Arg0 > 5) { Arg0 = 3 }
        External(\ZWAK, MethodObj)
        Local0 = ZWAK(Arg0)
        If (1 == \RMCF.DGPU)
        {
            If (CondRefOf(\_SB_.PCI0.PEGP.DGFX._OFF)) { \_SB_.PCI0.PEGP.DGFX._OFF() }
            If (CondRefOf(\_SB_.PCI0.PEG0.PEGP._OFF)) { \_SB_.PCI0.PEG0.PEGP._OFF() }
            If (CondRefOf(\_SB_.PCI0.RP05.DGFX._OFF)) { \_SB_.PCI0.RP05.DGFX._OFF() }
            If (CondRefOf(\_SB_.PCI0.RP01.PEGP._OFF)) { \_SB_.PCI0.RP01.PEGP._OFF() }
            If (CondRefOf(\_SB_.PCI0.RP01.PXSX._OFF)) { \_SB_.PCI0.RP01.PXSX._OFF() }
        }
        Return(Local0)
    }
    Device(RMD1)
    {
        Name(_HID, "RMD10000")
        Method(_INI)
        {
            If (1 == \RMCF.DGPU)
            {
                // disable discrete graphics (Nvidia/Radeon) if it is present
                If (CondRefOf(\_SB.PCI0.PEGP.DGFX._OFF)) { \_SB.PCI0.PEGP.DGFX._OFF() }
                If (CondRefOf(\_SB.PCI0.PEG0.PEGP._OFF)) { \_SB.PCI0.PEG0.PEGP._OFF() }
                If (CondRefOf(\_SB.PCI0.RP05.DGFX._OFF)) { \_SB.PCI0.RP05.DGFX._OFF() }
                If (CondRefOf(\_SB.PCI0.RP01.PEGP._OFF)) { \_SB.PCI0.RP01.PEGP._OFF() }
                If (CondRefOf(\_SB.PCI0.RP01.PXSX._OFF)) { \_SB.PCI0.RP01.PXSX._OFF() }
            }
        }
    }

    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External(_SB.PCI0.LPCB.EC0.XREG, MethodObj)
    External(_SB.PCI0.RP01.PEGP.RDSS, MethodObj)
    External(_SB.PCI0.RP05.DGFX.RDSS, MethodObj)
    External(_SB.PCI0.RP01.PXSX.RDSS, MethodObj)

    // original _REG is renamed to XREG
    Scope(_SB.PCI0.LPCB.EC0)
    {
        OperationRegion(ECR3, EmbeddedControl, 0x00, 0xFF)
        Method(_REG, 2)
        {
            // call original _REG (now renamed XREG)
            XREG(Arg0, Arg1)

            // call RDSS(0) for _OFF/HGOF
            If (3 == Arg0 && 1 == Arg1)
            {
                If (CondRefOf(\_SB.PCI0.RP01.PEGP.RDSS)) { \_SB.PCI0.RP01.PEGP.RDSS(0) }
                If (CondRefOf(\_SB.PCI0.RP05.DGFX.RDSS)) { \_SB.PCI0.RP05.DGFX.RDSS(0) }
                If (CondRefOf(\_SB.PCI0.RP01.PXSX.RDSS)) { \_SB.PCI0.RP01.PXSX.RDSS(0) }
            }
        }
    }

//
// Add SMBUS device
// From SSDT-SMBUS.dsl
//
    Device(_SB.PCI0.SBUS.BUS0)
    {
        Name(_CID, "smbus")
        Name(_ADR, Zero)
        Device(DVL0)
        {
            Name(_ADR, 0x57)
            Name(_CID, "diagsvault")
            Method(_DSM, 4)
            {
                If (!Arg2) { Return (Buffer() { 0x03 } ) }
                Return (Package() { "address", 0x57 })
            }
        }
    }

//
// Unsupported SATA modes, unsupported SATA devices
// From SSDT-SATA.dsl
//
    External(_SB.PCI0.SATA, DeviceObj)
    Scope(_SB.PCI0.SATA)
    {
        OperationRegion(RMP1, PCI_Config, 2, 2)
        Field(RMP1, AnyAcc, NoLock, Preserve)
        {
            SDID,16
        }
        Name(SDDL, Package()
        {
            // 8086:282a is RAID mode, remap to supported 8086:2829
            0x282a, 0,
            Package()
            {
                "device-id", Buffer() { 0x29, 0x28, 0, 0 },
                "compatbile", Buffer() { "pci8086,2829" },
            },
            // Skylake 8086:a103 not supported currently, remap to supported 8086:a102
            // same with Skylake 8086:9d03
            0xa103, 0x9d03, 0,
            Package()
            {
                "device-id", Buffer() { 0x02, 0xa1, 0, 0 },
                "compatible", Buffer() { "pci8086,a102" },
            }
        })
        Method(_DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            // search for matching device-id in device-id list, SDDL
            Local0 = Match(SDDL, MEQ, SDID, MTR, 0, 0)
            If (Ones != Local0)
            {
                // start search for zero-terminator (prefix to injection package)
                Local0 = Match(SDDL, MEQ, 0, MTR, 0, Local0+1)
                Return (DerefOf(SDDL[Local0+1]))
            }
            // if no match, assume it is supported natively... no inject
            Return (Package() { })
        }
    }

//
// Unsupported LPC devices
// From SSDT-LPC.dsl
//
    External(_SB.PCI0.LPCB, DeviceObj)
    Scope(_SB.PCI0.LPCB)
    {
        OperationRegion(RMP2, PCI_Config, 2, 2)
        Field(RMP2, AnyAcc, NoLock, Preserve)
        {
            LDID,16
        }
        Name(LPDL, Package()
        {
            // list of 8-series LPC device-ids not natively supported
            // inject 0x8c4b for unsupported LPC device-id
            0x8c46, 0x8c49, 0x8c4a, 0x8c4c, 0x8c4e, 0x8c4f,
            0x8c50, 0x8c52, 0x8c54, 0x8c56, 0x8c5c, 0,
            Package()
            {
                "device-id", Buffer() { 0x4b, 0x8c, 0, 0 },
                "compatible", Buffer() { "pci8086,8c4b" },
            },
            // list of 100-series LPC device-ids not natively supported (partial list)
            0x9d48, 0xa14e, 0,
            Package()
            {
                "device-id", Buffer() { 0xc1, 0x9c, 0, 0 },
                "compatible", Buffer() { "pci8086,9cc1" },
            },
        })
        Method(_DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            // search for matching device-id in device-id list, LPDL
            Local0 = Match(LPDL, MEQ, LDID, MTR, 0, 0)
            If (Ones != Local0)
            {
                // start search for zero-terminator (prefix to injection package)
                Local0 = Match(LPDL, MEQ, 0, MTR, 0, Local0+1)
                Return (DerefOf(LPDL[Local0+1]))
            }
            // if no match, assume it is supported natively... no inject
            Return (Package() { })
        }
    }

//
// Deal with "instant wake" via _PRW override
// From SSDT-PRW.dsl, SSDT-LANC_PRW.dsl
//

    // In DSDT, native GPRW is renamed to XPRW with Clover binpatch.
    // (or UPRW to XPRW)
    // As a result, calls to GPRW (or UPRW) land here.
    // The purpose of this implementation is to avoid "instant wake"
    // by returning 0 in the second position (sleep state supported)
    // of the return package.
    External(XPRW, MethodObj)
    Method(GPRW, 2)
    {
        If (0x6d == Arg0) { Return (Package() { 0x6d, 0, }) }
        If (0x0d == Arg0) { Return (Package() { 0x0d, 0, }) }
        Return (XPRW(Arg0, Arg1))
    }
    Method(UPRW, 2)
    {
        If (0x6d == Arg0) { Return (Package() { 0x6d, 0, }) }
        If (0x0d == Arg0) { Return (Package() { 0x0d, 0, }) }
        Return (XPRW(Arg0, Arg1))
    }

    // In DSDT, native LANC._PRW is renamed XPRW with Clover binpatch.
    // As a result, calls to LANC._PRW land here.
    // The purpose of this implementation is to avoid "instant wake"
    // by returning 0 in the second position (sleep state supported)
    // of the return package.
    // LANC._PRW is renamed to XPRW so we can replace it here
    External(_SB.PCI0.LANC, DeviceObj)
    External(_SB.PCI0.LANC.XPRW, MethodObj)
    Method(_SB.PCI0.LANC._PRW)
    {
        Local0 = \_SB.PCI0.LANC.XPRW()
        Local0[1] = 0
        Return(Local0)
    }

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

//
// Backlight control with AppleBacklightInjector.kext or IntelBacklight.kext
// From SSDT-PNLF.dsl
//

#define SANDYIVY_PWMMAX 0x710
#define HASWELL_PWMMAX 0xad9
#define SKYLAKE_PWMMAX 0x56c

    External(RMCF.BKLT, IntObj)
    External(RMCF.LMAX, IntObj)
    External(_SB.PCI0.IGPU, DeviceObj)
    Scope(_SB.PCI0.IGPU)
    {
        // need the device-id from PCI_config to inject correct properties
        OperationRegion(IGD5, PCI_Config, 0, 0x14)
    }

    // For backlight control
    Device(_SB.PCI0.IGPU.PNLF)
    {
        Name(_ADR, Zero)
        Name(_HID, EisaId ("APP0002"))
        Name(_CID, "backlight")
        // _UID is set depending on PWMMax
        // 10: Sandy/Ivy 0x710
        // 11: Haswell/Broadwell 0xad9
        // 12: Skylake/KabyLake 0x56c (and some Haswell, example 0xa2e0008)
        // 99: Other
        Name(_UID, 0)
        Name(_STA, 0x0B)

        Field(^IGD5, AnyAcc, NoLock, Preserve)
        {
            Offset(0x02), GDID,16,
            Offset(0x10), BAR1,32,
        }

        OperationRegion(RMB1, SystemMemory, BAR1 & ~0xF, 0xe1184)
        Field(RMB1, AnyAcc, Lock, Preserve)
        {
            Offset(0x48250),
            LEV2, 32,
            LEVL, 32,
            Offset(0x70040),
            P0BL, 32,
            Offset(0xc8250),
            LEVW, 32,
            LEVX, 32,
            Offset(0xe1180),
            PCHL, 32,
        }

        Method(_INI)
        {
            // IntelBacklight.kext takes care of this at load time...
            // If RMCF.BKLT does not exist, it is assumed you want to use AppleBacklight.kext...
            If (CondRefOf(\RMCF.BKLT)) { If (1 != \RMCF.BKLT) { Return } }

            // Adjustment required when using AppleBacklight.kext
            Local0 = GDID
            Local2 = Ones
            if (CondRefOf(\RMCF.LMAX)) { Local2 = \RMCF.LMAX }

            If (Ones != Match(Package()
            {
                // Sandy
                0x0116, 0x0126, 0x0112, 0x0122,
                // Ivy
                0x0166, 0x016a,
                // Arrandale
                0x42, 0x46
            }, MEQ, Local0, MTR, 0, 0))
            {
                // Sandy/Ivy
                if (Ones == Local2) { Local2 = SANDYIVY_PWMMAX }

                // change/scale only if different than current...
                Local1 = LEVX >> 16
                If (!Local1) { Local1 = Local2 }
                If (Local2 != Local1)
                {
                    // set new backlight PWMMax but retain current backlight level by scaling
                    Local0 = (LEVL * Local2) / Local1
                    //REVIEW: wait for vblank before setting new PWM config
                    //For (Local7 = P0BL, P0BL == Local7, ) { }
                    Local3 = Local2 << 16
                    If (Local2 > Local1)
                    {
                        // PWMMax is getting larger... store new PWMMax first
                        LEVX = Local3
                        LEVL = Local0
                    }
                    Else
                    {
                        // otherwise, store new brightness level, followed by new PWMMax
                        LEVL = Local0
                        LEVX = Local3
                    }
                }
            }
            Else
            {
                // otherwise... Assume Haswell/Broadwell/Skylake
                if (Ones == Local2)
                {
                    // check Haswell and Broadwell, as they are both 0xad9 (for most common ig-platform-id values)
                    If (Ones != Match(Package()
                    {
                        // Haswell
                        0x0d26, 0x0a26, 0x0d22, 0x0412, 0x0416, 0x0a16, 0x0a1e, 0x0a1e, 0x0a2e, 0x041e, 0x041a,
                        // Broadwell
                        0x0BD1, 0x0BD2, 0x0BD3, 0x1606, 0x160e, 0x1616, 0x161e, 0x1626, 0x1622, 0x1612, 0x162b,
                    }, MEQ, Local0, MTR, 0, 0))
                    {
                        Local2 = HASWELL_PWMMAX
                    }
                    Else
                    {
                        // assume Skylake/KabyLake, both 0x56c
                        // 0x1916, 0x191E, 0x1926, 0x1927, 0x1912, 0x1932, 0x1902, 0x1917, 0x191b,
                        // 0x5916, 0x5912, 0x591b, others...
                        Local2 = SKYLAKE_PWMMAX
                    }
                }

                // This 0xC value comes from looking what OS X initializes this\n
                // register to after display sleep (using ACPIDebug/ACPIPoller)\n
                LEVW = 0xC0000000

                // change/scale only if different than current...
                Local1 = LEVX >> 16
                If (!Local1) { Local1 = Local2 }
                If (Local2 != Local1)
                {
                    // set new backlight PWMAX but retain current backlight level by scaling
                    Local0 = (((LEVX & 0xFFFF) * Local2) / Local1) | (Local2 << 16)
                    //REVIEW: wait for vblank before setting new PWM config
                    //For (Local7 = P0BL, P0BL == Local7, ) { }
                    LEVX = Local0
                }
            }

            // Now Local2 is the new PWMMax, set _UID accordingly
            // The _UID selects the correct entry in AppleBacklightInjector.kext
            If (Local2 == SANDYIVY_PWMMAX) { _UID = 14 }
            ElseIf (Local2 == HASWELL_PWMMAX) { _UID = 15 }
            ElseIf (Local2 == SKYLAKE_PWMMAX) { _UID = 16 }
            Else { _UID = 99 }
        }
    }

//
// Battery combiner (combines two batteries into one)
// From SSDT-BATC.dsl
//
    Scope(_SB)
    {
        External(BAT0, DeviceObj)
        External(BAT0._HID, IntObj)
        External(BAT0._STA, MethodObj)
        External(BAT0._BIF, MethodObj)
        External(BAT0._BST, MethodObj)
        External(BAT1, DeviceObj)
        External(BAT1._HID, IntObj)
        External(BAT1._STA, MethodObj)
        External(BAT1._BIF, MethodObj)
        External(BAT1._BST, MethodObj)

        Device(BATC)
        {
            Name(_HID, EisaId ("PNP0C0A"))
            Name(_UID, 0x02)

            Method(_INI)
            {
                // disable original battery objects by setting invalid _HID
                ^^BAT0._HID = 0
                ^^BAT1._HID = 0
            }

            Method(CVWA, 3)
            // Convert mW to mA (or mWh to mAh)
            // Arg0 is mW or mWh (or mA/mAh in the case Arg2==0)
            // Arg1 is mV (usually design voltage)
            // Arg2 is whether conversion is needed (non-zero for convert)
            // return is mA or mAh
            {
                If (Arg2)
                {
                    Arg0 = (Arg0 * 1000) / Arg1
                }
                Return(Arg0)
            }

            Method(_STA)
            {
                // call original _STA for BAT0 and BAT1
                // result is bitwise OR between them
                Return(^^BAT0._STA() | ^^BAT1._STA())
            }

            Name(B0CO, 0x00) // BAT0 0/1 needs conversion to mAh
            Name(B1CO, 0x00) // BAT1 0/1 needs conversion to mAh
            Name(B0DV, 0x00) // BAT0 design voltage
            Name(B1DV, 0x00) // BAT1 design voltage

            Method(_BST)
            {
                // Local0 BAT0._BST
                // Local1 BAT1._BST
                // Local2 BAT0._STA
                // Local3 BAT1._STA
                // Local4/Local5 scratch

                // gather battery data from BAT0
                Local0 = ^^BAT0._BST()
                Local2 = ^^BAT0._STA()
                If (0x1f == Local2)
                {
                    // check for invalid remaining capacity
                    Local4 = DerefOf(Local0[2])
                    If (!Local4 || Ones == Local4) { Local2 = 0; }
                }
                // gather battery data from BAT1
                Local1 = ^^BAT1._BST()
                Local3 = ^^BAT1._STA()
                If (0x1f == Local3)
                {
                    // check for invalid remaining capacity
                    Local4 = DerefOf(Local1[2])
                    If (!Local4 || Ones == Local4) { Local3 = 0; }
                }
                // find primary and secondary battery
                If (0x1f != Local2 && 0x1f == Local3)
                {
                    // make primary use BAT1 data
                    Local0 = Local1 // BAT1._BST result
                    Local2 = Local3 // BAT1._STA result
                    Local3 = 0  // no secondary battery
                }
                // combine batteries into Local0 result if possible
                If (0x1f == Local2 && 0x1f == Local3)
                {
                    // _BST 0 - Battery State - if one battery is charging, then charging, else discharging
                    Local4 = DerefOf(Local0[0])
                    Local5 = DerefOf(Local1[0])
                    If (Local4 == 2 || Local5 == 2)
                    {
                        // 2 = charging
                        Local0[0] = 2
                    }
                    ElseIf (Local4 == 1 || Local5 == 1)
                    {
                        // 1 = discharging
                        Local0[0] = 1
                    }
                    ElseIf (Local4 == 5 || Local5 == 5)
                    {
                        // critical and discharging
                        Local0[0] = 5
                    }
                    ElseIf (Local4 == 4 || Local5 == 4)
                    {
                        // critical
                        Local0[0] = 4
                    }
                    // if none of the above, just leave as BAT0 is

                    // Note: Depends on _BIF being called before _BST to set B0CO and B1CO

                    // _BST 1 - Battery Present Rate - Add BAT0 and BAT1 values
                    Local0[1] = CVWA(DerefOf(Local0[1]), B0DV, B0CO) + CVWA(DerefOf(Local1[1]), B1DV, B1CO)
                    // _BST 2 - Battery Remaining Capacity - Add BAT0 and BAT1 values
                    Local0[2] = CVWA(DerefOf(Local0[2]), B0DV, B0CO) + CVWA(DerefOf(Local1[2]), B1DV, B1CO)
                    // _BST 3 - Battery Present Voltage - Average BAT0 and BAT1 values
                    Local0[3] = (DerefOf(Local0[3]) + DerefOf(Local1[3])) / 2
                }
                Return(Local0)
            } // _BST

            Method(_BIF)
            {
                // Local0 BAT0._BIF
                // Local1 BAT1._BIF
                // Local2 BAT0._STA
                // Local3 BAT1._STA
                // Local4/Local5 scratch

                // gather and validate data from BAT0
                Local0 = ^^BAT0._BIF()
                Local2 = ^^BAT0._STA()
                If (0x1f == Local2)
                {
                    // check for invalid design capacity
                    Local4 = DerefOf(Local0[1])
                    If (!Local4 || Ones == Local4) { Local2 = 0; }
                    // check for invalid max capacity
                    Local4 = DerefOf(Local0[2])
                    If (!Local4 || Ones == Local4) { Local2 = 0; }
                    // check for invalid design voltage
                    Local4 = DerefOf(Local0[4])
                    If (!Local4 || Ones == Local4) { Local2 = 0; }
                }
                // gather and validate data from BAT1
                Local1 = ^^BAT1._BIF()
                Local3 = ^^BAT1._STA()
                If (0x1f == Local3)
                {
                    // check for invalid design capacity
                    Local4 = DerefOf(Local1[1])
                    If (!Local4 || Ones == Local4) { Local3 = 0; }
                    // check for invalid max capacity
                    Local4 = DerefOf(Local1[2])
                    If (!Local4 || Ones == Local4) { Local3 = 0; }
                    // check for invalid design voltage
                    Local4 = DerefOf(Local1[4])
                    If (!Local4 || Ones == Local4) { Local3 = 0; }
                }
                // find primary and secondary battery
                If (0x1f != Local2 && 0x1f == Local3)
                {
                    // make primary use BAT1 data
                    Local0 = Local1 // BAT1._BIF result
                    Local2 = Local3 // BAT1._STA result
                    Local3 = 0  // no secondary battery
                }
                // combine batteries into Local0 result if possible
                If (0x1f == Local2 && 0x1f == Local3)
                {
                    // _BIF 0 - Power Unit - 0 = mWh | 1 = mAh
                    // set B0CO/B1CO if convertion to amps needed
                    B0CO = !DerefOf(Local0[0])
                    B1CO = !DerefOf(Local1[0])
                    // set _BIF[0] = 1 => mAh
                    Local0[0] = 1

                    // _BIF 4 - Design Voltage - store value for each Battery in mV
                    B0DV = DerefOf(Local0[4]) // cache BAT0 voltage
                    B1DV = DerefOf(Local1[4]) // cache BAT1 voltage

                    // _BIF 1 - Design Capacity - add BAT0 and BAT1 values
                    Local0[1] = CVWA(DerefOf(Local0[1]), B0DV, B0CO) + CVWA(DerefOf(Local1[1]), B1DV, B1CO)
                    // _BIF 2 - Last Full Charge Capacity - add BAT0 and BAT1 values
                    Local0[2] = CVWA(DerefOf(Local0[2]), B0DV, B0CO) + CVWA(DerefOf(Local1[2]), B1DV, B1CO)
                    // _BIF 3 - Battery Technology - leave BAT0 value
                    // _BIF 4 - Design Voltage - average BAT0 and BAT1 values
                    Local0[4] = (B0DV + B1DV) / 2
                    // _BIF 5 - Design Capacity Warning - add BAT0 and BAT1 values
                    Local0[5] = CVWA(DerefOf(Local0[5]), B0DV, B0CO) + CVWA(DerefOf(Local1[5]), B1DV, B1CO)
                    // _BIF 6 - Design Capacity of Low - add BAT0 and BAT1 values
                    Local0[6] = CVWA(DerefOf(Local0[6]), B0DV, B0CO) + CVWA(DerefOf(Local1[6]), B1DV, B1CO)
                    // _BIF 7+ - Leave BAT0 values for now
                }
                Return(Local0)
            } // _BIF
        } // BATC
    } // Scope(...)
}

//EOF
