// SSDT for 8x0 G1 Haswell

DefinitionBlock ("", "SSDT", 2, "hack", "8x0g1h", 0)
{
    #include "SSDT-HACK.dsl"
    #include "include/layout17_HDEF.asl"
    #include "include/layout17_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.dsl"
    #include "SSDT-USB-8x0-G1.dsl"
    #include "SSDT-XHC.dsl"
    #include "SSDT-BATT.dsl"
    #include "SSDT-RP05_DGFX_RDSS.dsl"
}
//EOF
