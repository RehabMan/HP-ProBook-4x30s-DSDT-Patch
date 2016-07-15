// Standard PS2 overrides
// Use Include directive from model specific SSDT

    External(\_SB.PCI0.LPCB.PS2K, DeviceObj)
    Scope (\_SB.PCI0.LPCB.PS2K)
    {
        // overrides for VoodooPS2 configuration...
        Name(RMCF, Package()
        {
            #include "include/standard_PS2K_data.asl"
        })
    }
