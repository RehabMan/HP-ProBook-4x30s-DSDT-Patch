// SSDT for 1040 G1 (Haswell)

DefinitionBlock ("", "SSDT", 2, "hack", "1040g1h", 0)
{
    Include("include/disable_CC.asl")
    Include("include/layout17_HDEF.asl")
}
//EOF
