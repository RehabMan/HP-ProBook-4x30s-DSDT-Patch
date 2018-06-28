// SSDT for 6x60

DefinitionBlock("", "SSDT", 2, "hack", "_6x60", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-PEGP_DGFX_RDSS.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout128_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    #include "SSDT-USB-6x60.asl"
    #include "SSDT-EH01.asl"
    #include "SSDT-EH02.asl"
    #include "SSDT-BATT.asl"
}
//EOF
