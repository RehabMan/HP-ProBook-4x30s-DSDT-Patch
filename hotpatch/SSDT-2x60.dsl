// SSDT for 2x60

DefinitionBlock ("", "SSDT", 2, "hack", "2x60", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-PEGP_DGFX_RDSS.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout18_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY102.asl"
    #include "SSDT-USB-6x60.asl"    // 2x60 uses same USB as 6x60
    #include "SSDT-EH01.asl"
    #include "SSDT-EH02.asl"
    #include "SSDT-BATT.asl"
}
//EOF
