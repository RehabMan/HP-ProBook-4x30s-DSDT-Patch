// SSDT for 8x0 G2 Haswell

DefinitionBlock ("", "SSDT", 2, "hack", "8x0g2h", 0)
{
    #include "include/standard_PS2K.asl"
    Include("include/layout3_HDEF.asl")
    Include("include/layout3_HDAU.asl")
}
//EOF
