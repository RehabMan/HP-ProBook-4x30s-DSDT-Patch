// SSDT for 8x0 G1 Haswell

DefinitionBlock ("", "SSDT", 2, "hack", "8x0g1h", 0)
{
    #include "include/standard_PS2K.asl"
    Include("include/layout17_HDEF.asl")
    Include("include/layout17_HDAU.asl")
}
//EOF
