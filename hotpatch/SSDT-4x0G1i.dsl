// SSDT for 4x0 G1 Ivy

DefinitionBlock("", "SSDT", 2, "hack", "_4x0G1i", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-PEGP_DGFX_RDSS.asl"
    #include "SSDT-HACK.asl"
    #include "include/IDT_76e0_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    //#include "SSDT-USB-4x0-G1-Ivy.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT.asl"
    #include "SSDT-EH01.asl" //REVIEW: placing at end as no USB customization data available
    #include "SSDT-EH02.asl" //REVIEW: placing at end as no USB customization data available
}
//EOF
