// SSDT for 8x0 G1 Haswell

DefinitionBlock ("", "SSDT", 2, "hack", "8x0g1h", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-PluginType1.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout17_HDEF.asl"
    #include "include/layout17_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    #include "SSDT-USB-8x0-G1.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT.asl"
    #include "SSDT-RP05_DGFX_RDSS.asl"
}
//EOF
