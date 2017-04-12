// SSDT for ProBook 5x30

DefinitionBlock ("", "SSDT", 2, "hack", "5x30", 0)
{
    #include "SSDT-HACK.dsl"
    #include "include/layout18_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.dsl"
    //#include "SSDT-USB-5x30.dsl"
    #include "SSDT-EH01.dsl"
    #include "SSDT-EH02.dsl"
    #include "SSDT-BATT.dsl"
}
//EOF
