// SSDT for 6x0 G1 Haswell

DefinitionBlock ("", "SSDT", 2, "hack", "6x0g1h", 0)
{
    #include "SSDT-HACK.dsl"
    #include "include/layout17_HDEF.asl"
    #include "include/layout17_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.dsl"
    #include "SSDT-USB-6x0-G1.dsl"
    #include "SSDT-XHC.dsl"
    #include "SSDT-BATT.dsl"
}
//EOF
