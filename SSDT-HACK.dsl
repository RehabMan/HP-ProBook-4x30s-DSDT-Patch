// Instead of providing patched DSDT/SSDT, just include a add-on
// SSDTs and the rest of the work done in config.plist.

// A bit experimental, and a bit more difficult with laptops, but
// still possible.

DefinitionBlock ("", "SSDT", 2, "hack", "hack", 0)
{
    External(\_SB.PCI0, DeviceObj)
    External(\_SB.PCI0.LPCB, DeviceObj)

    External(\_SB_.PCI0.PEGP.DGFX._OFF, MethodObj)
    External(\_SB_.PCI0.PEG0.PEGP._OFF, MethodObj)
    External(\_SB_.PCI0.PEGP.DGFX._ON, MethodObj)
    External(\_SB_.PCI0.PEG0.PEGP._ON, MethodObj)

    Device(RMCF)
    {
        Name(_ADR, 0)   // do not remove

        Method(HELP)
        {
            Store("DGPU indicates whether discrete GPU should be disabled. 1: yes, 0: no", Debug)
            Store("BKLT indicates the type of backlight control. 0: IntelBacklight, 1: AppleBacklight", Debug)
            Store("LMAX indicates max for IGPU PWM backlight. Ones: Use default, other values must match framebuffer", Debug)
        }

        // DGPU: Controls whether the DGPU is disabled via ACPI or not
        // 1: (default) DGPU is disabled at startup, enabled in _PTS, disabled in _WAK
        // 0: DGPU is not manipulated
        Name(DGPU, 1)

        // BKLT: Backlight control type
        //
        // 0: Using IntelBacklight.kext
        // 1: Using AppleBacklight.kext + AppleBacklightInjector.kext
        Name(BKLT, 0)

        // LMAX: Backlight PWM MAX.  Must match framebuffer in use.
        //
        // Ones: Default will be used (0x710 for Ivy/Sandy, 0xad9 for Haswell/Broadwell)
        // Other values: must match framebuffer
        Name(LMAX, Ones)
    }

    External(USWE, FieldUnitObj)
    Scope(RMCF)
    {
        Method(_INI)
        {
            // disable wake on XHC (XHC._PRW checks USWE and enables wake if it is 1)
            If (CondRefOf(\USWE)) { \USWE = 0 }
        }
    }

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
            //"Windows 2012",       // Windows 8/Windows Sesrver 2012
            //"Windows 2013",       // Windows 8.1/Windows Server 2012 R2
            //"Windows 2015",       // Windows 10/Windows Server TP
        }
        Return (Ones != Match(Local0, MEQ, Arg0, MTR, 0, 0))
    }

    // In DSDT, native UPRW/GPRW is renamed to XPRW with Clover binpatch.
    // As a result, calls to UPRW land here.
    // The purpose of this implementation is to avoid "instant wake"
    // by returning 0 in the second position (sleep state supported)
    // of the return package.
    Method(UPRW, 2)
    {
        If (0x0d == Arg0) { Return(Package() { 0x0d, 0, }) }
        If (0x6d == Arg0) { Return(Package() { 0x6d, 0, }) }
        External(\XPRW, MethodObj)
        Return(XPRW(Arg0, Arg1))
    }
    Method(GPRW, 2)
    {
        If (0x0d == Arg0) { Return(Package() { 0x0d, 0, }) }
        If (0x6d == Arg0) { Return(Package() { 0x6d, 0, }) }
        External(\XPRW, MethodObj)
        Return(XPRW(Arg0, Arg1))
    }

    // LANC._PRW is renamed to XPRW so we can replace it here
    External(_SB.PCI0.LANC, DeviceObj)
    External(_SB.PCI0.LANC.XPRW, MethodObj)
    Method(_SB.PCI0.LANC._PRW)
    {
        Local0 = \_SB.PCI0.LANC.XPRW()
        Local0[1] = 0
        Return(Local0)
    }

    // For backlight control
    Device(_SB.PNLF)
    {
        Name(_ADR, Zero)
        Name(_HID, EisaId ("APP0002"))
        Name(_CID, "backlight")
        Name(_UID, 10)
        Name(_STA, 0x0B)
        Method(RMCF)
        {
            Return(Package()
            {
                "PWMMax", 0,
            })
        }

        OperationRegion(RMB1, SystemMemory, \_SB.PCI0.IGPU.BAR1 & ~0xF, 0xe1184)
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

        External(\_SB.PCI0.IGPU.GDID, FieldUnitObj)
        External(\_SB.PCI0.IGPU.BAR1, FieldUnitObj)

        //REVIEW: come up with table driven effort here...
        #define SANDYIVY_PWMMAX 0x710
        #define HASWELL_PWMMAX 0xad9

        Method(_INI)
        {
            // disable discrete graphics (Nvidia/Radeon) if it is present
            If (1 == \RMCF.DGPU)
            {
                If (CondRefOf(\_SB_.PCI0.PEGP.DGFX._OFF)) { \_SB_.PCI0.PEGP.DGFX._OFF() }
                If (CondRefOf(\_SB_.PCI0.PEG0.PEGP._OFF)) { \_SB_.PCI0.PEG0.PEGP._OFF() }
            }

            // IntelBacklight.kext takes care of this at load time...
            If (1 != \RMCF.BKLT) { Return }

            // Adjustment required when using AppleBacklight.kext
            Local0 = \_SB.PCI0.IGPU.GDID
            If (Ones != Match(Package() { 0x0116, 0x0126, 0x0112, 0x0122, 0x0166, 0x42, 0x46 }, MEQ, Local0, MTR, 0, 0))
            {
                // Sandy/Ivy
                Local2 = \RMCF.LMAX
                if (Ones == \RMCF.LMAX) { Local2 = SANDYIVY_PWMMAX }

                // change/scale only if different than current...
                Local1 = LEVX >> 16
                If (!Local1) { Local1 = Local2 }
                If (Local2 != Local1)
                {
                    // set new backlight PWMAX but retain current backlight level by scaling
                    Local0 = (LEVL * Local2) / Local1
                    //REVIEW: wait for vblank before setting new PWM config
                    //For (Local7 = P0BL, P0BL == Local7, ) { }
                    LEVL = Local0
                    LEVX = Local2 << 16
                }
            }
            Else
            {
                // otherwise... Assume Haswell/Broadwell/Skylake
                Local2 = \RMCF.LMAX
                if (Ones == \RMCF.LMAX) { Local2 = HASWELL_PWMMAX }

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
        }
    }

    // In DSDT, native _PTS and _WAK are renamed ZPTS/ZWAK
    // As a result, calls to these methods land here.
    Method(_PTS, 1)
    {
        If (5 == Arg0) { Return }
        If (1 == \RMCF.DGPU)
        {
            If (CondRefOf(\_SB_.PCI0.PEGP.DGFX._ON)) { \_SB_.PCI0.PEGP.DGFX._ON() }
            If (CondRefOf(\_SB_.PCI0.PEG0.PEGP._ON)) { \_SB_.PCI0.PEG0.PEGP._ON() }
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
        }
        Return(Local0)
    }

    Scope (_SB.PCI0.LPCB)
    {
        OperationRegion(LPD4, PCI_Config, 2, 2)
        Field(LPD4, AnyAcc, NoLock, Preserve)
        {
            LDID,16
        }
        Name(LPDL, Package()
        {
            // list of 8-series LPC device-ids not natively supported
            // inject 0x8c4b for unsupported LPC device-id
            0x8c46, 0x8c49, 0x8c4a, 0x8c4c, 0x8c4e, 0x8c4f,
            0x8c50, 0x8c52, 0x8c54, 0x8c56, 0x8c5c, 0,
            Package() { "compatible", Buffer() { "pci8086,8c4b" } },
            // Note: currently only the above 8-series unsupported ids are handled,
            // but easy to add more here, just like the IGPU code
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

    Scope (_SB.PCI0)
    {
        Device(SBUS.BUS0)
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
    }
}

//EOF
