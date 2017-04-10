DefinitionBlock ("", "SSDT", 2, "hack", "EC_REG", 0)
{
    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External(_SB.PCI0.LPCB.EC0.XREG, MethodObj)
    External(_SB.PCI0.RP01.PEGP.RDSS, MethodObj)
    External(_SB.PCI0.RP05.DGFX.RDSS, MethodObj)
    External(_SB.PCI0.RP01.PXSX.RDSS, MethodObj)

    // original _REG is renamed to XREG
    Scope(_SB.PCI0.LPCB.EC0)
    {
        OperationRegion(ECR3, EmbeddedControl, 0x00, 0xFF)
        Method(_REG, 2)
        {
            // call original _REG (now renamed XREG)
            XREG(Arg0, Arg1)

            // call RDSS(0) for _OFF/HGOF
            If (3 == Arg0 && 1 == Arg1)
            {
                If (CondRefOf(\_SB.PCI0.RP01.PEGP.RDSS)) { \_SB.PCI0.RP01.PEGP.RDSS(0) }
                If (CondRefOf(\_SB.PCI0.RP05.DGFX.RDSS)) { \_SB.PCI0.RP05.DGFX.RDSS(0) }
                If (CondRefOf(\_SB.PCI0.RP01.PXSX.RDSS)) { \_SB.PCI0.RP01.PXSX.RDSS(0) }
            }
        }
    }
}
//EOF
