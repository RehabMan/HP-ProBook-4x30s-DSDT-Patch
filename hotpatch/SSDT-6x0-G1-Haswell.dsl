// SSDT for 6x0 G1 Haswell

DefinitionBlock ("", "SSDT", 2, "hack", "6x0g1h", 0)
{
    #define OVERRIDE_IGPI 0x0d260007
    #define OVERRIDE_LMAX 0x07a1
    #include "SSDT-RMCF.asl"
    #include "SSDT-PEGP_DGFX_RDSS.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout17_HDEF.asl"
    #include "include/layout17_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    #include "SSDT-USB-6x0-G1.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT.asl"
    #include "include/disable_EH01-EH02.asl"
}
//EOF
