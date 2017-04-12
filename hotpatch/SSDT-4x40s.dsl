// SSDT for 4x40s

DefinitionBlock ("", "SSDT", 2, "hack", "4x40", 0)
{
    #include "SSDT-HACK.dsl"
    #include "include/layout13_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY102.dsl"
    #include "SSDT-USB-4x40s.dsl"
    #include "SSDT-EH01.dsl"
    #include "SSDT-EH02.dsl"
    #include "SSDT-XHC.dsl"
    #include "SSDT-BATT.dsl"
}
//EOF
