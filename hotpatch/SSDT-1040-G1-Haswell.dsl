// SSDT for 1040 G1 (Haswell)

DefinitionBlock ("", "SSDT", 2, "hack", "1040g1h", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-PluginType1.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout17_HDEF.asl"
    #include "include/layout17_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY102.asl"
    //#include "SSDT-USB-1040-G1.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT.asl"
    #include "SSDT-EH01.asl" //REVIEW: placing at end as no USB customization data available
    #include "SSDT-EH02.asl" //REVIEW: placing at end as no USB customization data available
}
//EOF
