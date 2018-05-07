// SSDT for ZBook G2 (Broadwell)

DefinitionBlock("", "SSDT", 2, "hack", "_zbG2b", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-RP05_DGFX_RDSS.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout4_HDEF.asl"
    #include "include/layout4_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    #include "SSDT-USB-ZBook-G2.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT-G2.asl"
    #include "include/disable_EH01.asl"
}
//EOF
