// SSDT for 4x30s

DefinitionBlock ("", "SSDT", 2, "hack", "4x30", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-PEGP_DGFX_RDSS.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout12_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY102.asl"
    #include "SSDT-USB-4x30s.asl"
    #include "SSDT-EH01.asl"
    #include "SSDT-EH02.asl"
    #include "SSDT-BATT.asl"
}
//EOF
