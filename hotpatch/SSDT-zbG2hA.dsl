// SSDT for ZBook G2 (Haswell) with ALC280

DefinitionBlock("", "SSDT", 2, "hack", "_zbG2hA", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-RP05_DGFX_RDSS.asl"
    #include "SSDT-HACK.asl"
    #include "include/ALC280_HDEF.asl"
    #include "include/ALC280_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    #include "SSDT-USB-ZBook-G2.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT-G2.asl"
    #include "include/disable_EH01-EH02.asl"
}
//EOF
