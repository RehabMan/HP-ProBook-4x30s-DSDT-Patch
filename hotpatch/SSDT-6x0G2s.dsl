// SSDT for EliteBook 6x0 G2 (Skylake)

DefinitionBlock("", "SSDT", 2, "hack", "_6x0G2s", 0)
{
    #define OVERRIDE_XPEE 1
    #include "SSDT-RMCF.asl"
    #include "SSDT-RP05_PEGP_RDSS.asl"
    #include "SSDT-HACK.asl"
    #include "include/CX20724_HDEF.asl"
    #include "include/disable_HECI.asl"
    #include "include/key86_PS2K.asl"
    #include "SSDT-KEY102.asl"
    #include "SSDT-USB-640-G2.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT-G2.asl"
    #include "SSDT-USBX.asl"
    #include "SSDT-ALS0.asl"
    #include "SSDT-USWE.asl"
}
//EOF
