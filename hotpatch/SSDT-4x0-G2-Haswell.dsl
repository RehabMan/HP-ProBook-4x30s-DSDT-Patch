// SSDT for 4x0 G2 Haswell

DefinitionBlock ("", "SSDT", 2, "hack", "4x0g2h", 0)
{
    #include "SSDT-HACK.dsl"
    #include "include/layout3_HDEF.asl"
    #include "include/layout3_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.dsl"
    #include "SSDT-USB-4x0-G2.dsl"
    #include "SSDT-XHC.dsl"
    #include "SSDT-BATT-G2.dsl"
}
//EOF
