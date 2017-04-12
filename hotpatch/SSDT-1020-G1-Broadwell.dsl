// SSDT for EliteBook Folio 1020 G1 (Broadwell)

DefinitionBlock ("", "SSDT", 2, "hack", "1020g1b", 0)
{
    #include "SSDT-HACK.asl"
    #include "include/layout6_HDEF.asl"
    #include "include/layout6_HDAU.asl"

    //#include "include/standard_PS2K.asl"
    External(_SB.PCI0.LPCB.PS2K, DeviceObj)
    Scope (_SB.PCI0.LPCB.PS2K)
    {
        // overrides for VoodooPS2 configuration...
        Name(RMCF, Package()
        {
            "Mouse", Package()
            {
                "DisableDevice", ">n",
            },
            #if 0
            "Synaptics TouchPad", Package()
            {
                "ForceSynapticsDetect", ">y",
                "DynamicEWMode", ">n",
            },
            #endif
        })
    }

    #include "SSDT-KEY87.asl"
    #include "SSDT-USB-1020-G1.asl"
    #include "SSDT-XHC.asl"
    #include "SSDT-BATT-G2.asl"
    #include "SSDT-RP05_DGFX_RDSS.asl"
}
//EOF
