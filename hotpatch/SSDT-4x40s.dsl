// SSDT for 4x40s

DefinitionBlock ("", "SSDT", 2, "hack", "4x40", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout13_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY102.asl"
    #include "SSDT-USB-4x40s.asl"
    #include "SSDT-EH01.asl"
    #include "SSDT-EH02.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT.asl"
}
//EOF
