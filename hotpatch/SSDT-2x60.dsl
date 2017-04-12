// SSDT for 2x60

DefinitionBlock ("", "SSDT", 2, "hack", "2x60", 0)
{
    #include "SSDT-HACK.dsl"
    #include "include/layout18_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY102.dsl"
    #include "SSDT-USB-6x60.dsl"    // 2x60 uses same USB as 6x60
    #include "SSDT-EH01.dsl"
    #include "SSDT-EH02.dsl"
    #include "SSDT-BATT.dsl"
}
//EOF
