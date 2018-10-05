// SSDT for 8x0 G3 Broadwell

DefinitionBlock("", "SSDT", 2, "hack", "_8x0G2b", 0)
{
    #define OVERRIDE_XPEE 1
    #include "SSDT-RMCF.asl"
    #include "SSDT-RP05_DGFX_RDSS.asl"
    #include "SSDT-HACK.asl"
    #include "include/ALC280_HDEF.asl"
    #include "include/ALC280_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    #include "SSDT-USB-8x0-G2.asl"  //REVIEW: may not be correct USB setup
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT-G3.asl"
    #include "include/disable_EH01.asl"
}
//EOF
