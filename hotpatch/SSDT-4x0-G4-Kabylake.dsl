// SSDT for ProBook 4x0 G4 (Kabylake)

DefinitionBlock ("", "SSDT", 2, "hack", "4x0g4k", 0)
{
    #include "include/standard_PS2K.asl"
    Include("include/disable_HECI.asl")
    Include("include/layout20_HDEF.asl")

    // This USWE code is specific to the Skylake G3 (and now Kabylake G4)
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
