// SSDT for ProBook 5x30

DefinitionBlock("", "SSDT", 2, "hack", "_5x30", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-PEGP_DGFX_RDSS.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout18_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    //#include "SSDT-USB-5x30.asl"
    #include "SSDT-BATT.asl"
    #include "SSDT-EH01.asl" //REVIEW: placing at end as no USB customization data available
    #include "SSDT-EH02.asl" //REVIEW: placing at end as no USB customization data available
}
//EOF
