// SSDT for 9x80m Haswell

DefinitionBlock ("", "SSDT", 2, "hack", "9x80", 0)
{
    #include "SSDT-HACK.dsl"
    #include "include/layout4_HDEF.asl"
    #include "include/layout4_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.dsl"
    #include "SSDT-USB-9x80.dsl"
    #include "SSDT-EH01.dsl"
    #include "SSDT-EH02.dsl"
    #include "SSDT-XHC.dsl"
    #include "SSDT-BATT.dsl"
}
//EOF
