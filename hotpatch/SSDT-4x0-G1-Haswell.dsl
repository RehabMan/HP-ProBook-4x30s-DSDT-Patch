// SSDT for 4x0 G1 Haswell

DefinitionBlock ("", "SSDT", 2, "hack", "4x0g1h", 0)
{
    Include("include/disable_CC.asl")
    Include("include/layout17_HDEF.asl")
    Include("include/layout17_HDAU.asl")
}
//EOF
