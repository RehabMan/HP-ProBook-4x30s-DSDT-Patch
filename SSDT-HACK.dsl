// Instead of providing patched DSDT/SSDT, just include a add-on
// SSDTs and the rest of the work done in config.plist.

// A bit experimental, and a bit more difficult with laptops, but
// still possible.

DefinitionBlock ("", "SSDT", 2, "hack", "hack", 0)
{
    External(\_SB.PCI0, DeviceObj)
    External(\_SB.PCI0.LPCB, DeviceObj)

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

    // In DSDT, native UPRW is renamed to XPRW with Clover binpatch.
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
        Method(_INI)
        {
            // disable discrete graphics (Nvidia) if it is present
            External(\_SB_.PCI0.PEGP.DGFX._OFF, MethodObj)
            If (CondRefOf(\_SB_.PCI0.PEGP.DGFX._OFF))
            {
                \_SB_.PCI0.PEGP.DGFX._OFF()
            }
        }
    }

    // In DSDT, native _PTS and _WAK are renamed ZPTS/ZWAK
    // As a result, calls to these methods land here.
    Method(_PTS, 1)
    {
        If (5 == Arg0) { Return }
        External(\_SB_.PCI0.PEGP.DGFX._ON, MethodObj)
        If (CondRefOf(\_SB_.PCI0.PEGP.DGFX._ON)) { \_SB_.PCI0.PEGP.DGFX._ON() }
        External(\ZPTS, MethodObj)
        ZPTS(Arg0)
    }
    Method(_WAK, 1)
    {
        If (Arg0 < 1 || Arg0 > 5) { Arg0 = 3 }
        External(\ZWAK, MethodObj)
        Local0 = ZWAK(Arg0)
        If (CondRefOf(\_SB_.PCI0.PEGP.DGFX._OFF)) { \_SB_.PCI0.PEGP.DGFX._OFF() }
        Return(Local0)
    }

    Scope (\_SB.PCI0)
    {
        Scope(LPCB)
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
