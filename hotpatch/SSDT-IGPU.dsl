// IGPU injections for Intel graphics

DefinitionBlock ("", "SSDT", 2, "hack", "igpu", 0)
{
//
// IGPU injection
// From SSDT-IGPU.dsl
//
    External(_SB.PCI0.IGPU, DeviceObj)
    External(RMCF.IGPI, IntObj)
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
                "AAPL,snb-platform-id", Buffer() { 0x00, 0x00, 0x01, 0x00 },
                "model", Buffer() { "Intel HD Graphics 3000" },
                "hda-gfx", Buffer() { "onboard-1" },
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
                #ifndef HIRES
                "AAPL,ig-platform-id", Buffer() { 0x03, 0x00, 0x66, 0x01 },   //768p
                #else
                "AAPL,ig-platform-id", Buffer() { 0x04, 0x00, 0x66, 0x01 },   //900p/1080p
                #endif
                "model", Buffer() { "Intel HD Graphics 4000" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD4200
            0x0a1e, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                "model", Buffer() { "Intel HD Graphics 4200" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD4400
            0x0a16, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                "model", Buffer() { "Intel HD Graphics 4400" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD4600
            0x0416, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                "model", Buffer() { "Intel HD Graphics 4600" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD5000/HD5100/HD5200
            0x0a26, 0x0a2e, 0x0d26, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD5300
            0x161e, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
                "model", Buffer() { "Intel HD Graphics 5300" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD5500
            0x1616, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
                "model", Buffer() { "Intel HD Graphics 5500" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD5600
            0x1612, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
                "model", Buffer() { "Intel HD Graphics 5600" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD6000/HD6100/HD6200
            0x1626, 0x162b, 0x1622, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Skylake/HD515
            0x191e, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1e, 0x19 },
                "model", Buffer() { "Intel HD Graphics 515" },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
                "RM,device-id", Buffer() { 0x1e, 0x19, 0x00, 0x00 },
            },
            // Skylake/HD520
            0x1916, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x16, 0x19 },
                "model", Buffer() { "Intel HD Graphics 520" },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
                "RM,device-id", Buffer() { 0x16, 0x19, 0x00, 0x00 },
            },
            // Skylake/HD530
            0x191b, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1b, 0x19 },
                "model", Buffer() { "Intel HD Graphics 530" },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
                "RM,device-id", Buffer() { 0x1b, 0x19, 0x00, 0x00 },
            },
            // Skylake/P530
            0x191d, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1b, 0x19 },
                "model", Buffer() { "Intel HD Graphics P530" },
                "device-id", Buffer() { 0x1b, 0x19, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
                "RM,device-id", Buffer() { 0x1d, 0x19, 0x00, 0x00 },
            },
            // Kaby Lake/HD620
            0x5916, 0, Package()
            {
                //SKL spoof: "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1b, 0x19 },
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1b, 0x59 },
                "model", Buffer() { "Intel HD Graphics 620" },
                //SKL spoof: "device-id", Buffer() { 0x1b, 0x19, 0x00, 0x00 },
                //"device-id", Buffer() { 0x1b, 0x59, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
                //SKL spoof: "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
            },
            // Kaby Lake-R/UHD620
            0x5917, 0, Package()
            {
                //SKL spoof: "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1b, 0x19 },
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1b, 0x59 },
                "model", Buffer() { "Intel UHD Graphics 620" },
                "hda-gfx", Buffer() { "onboard-1" },
                //SKL spoof: "device-id", Buffer() { 0x1b, 0x19, 0x00, 0x00 },
                "device-id", Buffer() { 0x1b, 0x59, 0x00, 0x00 },
                //SKL spoof: "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
            },
            // Kaby Lake/HD630
            0x5912, 0x591b, 0, Package()
            {
                //SKL spoof: "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1b, 0x19 },
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1b, 0x59 },
                "model", Buffer() { "Intel HD Graphics 630" },
                //SKL spoof: "device-id", Buffer() { 0x1b, 0x19, 0x00, 0x00 },
                //"device-id", Buffer() { 0x1b, 0x59, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
                //SKL spoof: "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
            },
        })

        // inject properties for integrated graphics on IGPU
        Method(_DSM, 4)
        {
            // IGPI can be set to Ones to disable IGPU property injection (same as removing SSDT-IGPU.aml)
            If (CondRefOf(\RMCF.IGPI)) { If (Ones == \RMCF.IGPI) { Return(0) } }
            // otherwise, normal IGPU injection...
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            // search for matching device-id in device-id list
            Local0 = Match(GIDL, MEQ, GDID, MTR, 0, 0)
            // unrecognized device... inject nothing in this case
            If (Ones == Local0) { Return (Package() { }) }
            // start search for zero-terminator (prefix to injection package)
            Local0 = DerefOf(GIDL[Match(GIDL, MEQ, 0, MTR, 0, Local0+1)+1])
            // the user can provide an override of ig-platform-id (or snb-platform-id) in RMCF.IGPI
            If (CondRefOf(\RMCF.IGPI))
            {
                if (0 != \RMCF.IGPI)
                {
                    CreateDWordField(DerefOf(Local0[1]), 0, IGPI)
                    IGPI = \RMCF.IGPI
                }
            }
            Return (Local0)
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
#define CUSTOM_PWMMAX_07a1 0x07a1
#define CUSTOM_PWMMAX_1499 0x1499

    External(RMCF.BKLT, IntObj)
    External(RMCF.LMAX, IntObj)
    External(RMCF.BUID, IntObj)
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

            // The _UID selects the correct entry in AppleBacklightInjector.kext
            // RMCF.BUID can be set to override automatic _UID selection
            Local0 = 0
            If (CondRefOf(\RMCF.BUID)) { Local0 = \RMCF.BUID }
            If (0 != Local0)
            {
                // use specified _UID
                _UID = \RMCF.BUID
            }
            Else
            {
                // Now Local2 is the new PWMMax, set _UID accordingly
                If (Local2 == SANDYIVY_PWMMAX) { _UID = 14 }
                ElseIf (Local2 == HASWELL_PWMMAX) { _UID = 15 }
                ElseIf (Local2 == SKYLAKE_PWMMAX) { _UID = 16 }
                ElseIf (Local2 == CUSTOM_PWMMAX_07a1) { _UID = 17 }
                ElseIf (Local2 == CUSTOM_PWMMAX_1499) { _UID = 18 }
                Else { _UID = 99 }
            }
        }
    }
}

//EOF
