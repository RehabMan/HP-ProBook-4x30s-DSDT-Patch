DefinitionBlock ("", "SSDT", 2, "hack", "DGFX_RDSS", 0)
{
    External(_SB.PCI0.RP05.DGFX, DeviceObj)
    External(_SB.PCI0.RP05.DGFX.XDSS, MethodObj)
    External(_SB.PCI0.LPCB.EC0.ECRG, IntObj)

    // original RDSS is renamed to XDSS
    // the original RDSS does not check for EC "ready" state
    Method(_SB.PCI0.RP05.DGFX.RDSS, 1)
    {
        // check if EC is ready and XDSS exists
        If (\_SB.PCI0.LPCB.EC0.ECRG && CondRefOf(\_SB.PCI0.RP05.DGFX.XDSS))
        {
            // call original RDSS (now renamed XDSS)
            XDSS(Arg0)
        }
    }
}
//EOF
