// USBInjectAll configuration/override for EliteBook 850 G2 Broadwell
//
//REVIEW: currently this is exactly the same as for the EliteBook 820 G2 Broadwell
// (maybe can consolidate)

//REVIEW: preliminary data for G2.  Note that it has a hub on XHC, which
//  may need further work.

// Based on information provided from EliteBook Pro 850 G2

// set DISABLE_EHCI to 0 if you want to try with USB2 on XHCI routed to EHCI
#define DISABLE_EHCI 1

DefinitionBlock ("", "SSDT", 2, "hack", "usb850g2", 0)
{
//
// Override for USBInjectAll.kext
//
    Device(UIAC)
    {
        Name(_HID, "UIA00000")
        Name(RMCF, Package()
        {
#if !DISABLE_EHCI
            // EHCI#1
            "EH01", Package()
            {
                "port-count", Buffer() { 8, 0, 0, 0 },
                "ports", Package()
                {
                    "PR11", Package()
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                },
            },
            /// hub on port #1 EHCI#1
            "HUB1", Package()
            {
                "port-count", Buffer() { 8, 0, 0, 0 },
                "ports", Package()
                {
                    //HP11 not used
                    "HP12", Package()
                    {
                        //"UsbConnector", 3,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HP13", Package() // USB2 hub (related SSP3 hub)
                    {
                        //"UsbConnector", 255,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HP14", Package() // bluetooth
                    {
                        //"UsbConnector", 255,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    //HP15 finger print reader
                    //HP16 not used
                    "HP17", Package() // camera
                    {
                        //"UsbConnector", 255,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    //HP18 not used
                },
            },
#endif
            // XHC overrides
            "8086_9cb1", Package()
            {
                //"port-count", Buffer() { 0x0f, 0, 0, 0},
                "ports", Package()
                {
#if DISABLE_EHCI
                    // HS01 not used
                    "HS02", Package() // USB2 (SSP2 is USB3)
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 0x02, 0, 0, 0 },
                    },
                    "HS03", Package() // internal 4-port USB2 hub (SSP3 is USB3)
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x03, 0, 0, 0 },
                    },
                    "HS04", Package() // bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x04, 0, 0, 0 },
                    },
                    //HS05 is fingerprint reader (disabled)
                    //HS06 not used
                    "HS07", Package() // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x07, 0, 0, 0 },
                    },
                    // HS08/HS09/HS10/HS11 not used
#endif
                    // SSP1 not used
                    "SSP2", Package() // SS USB3 port
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x0d, 0, 0, 0 },
                    },
                    "SSP3", Package() // SS USB3 hub (HS03.port2 is USB2?)
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x0e, 0, 0, 0 },
                    },
                    // SSP4 not used
                },
            },
        })
    }

//
// Disabling EHCI #1
//

#if DISABLE_EHCI
    External(_SB.PCI0, DeviceObj)
    External(_SB.PCI0.LPCB, DeviceObj)
    External(_SB.PCI0.EH01, DeviceObj)

    // registers needed for disabling EHC#1
    Scope(_SB.PCI0.EH01)
    {
        OperationRegion(PSTS, PCI_Config, 0x54, 2)
        Field(PSTS, WordAcc, NoLock, Preserve)
        {
            PSTE, 2  // bits 2:0 are power state
        }
    }
    Scope(_SB.PCI0.LPCB)
    {
        OperationRegion(RMLP, PCI_Config, 0xF0, 4)
        Field(RMLP, DWordAcc, NoLock, Preserve)
        {
            RCB1, 32, // Root Complex Base Address
        }
        // address is in bits 31:14
        OperationRegion(FDM1, SystemMemory, (RCB1 & Not((1<<14)-1)) + 0x3418, 4)
        Field(FDM1, DWordAcc, NoLock, Preserve)
        {
            ,15,    // skip first 15 bits
            FDE1,1, // should be bit 15 (0-based) (FD EHCI#1)
        }
    }
    Scope(_SB.PCI0)
    {
        Device(RMD2)
        {
            //Name(_ADR, 0)
            Name(_HID, "RMD20000")
            Method(_INI)
            {
                // disable EHCI#1
                // put EHCI#1 in D3hot (sleep mode)
                ^^EH01.PSTE = 3
                // disable EHCI#1 PCI space
                ^^LPCB.FDE1 = 1
            }
        }
    }

//
// Configure FakePCIID_XHCIMux.kext to handle USB2 on XHC
//
    External(_SB.PCI0.XHC, DeviceObj)
    Method(_SB.PCI0.XHC._DSM, 4)
    {
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Return (Package()
        {
            "RM,pr2-force", Buffer() { 0xff, 0x3f, 0, 0 },
        })
    }
#endif
}

//EOF