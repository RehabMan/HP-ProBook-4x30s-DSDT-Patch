// SSDT for ProBook 5x30

DefinitionBlock ("", "SSDT", 2, "hack", "5x30", 0)
{
    #include "SSDT-HACK.asl"
    #include "include/layout18_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    //#include "SSDT-USB-5x30.asl"
    #include "SSDT-EH01.asl"
    #include "SSDT-EH02.asl"
    #include "SSDT-BATT.asl"
}
//EOF
