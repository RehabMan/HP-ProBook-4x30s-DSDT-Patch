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
            Store("IGPI overrides ig-platform-id or snb-platform-id", Debug)
            Store("DGPU indicates whether discrete GPU should be disabled. bit0: startup, bit1: _PTS/_WAK", Debug)
            Store("BKLT indicates the type of backlight control. 0: IntelBacklight, 1: AppleBacklight", Debug)
            Store("LMAX indicates max for IGPU PWM backlight. Ones: Use default, other values must match framebuffer", Debug)
            Store("SHUT enables shutdown fix. 1: disables _PTS code when Arg0==5", Debug)
            Store("XPEE enables xHCI PMEE fix. 1: disable xHCI PMEE on _PTS when Arg0==5, 0: do not mess with XHC.PMEE", Debug)
        }

        // IGPI: Override for ig-platform-id (or snb-platform-id).  Will be used if non-zero.
        // For example, if you wanted to inject a bogus id, 0x12345678
        //    Name(IGPI, 0x12345678)
        // You can also set it to Ones to disable IGPU injection
        //    Name(IGPI, Ones)
#ifndef OVERRIDE_IGPI
        Name(IGPI, 0)
#else
        Name(IGPI, OVERRIDE_IGPI)
#endif

        // LMAX: Backlight PWM MAX.  Must match framebuffer in use.
        //
        // Ones: Default will be used (0x710 for Ivy/Sandy, 0xad9 for Haswell/Broadwell)
        // Other values: must match framebuffer
#ifndef OVERRIDE_LMAX
        Name(LMAX, Ones)
#else
        Name(LMAX, OVERRIDE_LMAX)
#endif

        // BUID: Backlight _UID.  _UID is matched against AppleBacklightInjector profiles
        // 0: Use default based on LMAX
        // Other values: customized, but must match a backlight profile
#ifndef OVERRIDE_BUID
        Name(BUID, 0)
#else
        Name(BUID, OVERRIDE_BUID)
#endif
        // DGPU: Controls whether the DGPU is disabled via ACPI or not
        // bit 0: DGPU disabled at startup
        // bit 1: DGPU enabled in _PTS, disabled in _WAK
        // default is 3
#ifndef OVERRIDE_DGPU
        Name(DGPU, 3)
#else
        Name(DGPU, OVERRIDE_DGPU)
#endif

        // BKLT: Backlight control type
        //
        // 0: Using IntelBacklight.kext
        // 1: Using AppleBacklight.kext + AppleBacklightInjector.kext
#ifndef OVERRIDE_BLKT
        Name(BKLT, 1)
#else
        Name(BLKT, OVERRIDE_BKLT)
#endif

        // SHUT: Shutdown fix, disable _PTS code when Arg0==5 (shutdown)
        //
        //  0: does not affect _PTS behavior during shutdown
        //  1: disables _PTS code during shutdown
#ifndef OVERRIDE_SHUT
        Name(SHUT, 0)
#else
        Name(SHUT, OVERRIDE_SHUT)
#endif

        // XPEE
        //
        // 0: do not manipulate XHC.PMEE during shutdown
        // 1: disable XHC.PMEE during shutdown
#ifndef OVERRIDE_XPEE
        Name(XPEE, 0)
#else
        Name(XPEE, OVERRIDE_XPEE)
#endif
    }
//}
