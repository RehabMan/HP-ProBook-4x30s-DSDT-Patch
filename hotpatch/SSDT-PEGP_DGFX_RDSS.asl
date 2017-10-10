#define DEFINED_PEGP_DGFX_RDSS

//DefinitionBlock ("", "SSDT", 2, "hack", "PEGPDGFX", 0)
//{
    External(_SB.PCI0.PEGP.DGFX, DeviceObj)
    External(_SB.PCI0.PEGP.DGFX.XDSS, MethodObj)
    External(_SB.PCI0.LPCB.EC.ECRG, IntObj)

    // original RDSS is renamed to XDSS
    // the original RDSS does not check for EC "ready" state
    Method(_SB.PCI0.PEGP.DGFX.RDSS, 1)
    {
        // check if EC is ready and XDSS exists
        If (\_SB.PCI0.LPCB.EC.ECRG && CondRefOf(\_SB.PCI0.PEGP.DGFX.XDSS))
        {
            // call original RDSS (now renamed XDSS)
            XDSS(Arg0)
        }
    }
//}
//EOF
