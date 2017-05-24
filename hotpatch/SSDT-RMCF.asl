//DefinitionBlock ("", "SSDT", 2, "hack", "hack", 0)
//{
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
            Store("XPEE enables xHCI PMEE fix. 1: disable xHCI PMEE on _PTS when Arg0==5, 0: do not mess with XHC.PMEE", Debug)
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
//}
