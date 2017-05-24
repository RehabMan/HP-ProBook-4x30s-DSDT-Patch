// SSDT for 8x0 G2 Broadwell

DefinitionBlock ("", "SSDT", 2, "hack", "8x0g2b", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-PluginType1.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout4_HDEF.asl"
    #include "include/layout4_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    #include "SSDT-USB-8x0-G2.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT-G2.asl"
    #include "SSDT-RP05_DGFX_RDSS.asl"
}
//EOF
