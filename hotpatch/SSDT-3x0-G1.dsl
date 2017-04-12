// SSDT for 3x0 G1

DefinitionBlock ("", "SSDT", 2, "hack", "3x0g1", 0)
{
    #include "SSDT-HACK.dsl"
    #include "include/layout19_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.dsl"
    //#include "SSDT-USB-3x0-G1.dsl"
    #include "SSDT-EH01.dsl"
    #include "SSDT-EH02.dsl"
    #include "SSDT-XHC.dsl"
    #include "SSDT-BATT.dsl"
}
//EOF
