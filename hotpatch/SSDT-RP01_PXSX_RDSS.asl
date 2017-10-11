//DefinitionBlock ("", "SSDT", 2, "hack", "RP01PXSX", 0)
//{
    External(_SB.PCI0.RP01.PXSX, DeviceObj)
    External(_SB.PCI0.RP01.PXSX.XDSS, MethodObj)
    External(_SB.PCI0.RP01.PXSX._OFF, MethodObj)
    External(_SB.PCI0.RP01.PXSX._ON, MethodObj)
    External(_SB.PCI0.LPCB.EC.ECRG, IntObj)
    Scope(_SB.PCI0.RP01.PXSX)
    {
        // original RDSS is renamed to XDSS
        // the original RDSS does not check for EC "ready" state
        Method(RDSS, 1)
        {
            // check if EC is ready and XDSS exists
            If (\_SB.PCI0.LPCB.EC.ECRG && CondRefOf(^XDSS))
            {
                // call original RDSS (now renamed XDSS)
                XDSS(Arg0)
            }
        }
    }
    Scope(RMCF)
    {
        Method(RMOF) { If (1 == DGPU && CondRefOf(\_SB.PCI0.RP01.PXSX._OFF)) { \_SB.PCI0.RP01.PXSX._OFF() } }
        Method(RMON) { If (1 == DGPU && CondRefOf(\_SB.PCI0.RP01.PXSX._OFF)) { \_SB.PCI0.RP01.PXSX._ON() } }
        Method(RDSS, 1) { If (CondRefOf(\_SB.PCI0.RP01.PXSX.RDSS)) { \_SB.PCI0.RP01.PXSX.RDSS(Arg0) } }
    }
//}
//EOF
