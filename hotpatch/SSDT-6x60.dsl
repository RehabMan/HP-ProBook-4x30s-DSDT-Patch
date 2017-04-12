// SSDT for 6x60

DefinitionBlock ("", "SSDT", 2, "hack", "6x60", 0)
{
    #include "SSDT-HACK.dsl"
    #include "include/layout18_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.dsl"
    #include "SSDT-USB-6x60.dsl"
    #include "SSDT-EH01.dsl"
    #include "SSDT-EH02.dsl"
    #include "SSDT-BATT.dsl"
}
//EOF
