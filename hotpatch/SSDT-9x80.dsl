// SSDT for 9x80m Haswell

DefinitionBlock ("", "SSDT", 2, "hack", "9x80", 0)
{
    #include "include/standard_PS2K.asl"
    Include("include/layout4_HDEF.asl")
    Include("include/layout4_HDAU.asl")
}
//EOF
