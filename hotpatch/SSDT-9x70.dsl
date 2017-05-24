// SSDT for 9x70

DefinitionBlock ("", "SSDT", 2, "hack", "9x70", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout17_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    #include "SSDT-USB-9x70.asl"
    #include "SSDT-EH01.asl"
    #include "SSDT-EH02.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT.asl"
}
//EOF
