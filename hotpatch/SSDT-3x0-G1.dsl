// SSDT for 3x0 G1

DefinitionBlock ("", "SSDT", 2, "hack", "3x0g1", 0)
{
    #include "SSDT-HACK.asl"
    #include "include/layout19_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    //#include "SSDT-USB-3x0-G1.asl"
    #include "SSDT-EH01.asl"
    #include "SSDT-EH02.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT.asl"
}
//EOF
