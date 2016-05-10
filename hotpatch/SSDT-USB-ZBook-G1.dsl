// USBInjectAll configuration/override for ZBook G1 Haswell
//
// Based on secret-sounds' HP ZBook 17 G1 (Haswell)

DefinitionBlock ("", "SSDT", 2, "hack", "usbzbg1", 0)
{
//
// Override for USBInjectAll.kext
//
    Device(UIAC)
    {
        Name(_HID, "UIA00000")
        Name(RMCF, Package()
        {
            // EH01 has no ports (XHCIMux is used to force USB3 routing OFF)
            "EH01", Package()
            {
                "port-count", Buffer() { 0, 0, 0, 0 },
                "ports", Package() { },
            },
            // XHC overrides
            "8086_8c31", Package()
            {
                //"port-count", Buffer() { 0x0d, 0, 0, 0},
                "ports", Package()
                {
                    // HS01 not used
                    "HS02", Package() // HS on USB3 port SSP2
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x02, 0, 0, 0 },
                    },
                    // HS03,HS04,HS05 not used
                    "HS06", Package() // USB2, left back
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 0x06, 0, 0, 0 },
                    },
                    "HS07", Package() // camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x07, 0, 0, 0 },
                    },
                    // HS08 not used
                    "HS09", Package() // HS on USB3 port SSP5
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x09, 0, 0, 0 },
                    },
                    "HS10", Package() // HS on USB3 port SSP6
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x0a, 0, 0, 0 },
                    },
                    // HS11 not used
                    "HS12", Package() // bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x0c, 0, 0, 0 },
                    },
                    // HS13,HS14 not used
                    // SSP1 not used
                    "SSP2", Package() // USB3, right front
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x11, 0, 0, 0 },
                    },
                    // SSP3/SSP4 not used
                    "SSP5", Package() // USB3, right back
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x14, 0, 0, 0 },
                    },
                    "SSP6", Package() // USB3, left back
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x15, 0, 0, 0 },
                    },
                },
            },
        })
    }

//
// Disabling EHCI #1
//
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
}

//EOF