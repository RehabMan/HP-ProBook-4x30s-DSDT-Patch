// SSDT for 8x0 G1 Ivy

DefinitionBlock ("", "SSDT", 2, "hack", "8x0g1i", 0)
{
    #include "SSDT-HACK.asl"
    #include "include/layout17_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY102.asl"
    //#include "SSDT-USB-8x0-G1-Ivy.asl"
    #include "SSDT-EH01.asl"
    #include "SSDT-EH02.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT.asl"
}
//EOF
