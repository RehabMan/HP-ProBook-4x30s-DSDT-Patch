#define DEFINED_RP01_PEGP_RDSS

//DefinitionBlock ("", "SSDT", 2, "hack", "01PEGP", 0)
//{
    External(_SB.PCI0.RP01.PEGP, DeviceObj)
    External(_SB.PCI0.RP01.PEGP.XDSS, MethodObj)
    External(_SB.PCI0.LPCB.EC.ECRG, IntObj)

    // original RDSS is renamed to XDSS
    // the original RDSS does not check for EC "ready" state
    Method(_SB.PCI0.RP01.PEGP.RDSS, 1)
    {
        // check if EC is ready and XDSS exists
        If (\_SB.PCI0.LPCB.EC.ECRG && CondRefOf(\_SB.PCI0.RP01.PEGP.XDSS))
        {
            // call original RDSS (now renamed XDSS)
            XDSS(Arg0)
        }
    }
//}
//EOF
