// SSDT for 4x0 G2 Haswell

DefinitionBlock ("", "SSDT", 2, "hack", "4x0g2h", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-PluginType1.asl"
    #include "SSDT-RP05_DGFX_RDSS.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout3_HDEF.asl"
    #include "include/layout3_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    #include "SSDT-USB-4x0-G2.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT-G2.asl"
}
//EOF
