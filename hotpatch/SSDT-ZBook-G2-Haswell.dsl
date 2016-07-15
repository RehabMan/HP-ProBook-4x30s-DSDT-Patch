// SSDT for ZBook G2 (Haswell)

DefinitionBlock ("", "SSDT", 2, "hack", "zbg2h", 0)
{
    #include "include/standard_PS2K.asl"
    Include("include/layout17_HDEF.asl")
    Include("include/layout17_HDAU.asl")
}
//EOF
