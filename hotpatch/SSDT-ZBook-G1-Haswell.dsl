// SSDT for ZBook G1 (Haswell)

DefinitionBlock ("", "SSDT", 2, "hack", "zbg1h", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-PluginType1.asl"
    #include "SSDT-RP05_DGFX_RDSS.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout17_HDEF.asl"
    #include "include/layout17_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    #include "SSDT-USB-ZBook-G1.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT.asl"
    #include "include/disable_EH01.asl"
}
//EOF
