// SSDT for EliteBook 1040 G3 (Skylake)

DefinitionBlock ("", "SSDT", 2, "hack", "1040g3s", 0)
{
    //#include "include/standard_PS2K.asl"
    External(\_SB.PCI0.LPCB.PS2K, DeviceObj)
    Scope (\_SB.PCI0.LPCB.PS2K)
    {
        // overrides for VoodooPS2 configuration...
        Name(RMCF, Package()
        {
            #include "include/standard_PS2K_data.asl"
            #include "include/key86_data.asl"
        })
    }

    Include("include/disable_HECI.asl")
    Include("include/layout7_HDEF.asl")

    // This USWE code is specific to the Skylake G3
    External(USWE, FieldUnitObj)
    Device(RMD3)
    {
        Name(_HID, "RMD30000")
        Method(_INI)
        {
            // disable wake on XHC (XHC._PRW checks USWE and enables wake if it is 1)
            If (CondRefOf(\USWE)) { \USWE = 0 }
        }
    }
}
//EOF
