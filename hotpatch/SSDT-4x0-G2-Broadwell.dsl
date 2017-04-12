// SSDT for 4x0 G2 Broadwell

DefinitionBlock ("", "SSDT", 2, "hack", "4x0g2b", 0)
{
    #include "SSDT-HACK.dsl"
    #include "include/layout3_HDEF.asl"
    #include "include/layout3_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.dsl"
    #include "SSDT-USB-4x0-G2.dsl"
    #include "SSDT-XHC.dsl"
    #include "SSDT-BATT-G2.dsl"
    #include "SSDT-RP05_DGFX_RDSS.dsl"
}
//EOF
