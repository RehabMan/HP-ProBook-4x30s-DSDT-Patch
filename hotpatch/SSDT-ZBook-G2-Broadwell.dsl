// SSDT for ZBook G2 (Broadwell)

DefinitionBlock ("", "SSDT", 2, "hack", "zbg2b", 0)
{
    #include "include/standard_PS2K.asl"
    Include("include/layout4_HDEF.asl")
    Include("include/layout4_HDAU.asl")
}
//EOF
