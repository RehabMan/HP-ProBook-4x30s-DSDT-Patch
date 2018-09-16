// SSDT for ProBook 4x0 G4 (Kabylake)

DefinitionBlock("", "SSDT", 2, "hack", "_4x0G4k", 0)
{
    #define OVERRIDE_XPEE 1
    #include "SSDT-RMCF.asl"
    #include "SSDT-RP01_PXSX_RDSS.asl"
    #include "SSDT-HACK.asl"
    #include "include/CX8200_HDEF.asl"
    #include "include/disable_HECI.asl"
    #include "include/key86_PS2K.asl"
    #include "SSDT-KEY87.asl"
    #include "SSDT-USB-4x0-G4.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT-G4.asl"
    #include "SSDT-USBX.asl"
    #include "SSDT-ALS0.asl"
    #include "SSDT-USWE.asl"
}
//EOF
