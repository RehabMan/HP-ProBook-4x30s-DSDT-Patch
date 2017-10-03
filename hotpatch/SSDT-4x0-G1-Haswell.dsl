// SSDT for 4x0 G1 Haswell

DefinitionBlock ("", "SSDT", 2, "hack", "4x0g1h", 0)
{
    #include "SSDT-RMCF.asl"
    #include "include/ig_0d260007.asl"
    #include "SSDT-PluginType1.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout17_HDEF.asl"
    #include "include/layout17_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    #include "SSDT-USB-4x0-G1.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT.asl"
}
//EOF
