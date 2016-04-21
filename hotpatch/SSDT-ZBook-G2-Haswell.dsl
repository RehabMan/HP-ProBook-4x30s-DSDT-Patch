// SSDT for ZBook G2 (Haswell)

DefinitionBlock ("", "SSDT", 2, "hack", "zbg2h", 0)
{
    //Include("include/disable_CC.asl")
    Include("include/ALC280_CC.asl")
    Include("include/layout4_HDEF.asl")
    Include("include/layout4_HDAU.asl")
}
//EOF
