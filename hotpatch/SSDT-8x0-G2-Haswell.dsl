// SSDT for 8x0 G2 Haswell

DefinitionBlock ("", "SSDT", 2, "hack", "8x0g2h", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-PluginType1.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout3_HDEF.asl"
    #include "include/layout3_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY102.asl"
    #include "SSDT-USB-8x0-G2.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT-G2.asl"
    #include "SSDT-RP05_DGFX_RDSS.asl"
}
//EOF
