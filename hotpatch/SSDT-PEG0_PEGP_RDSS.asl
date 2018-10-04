//DefinitionBlock("", "SSDT", 2, "hack", "PEG0PEGP", 0)
//{
    External(_SB.PCI0.PEG0.PEGP, DeviceObj)
    External(_SB.PCI0.PEG0.PEGP.XDSS, MethodObj)
    External(_SB.PCI0.PEG0.PEGP._OFF, MethodObj)
    External(_SB.PCI0.PEG0.PEGP._ON, MethodObj)
    External(_SB.PCI0.LPCB.EC.ECRG, IntObj)
    Scope(_SB.PCI0.PEG0.PEGP)
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
        Method(RMOF) { If (CondRefOf(\_SB.PCI0.PEG0.PEGP._OFF)) { \_SB.PCI0.PEG0.PEGP._OFF() } }
        Method(RMON) { If (CondRefOf(\_SB.PCI0.PEG0.PEGP._ON)) { \_SB.PCI0.PEG0.PEGP._ON() } }
        Method(RDSS, 1) { If (CondRefOf(\_SB.PCI0.PEG0.PEGP.RDSS)) { \_SB.PCI0.PEG0.PEGP.RDSS(Arg0) } }
    }
//}
//EOF
