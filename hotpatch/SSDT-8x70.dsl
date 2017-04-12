// SSDT for 8x70

DefinitionBlock ("", "SSDT", 2, "hack", "8x70", 0)
{
    #include "SSDT-HACK.dsl"
    #include "include/layout18_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.dsl"
    #include "SSDT-USB-8x70.dsl"
    #include "SSDT-EH01.dsl"
    #include "SSDT-EH02.dsl"
    #include "SSDT-XHC.dsl"
    #include "SSDT-BATT.dsl"
}
//EOF
