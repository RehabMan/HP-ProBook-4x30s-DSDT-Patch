// SSDT for ZBook G2 (Haswell)

DefinitionBlock ("", "SSDT", 2, "hack", "zbg2h", 0)
{
    #include "SSDT-HACK.dsl"
    #include "include/layout17_HDEF.asl"
    #include "include/layout17_HDAU.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.dsl"
    #include "SSDT-USB-ZBook-G2.dsl"
    #include "SSDT-XHC.dsl"
    #include "SSDT-BATT-G2.dsl"
}
//EOF
