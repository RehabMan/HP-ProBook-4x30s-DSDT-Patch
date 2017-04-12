// SSDT for 1040 G1 (Haswell)

DefinitionBlock ("", "SSDT", 2, "hack", "1040g1h", 0)
{
    #include "SSDT-HACK.dsl"
    #include "include/layout17_HDEF.asl"
    #include "include/layout17_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY102.dsl"
    //#include "SSDT-USB-1040-G1.dsl"
    #include "SSDT-EH01.dsl"
    #include "SSDT-EH02.dsl"
    #include "SSDT-XHC.dsl"
    #include "SSDT-BATT.dsl"
}
//EOF
