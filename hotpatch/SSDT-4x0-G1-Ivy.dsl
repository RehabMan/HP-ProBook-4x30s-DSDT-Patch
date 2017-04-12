// SSDT for 4x0 G1 Ivy

DefinitionBlock ("", "SSDT", 2, "hack", "4x0g1i", 0)
{
    #include "SSDT-HACK.dsl"
    #include "include/layout17_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.dsl"
    //#include "SSDT-USB-4x0-G1-Ivy.dsl"
    #include "SSDT-EH01.dsl"
    #include "SSDT-EH02.dsl"
    #include "SSDT-XHC.dsl"
    #include "SSDT-BATT.dsl"
}
//EOF
