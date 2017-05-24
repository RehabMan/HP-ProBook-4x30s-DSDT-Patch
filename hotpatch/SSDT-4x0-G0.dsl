// SSDT for 4x0 G0

DefinitionBlock ("", "SSDT", 2, "hack", "4x0g0", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout17_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    //#include "SSDT-USB-4x0-G0.asl"
    #include "SSDT-EH01.asl"
    #include "SSDT-EH02.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT.asl"
}
//EOF
