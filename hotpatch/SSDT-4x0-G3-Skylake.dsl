// SSDT for ProBook 4x0 G3 (Skylake)

DefinitionBlock ("", "SSDT", 2, "hack", "4x0g3s", 0)
{
    #include "include/standard_PS2K.asl"
    Include("include/disable_HECI.asl")
    Include("include/layout5_HDEF.asl")

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
