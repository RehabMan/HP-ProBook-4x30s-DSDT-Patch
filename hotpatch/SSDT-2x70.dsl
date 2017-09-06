// SSDT for 2x70

DefinitionBlock ("", "SSDT", 2, "hack", "2x70", 0)
{
    #include "SSDT-RMCF.asl"
    #include "SSDT-HACK.asl"
    #include "include/layout18_HDEF.asl"
    #include "include/standard_PS2K.asl"
    #include "SSDT-KEY87.asl"
    //#include "SSDT-USB-2x70.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT.asl"
    #include "SSDT-EH01.asl" //REVIEW: placing at end as no USB customization data available
    #include "SSDT-EH02.asl" //REVIEW: placing at end as no USB customization data available
}
//EOF
