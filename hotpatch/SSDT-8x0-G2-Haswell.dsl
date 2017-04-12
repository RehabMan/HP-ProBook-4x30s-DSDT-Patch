// SSDT for 8x0 G2 Haswell

DefinitionBlock ("", "SSDT", 2, "hack", "8x0g2h", 0)
{
    #include "SSDT-HACK.dsl"
    #include "include/layout3_HDEF.asl"
    #include "include/layout3_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY102.dsl"
    #include "SSDT-USB-820-G2.dsl" //REVIEW: rename to USB-8x0-G2
    #include "SSDT-XHC.dsl"
    #include "SSDT-BATT-G2.dsl"
    #include "SSDT-RP05_DGFX_RDSS.dsl"
}
//EOF
