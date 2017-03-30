// Instead of providing patched DSDT/SSDT, just include a add-on
// SSDTs and the rest of the work done in config.plist.

// A bit experimental, and a bit more difficult with laptops, but
// still possible.

DefinitionBlock ("", "SSDT", 2, "hack", "hack", 0)
{
    External(\_SB.PCI0, DeviceObj)
    External(\_SB.PCI0.LPCB, DeviceObj)

    External(\_SB_.PCI0.PEGP.DGFX._OFF, MethodObj)
    External(\_SB_.PCI0.PEGP.DGFX._ON, MethodObj)
    External(\_SB_.PCI0.PEG0.PEGP._OFF, MethodObj)
    External(\_SB_.PCI0.PEG0.PEGP._ON, MethodObj)
    External(\_SB_.PCI0.RP05.DGFX._OFF, MethodObj)
    External(\_SB_.PCI0.RP05.DGFX._ON, MethodObj)
    External(\_SB_.PCI0.RP01.PEGP._OFF, MethodObj)
    External(\_SB_.PCI0.RP01.PEGP._ON, MethodObj)

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
            }
        }
    }
}

//EOF
