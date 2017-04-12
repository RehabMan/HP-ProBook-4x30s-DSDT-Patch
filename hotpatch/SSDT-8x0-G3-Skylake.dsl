// SSDT for EliteBook 8x0 G3 (Skylake)

DefinitionBlock ("", "SSDT", 2, "hack", "8x0g3s", 0)
{
    #include "SSDT-HACK.dsl"
    #include "include/disable_HECI.asl"
    #include "include/layout7_HDEF.asl"
    #include "include/key86_PS2K.asl"
    #include "SSDT-KEY102.dsl"
    #include "SSDT-USB-8x0-G3.dsl"
    #include "SSDT-XHC.dsl"
    #include "SSDT-BATT-G3.dsl"
    #include "SSDT-RP01_PEGP_RDSS.dsl"

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
