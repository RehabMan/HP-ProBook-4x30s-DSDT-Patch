// Instead of providing patched DSDT/SSDT, just include a single SSDT
// and do the rest of the work in config.plist

// A bit experimental, and a bit more difficult with laptops, but
// still possible.

DefinitionBlock ("", "SSDT", 1, "hack", "batt-G2", 0x00003000)
{
    External(\_SB.PCI0, DeviceObj)
    External(\_SB.PCI0.LPCB, DeviceObj)
    External(\_SB.PCI0.LPCB.EC0, DeviceObj)

    //REVIEW: perhaps this can be done in the ACPIBatteryManager.kext instead
    // Disable the secondary battery object
    External(_SB.BAT1, DeviceObj)
    Name(_SB.BAT1._STA, 0)

    Scope(\_SB.PCI0.LPCB.EC0)
    {
        // This is an override for battery methods that access EC fields
        // larger than 8-bit.
        OperationRegion (ECR2, EmbeddedControl, 0x00, 0xFF)
        Field (ECR2, ByteAcc, NoLock, Preserve)
        {
            Offset (0x87),
            ,8,//LB1,    8,
            ,8,//LB2,    8,
            BDC0, 8, BDC1, 8,
            Offset (0x8D),
            BFC0, 8, BFC1, 8,
            RTE0, 8, RTE1, 8,
            //BTC,    1,
            Offset (0x92),
            BME0, 8, BME1, 8,
            ,8,//BDN,    8,
            BDV0, 8, BDV1, 8,
            BCX0, 8, BCX1, 8,
            //BST,    4,
            Offset (0x9B),
            ATE0, 8, ATE1, 8,
            BPR0, 8, BPR1, 8,
            BCR0, 8, BCR1, 8,
            BRC0, 8, BRC1, 8,
            BCC0, 8, BCC1, 8,
            BPV0, 8, BPV1, 8,
            BCA0, 8, BCA1, 8,
            BCB0, 8, BCB1, 8,
            BCP0, 8, BCP1, 8,
            ,16,//BCW,    16,
            ATF0, 8, ATF1, 8,
            ,16,//BCL,    16,
            AXC0, 8, AXC1, 8,
            ,8,//BCG1,   8,
            ,1,//BT1I,   1,
            ,1,//BT2I,   1,
            ,2,//,   2,
            ,4,//BATN,   4,
            BST0, 8, BST1, 8,
            //...
            Offset (0xC9),
            BSN0, 8, BSN1, 8,
            BDA0, 8, BDA1, 8,
            //BMF,    8,
            //Offset (0xCF),
            //CTLB,   8,
            //Offset (0xD1),
            //BTY,    8,
            //Offset (0xD5),
            //MFAC,   8,//d5
            //CFAN,   8,//d6
            //PFAN,   8,//d7
            //OCPS,   8,//d8
            //OCPR,   8,//d9
            //OCPE,   8,//da
            //TMP1,   8,//db
            //TMP2,   8,//dc
            //NABT,   4,//dd
            //BCM,    4,
            //CCBQ,   16,//de
                Offset(0xe0),
            CBT0, 8, CBT1, 8,
            //...
        }
        
        External(\_SB.PCI0.LPCB.EC0.BTDR, MethodObj)
        External(\_SB.PCI0.LPCB.EC0.BSTA, MethodObj)
        External(\_SB.PCI0.LPCB.EC0.BTMX, MutexObj)
        External(\_SB.PCI0.LPCB.EC0.NGBF, IntObj)
        External(\_SB.PCI0.LPCB.EC0.NGBT, IntObj)
        External(\_SB.NBST, PkgObj)
        External(\_SB.NDBS, PkgObj)
        External(\_SB.PCI0.LPCB.EC0.ECMX, MutexObj)
        External(\_SB.PCI0.LPCB.EC0.ECRG, IntObj)
        External(\_SB.PCI0.LPCB.EC0.BSEL, FieldUnitObj)
        External(\_SB.PCI0.LPCB.EC0.NLB1, IntObj)
        External(\_SB.PCI0.LPCB.EC0.NLB2, IntObj)
        External(\_SB.PCI0.LPCB.EC0.CRZN, FieldUnitObj)
        External(\_SB.PCI0.LPCB.EC0.TEMP, FieldUnitObj)
        External(\_SB.PCI0.LPCB.EC0.GBSS, MethodObj)
        External(\_SB.PCI0.LPCB.EC0.BST, FieldUnitObj)
        External(\_SB.PCI0.LPCB.EC0.GACS, MethodObj)
        External(\_SB.PCI0.LPCB.EC0.NDCB, IntObj)
        External(\_SB.PCI0.LPCB.EC0.BATP, FieldUnitObj)
        External(\_SB.PCI0.LPCB.EC0.INCH, FieldUnitObj)
        External(\_SB.PCI0.LPCB.EC0.IDIS, FieldUnitObj)
        External(\_SB.PCI0.LPCB.EC0.INAC, FieldUnitObj)
        External(\_SB.PCI0.LPCB.EC0.PSSB, FieldUnitObj)
        External(\_SB.PCI0.LPCB.EC0.GBMF, MethodObj)
        External(\_SB.PCI0.LPCB.EC0.GCTL, MethodObj)
        External(\_SB.PCI0.LPCB.EC0.GDNM, MethodObj)
        External(\_SB.PCI0.LPCB.EC0.GDCH, MethodObj)
        External(\_SB.PCI0.LPCB.EC0.BRCC, FieldUnitObj)
        External(\_SB.PCI0.LPCB.EC0.BRCV, FieldUnitObj)
        External(\_SB.PCI0.LPCB.EC0.BATN, FieldUnitObj)
        External(\PRDT, FieldUnitObj)
        
        // BTIF/BTST methods are renamed in native DSDT, so calls land here...
        Method (BTIF, 1, Serialized)
        {
            ShiftLeft (0x01, Arg0, Local7)
            BTDR (0x01)
            If (LEqual (BSTA (Local7), 0x0F))
            {
                Return (0xFF)
            }

            Acquire (BTMX, 0xFFFF)
            Store (NGBF, Local0)
            Release (BTMX)
            If (LEqual (And (Local0, Local7), 0x00))
            {
                Return (0x00)
            }

            Store (NDBS, Index (NBST, Arg0))
            Acquire (BTMX, 0xFFFF)
            Or (NGBT, Local7, NGBT)
            Release (BTMX)
            Acquire (ECMX, 0xFFFF)
            If (ECRG)
            {
                Store (Arg0, BSEL)
                Store (B1B2 (BFC0, BFC1), Local0)
                Store (Local0, Index (DerefOf (Index (NBTI, Arg0)), 0x01))
                Store (Local0, Index (DerefOf (Index (NBTI, Arg0)), 0x02))
                Store (B1B2 (BDV0, BDV1), Index (DerefOf (Index (NBTI, Arg0)), 0x04))
                Store (NLB1, Index (DerefOf (Index (NBTI, Arg0)), 0x05))
                Store (NLB2, Index (DerefOf (Index (NBTI, Arg0)), 0x06))
                Store (B1B2 (BSN0, BSN1), Local0)
                Store (B1B2 (BDA0, BDA1), Local1)
                // battery cycle count
                Store (B1B2 (BCC0, BCC1), Index (DerefOf (Index (NBTI, Arg0)), 0x0D))
                // battery temperature
                Acquire (\_SB.PCI0.LPCB.EC0.ECMX, 0xFFFF)
                Store (5, \_SB.PCI0.LPCB.EC0.CRZN)
                Store (\_SB.PCI0.LPCB.EC0.TEMP, Local2)
                Release (\_SB.PCI0.LPCB.EC0.ECMX)
                Add (Multiply (Local2, 10), 2732, Local2) // Celsius to .1K
                Store (Local2, Index (DerefOf (Index (NBTI, Arg0)), 0x0E))

            }

            Release (ECMX)
            Store (GBSS (Local0, Local1), Local2)
            Store (Local2, Index (DerefOf (Index (NBTI, Arg0)), 0x0A))
            Acquire (BTMX, 0xFFFF)
            And (NGBF, Not (Local7), NGBF)
            Release (BTMX)
            Return (0x00)
        }

        Method (BTST, 2, Serialized)
        {
            ShiftLeft (0x01, Arg0, Local7)
            BTDR (0x01)
            If (LEqual (BSTA (Local7), 0x0F))
            {
                Store (Package (0x04)
                {
                    0x00,
                    0xFFFFFFFF,
                    0xFFFFFFFF,
                    0xFFFFFFFF
                }, Index (NBST, Arg0))
                Return (0xFF)
            }

            Acquire (BTMX, 0xFFFF)
            If (Arg1)
            {
                Store (0xFF, NGBT)
            }

            Store (NGBT, Local0)
            Release (BTMX)
            If (LEqual (And (Local0, Local7), 0x00))
            {
                Return (0x00)
            }

            Acquire (ECMX, 0xFFFF)
            If (ECRG)
            {
                Store (Arg0, BSEL)
                Store (BST, Local0)
                Store (B1B2 (BCR0, BCR1), Local3)
                Store (B1B2 (BRC0, BRC1), Index (DerefOf (Index (NBST, Arg0)), 0x02))
                Store (B1B2 (BPV0, BPV1), Index (DerefOf (Index (NBST, Arg0)), 0x03))
            }

            Release (ECMX)
            If (LEqual (GACS (), 0x01))
            {
                And (Not (0x01), Local0, Local0)
            }
            Else
            {
                And (Not (0x02), Local0, Local0)
            }

            If (And (Local0, 0x01))
            {
                Acquire (BTMX, 0xFFFF)
                Store (Local7, NDCB)
                Release (BTMX)
            }

            Store (Local0, Index (DerefOf (Index (NBST, Arg0)), 0x00))
            If (And (Local0, 0x01))
            {
                If (LOr (LLess (Local3, 0x0190), LGreater (Local3, 0x1964)))
                {
                    Store (DerefOf (Index (DerefOf (Index (NBST, Arg0)), 0x01)), Local5)
                    If (LOr (LLess (Local5, 0x0190), LGreater (Local5, 0x1964)))
                    {
                        Store (Divide (0x1AF4, 0x02, ), Local3)
                    }
                    Else
                    {
                        Store (Local5, Local3)
                    }
                }
            }
            Else
            {
                If (LEqual (And (Local0, 0x02), 0x00))
                {
                    Store (0x00, Local3)
                }
            }

            Store (Local3, Index (DerefOf (Index (NBST, Arg0)), 0x01))
            Acquire (BTMX, 0xFFFF)
            And (NGBT, Not (Local7), NGBT)
            Release (BTMX)
            Return (0x00)
        }

        // SBTC is renamed in native DSDT so calls land here
        Method (SBTC, 3, NotSerialized)
        {
            Store ("Enter SetBatteryControl", Debug)
            Acquire (ECMX, 0xFFFF)
            If (ECRG)
            {
                Store (Arg2, Local0)
                Store (Local0, Debug)
                Store (Package (0x02)
                {
                    0x06,
                    0x00
                }, Local4)
                Store (0x00, Local1)
                Store (0x00, Local2)
                Store (DerefOf (Index (Local0, 0x10)), Local1)
                If (LEqual (Local1, 0x00))
                {
                    Store ("battery 0", Debug)
                    If (And (BATP, 0x01))
                    {
                        Store (DerefOf (Index (Local0, 0x11)), Local2)
                        If (LEqual (Local2, 0x00))
                        {
                            Store (0x00, INCH)
                            Store (0x00, IDIS)
                            Store (0x00, INAC)
                            Store (0x00, AXC0)
                            Store (0x00, AXC1)
                            Store (0x01, PSSB)
                            Store (Package (0x02)
                            {
                                0x00,
                                0x00
                            }, Local4)
                        }

                        If (LEqual (Local2, 0x01))
                        {
                            Store (0x00, INAC)
                            Store (0x02, INCH)
                            Store (0x01, IDIS)
                            Store (0x00, AXC0)
                            Store (0x00, AXC1)
                            Store (0x00, PSSB)
                            Store (Package (0x02)
                            {
                                0x00,
                                0x00
                            }, Local4)
                        }

                        If (LEqual (Local2, 0x02))
                        {
                            Store (0x01, INAC)
                            Store (0x01, INCH)
                            Store (0x02, IDIS)
                            Store (0x00, PSSB)
                            Store (Package (0x02)
                            {
                                0x00,
                                0x00
                            }, Local4)
                        }

                        If (LEqual (Local2, 0x03))
                        {
                            Store (0x02, INCH)
                            Store (0x01, IDIS)
                            Store (0x00, INAC)
                            Store (0xFA, AXC0)
                            Store (Zero, AXC1)
                            Store (0x00, PSSB)
                            Store (Package (0x02)
                            {
                                0x00,
                                0x00
                            }, Local4)
                        }

                        If (LEqual (Local2, 0x04))
                        {
                            Store (0xFA, AXC0)
                            Store (Zero, AXC1)
                            Store (Package (0x02)
                            {
                                0x00,
                                0x00
                            }, Local4)
                        }

                        If (LEqual (Local2, 0x05))
                        {
                            Store (0x00, INAC)
                            Store (0x03, INCH)
                            Store (Package (0x02)
                            {
                                0x00,
                                0x00
                            }, Local4)
                        }
                    }
                    Else
                    {
                        Store (Package (0x02)
                        {
                            0x34,
                            0x00
                        }, Local4)
                    }
                }

                If (LEqual (Local1, 0x01))
                {
                    If (And (BATP, 0x02))
                    {
                        Store ("battery 1", Debug)
                        Store (DerefOf (Index (Local0, 0x11)), Local2)
                        If (LEqual (Local2, 0x00))
                        {
                            Store (0x00, INCH)
                            Store (0x00, IDIS)
                            Store (0x00, INAC)
                            Store (0x00, AXC0)
                            Store (0x00, AXC1)
                            Store (0x01, PSSB)
                            Store (Package (0x02)
                            {
                                0x00,
                                0x00
                            }, Local4)
                        }

                        If (LEqual (Local2, 0x01))
                        {
                            Store (0x00, INAC)
                            Store (0x01, INCH)
                            Store (0x02, IDIS)
                            Store (0x00, AXC0)
                            Store (0x00, AXC1)
                            Store (0x00, PSSB)
                            Store (Package (0x02)
                            {
                                0x00,
                                0x00
                            }, Local4)
                        }

                        If (LEqual (Local2, 0x02))
                        {
                            Store (0x01, INAC)
                            Store (0x02, INCH)
                            Store (0x01, IDIS)
                            Store (0x00, PSSB)
                            Store (Package (0x02)
                            {
                                0x00,
                                0x00
                            }, Local4)
                        }

                        If (LEqual (Local2, 0x03))
                        {
                            Store (0x01, INCH)
                            Store (0x02, IDIS)
                            Store (0x00, INAC)
                            Store (0xFA, AXC0)
                            Store (Zero, AXC1)
                            Store (0x00, PSSB)
                            Store (Package (0x02)
                            {
                                0x00,
                                0x00
                            }, Local4)
                        }

                        If (LEqual (Local2, 0x04))
                        {
                            Store (0x00, INCH)
                            Store (0x00, IDIS)
                            Store (0x00, INAC)
                            Store (Package (0x02)
                            {
                                0x00,
                                0x00
                            }, Local4)
                        }

                        If (LEqual (Local2, 0x05))
                        {
                            Store (0x00, INAC)
                            Store (0x03, INCH)
                            Store (Package (0x02)
                            {
                                0x00,
                                0x00
                            }, Local4)
                        }
                    }
                    Else
                    {
                        Store (Package (0x02)
                        {
                            0x34,
                            0x00
                        }, Local4)
                    }
                }
            }

            Release (ECMX)
            Return (Local4)
        }

        // GBTI is renamed in native DSDT so calls land here
        Method (GBTI, 1, NotSerialized)
        {
            Store ("Enter getbattinfo", Debug)
            Acquire (ECMX, 0xFFFF)
            If (ECRG)
            {
                If (And (BATP, ShiftLeft (0x01, Arg0)))
                {
                    Store (Arg0, BSEL)
                    Store (Package (0x03)
                    {
                        0x00,
                        0x6B,
                        Buffer (0x6B) {}
                    }, Local0)
                    Store (B1B2 (BDC0, BDC1), Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (ShiftRight (B1B2 (BDC0, BDC1), 0x08), Index (DerefOf (Index (Local0, 0x02)), 0x01))
                    Store (B1B2 (BFC0, BFC1), Index (DerefOf (Index (Local0, 0x02)), 0x02))
                    Store (ShiftRight (B1B2 (BFC0, BFC1), 0x08), Index (DerefOf (Index (Local0, 0x02)), 0x03))
                    Store (B1B2 (BRC0, BRC1), Index (DerefOf (Index (Local0, 0x02)), 0x04))
                    Store (ShiftRight (B1B2 (BRC0, BRC1), 0x08), Index (DerefOf (Index (Local0, 0x02)), 0x05))
                    Store (B1B2 (BME0, BME1), Index (DerefOf (Index (Local0, 0x02)), 0x06))
                    Store (ShiftRight (B1B2 (BME0, BME1), 0x08), Index (DerefOf (Index (Local0, 0x02)), 0x07))
                    Store (B1B2 (BCC0, BCC1), Index (DerefOf (Index (Local0, 0x02)), 0x08))
                    Store (ShiftRight (B1B2 (BCC0, BCC1), 0x08), Index (DerefOf (Index (Local0, 0x02)), 0x09))
                    Store (B1B2 (CBT0, CBT1), Local1)
                    Subtract (Local1, 0x0AAC, Local1)
                    Divide (Local1, 0x0A, Local2, Local3)
                    Store (Local3, Index (DerefOf (Index (Local0, 0x02)), 0x0A))
                    Store (ShiftRight (Local3, 0x08), Index (DerefOf (Index (Local0, 0x02)), 0x0B))
                    Store (B1B2 (BPV0, BPV1), Index (DerefOf (Index (Local0, 0x02)), 0x0C))
                    Store (ShiftRight (B1B2 (BPV0, BPV1), 0x08), Index (DerefOf (Index (Local0, 0x02)), 0x0D))
                    Store (B1B2 (BPR0, BPR1), Local1)
                    If (Local1)
                    {
                        If (And (B1B2 (BST0, BST1), 0x40))
                        {
                            Add (Not (Local1), 0x01, Local1)
                            And (Local1, 0xFFFF, Local1)
                        }
                    }

                    Store (Local1, Index (DerefOf (Index (Local0, 0x02)), 0x0E))
                    Store (ShiftRight (Local1, 0x08), Index (DerefOf (Index (Local0, 0x02)), 0x0F))
                    Store (B1B2 (BDV0, BDV1), Index (DerefOf (Index (Local0, 0x02)), 0x10))
                    Store (ShiftRight (B1B2 (BDV0, BDV1), 0x08), Index (DerefOf (Index (Local0, 0x02)), 0x11))
                    Store (B1B2 (BST0, BST1), Index (DerefOf (Index (Local0, 0x02)), 0x12))
                    Store (ShiftRight (B1B2 (BST0, BST1), 0x08), Index (DerefOf (Index (Local0, 0x02)), 0x13))
                    Store (B1B2 (BCX0, BCX1), Index (DerefOf (Index (Local0, 0x02)), 0x14))
                    Store (ShiftRight (B1B2 (BCX0, BCX1), 0x08), Index (DerefOf (Index (Local0, 0x02)), 0x15))
                    Store (B1B2 (BCA0, BCA1), Index (DerefOf (Index (Local0, 0x02)), 0x16))
                    Store (ShiftRight (B1B2 (BCA0, BCA1), 0x08), Index (DerefOf (Index (Local0, 0x02)), 0x17))
                    Store (B1B2 (BCB0, BCB1), Index (DerefOf (Index (Local0, 0x02)), 0x18))
                    Store (ShiftRight (B1B2 (BCB0, BCB1), 0x08), Index (DerefOf (Index (Local0, 0x02)), 0x19))
                    Store (B1B2 (BCP0, BCP1), Index (DerefOf (Index (Local0, 0x02)), 0x1A))
                    Store (ShiftRight (B1B2 (BCP0, BCP1), 0x08), Index (DerefOf (Index (Local0, 0x02)), 0x1B))
                    CreateField (DerefOf (Index (Local0, 0x02)), Multiply (0x1C, 0x08), Multiply (0x10, 0x08), BTSN)
                    Store (GBSS (B1B2 (BSN0, BSN1), B1B2 (BDA0, BDA1)), BTSN)

                    Store (GBMF (), Local1)
                    Store (SizeOf (Local1), Local2)
                    CreateField (DerefOf (Index (Local0, 0x02)), Multiply (0x2C, 0x08), Multiply (Local2, 0x08), BMAN)
                    Store (Local1, BMAN)
                    Add (Local2, 0x2C, Local2)
                    CreateField (DerefOf (Index (Local0, 0x02)), Multiply (Local2, 0x08), Multiply (0x10, 0x08), CLBL)
                    Store (GCTL (0x00), CLBL)
                    Add (Local2, 0x11, Local2)
                    CreateField (DerefOf (Index (Local0, 0x02)), Multiply (Local2, 0x08), Multiply (0x07, 0x08), DNAM)
                    Store (GDNM (0x00), DNAM)
                    Add (Local2, 0x07, Local2)
                    CreateField (DerefOf (Index (Local0, 0x02)), Multiply (Local2, 0x08), Multiply (0x04, 0x08), DCHE)
                    Store (GDCH (0x00), DCHE)
                    Add (Local2, 0x04, Local2)
                    CreateField (DerefOf (Index (Local0, 0x02)), Multiply (Local2, 0x08), Multiply (0x02, 0x08), BMAC)
                    Store (0x00, BMAC)
                    Add (Local2, 0x02, Local2)
                    CreateField (DerefOf (Index (Local0, 0x02)), Multiply (Local2, 0x08), Multiply (0x02, 0x08), BMAD)
                    Store (B1B2 (BDA0, BDA1), BMAD)
                    Add (Local2, 0x02, Local2)
                    CreateField (DerefOf (Index (Local0, 0x02)), Multiply (Local2, 0x08), Multiply (0x02, 0x08), BCCU)
                    Store (BRCC, BCCU)
                    Add (Local2, 0x02, Local2)
                    CreateField (DerefOf (Index (Local0, 0x02)), Multiply (Local2, 0x08), Multiply (0x02, 0x08), BCVO)
                    Store (BRCV, BCVO)
                    Add (Local2, 0x02, Local2)
                    CreateField (DerefOf (Index (Local0, 0x02)), Multiply (Local2, 0x08), Multiply (0x02, 0x08), BAVC)
                    Store (B1B2 (BCR0, BCR1), Local1)
                    If (Local1)
                    {
                        If (And (B1B2 (BST0, BST1), 0x40))
                        {
                            Add (Not (Local1), 0x01, Local1)
                            And (Local1, 0xFFFF, Local1)
                        }
                    }

                    Store (Local1, BAVC)
                    Add (Local2, 0x02, Local2)
                    CreateField (DerefOf (Index (Local0, 0x02)), Multiply (Local2, 0x08), Multiply (0x02, 0x08), RTTE)
                    Store (B1B2 (RTE0, RTE1), RTTE)
                    Add (Local2, 0x02, Local2)
                    CreateField (DerefOf (Index (Local0, 0x02)), Multiply (Local2, 0x08), Multiply (0x02, 0x08), ATTE)
                    Store (B1B2 (ATE0, ATE1), RTTE)
                    Add (Local2, 0x02, Local2)
                    CreateField (DerefOf (Index (Local0, 0x02)), Multiply (Local2, 0x08), Multiply (0x02, 0x08), ATTF)
                    Store (B1B2 (ATF0, ATF1), RTTE)
                    Add (Local2, 0x02, Local2)
                    CreateField (DerefOf (Index (Local0, 0x02)), Multiply (Local2, 0x08), Multiply (0x01, 0x08), NOBS)
                    If (LOr (LEqual (PRDT, 0x50), LEqual (PRDT, 0x53)))
                    {
                        Store (0x01, NOBS)
                    }
                    Else
                    {
                        Store (0x02, NOBS)
                    }
                }
                Else
                {
                    Store (Package (0x02)
                    {
                        0x34,
                        0x00
                    }, Local0)
                }
            }
            Else
            {
                Store (Package (0x02)
                {
                    0x0D,
                    0x00
                }, Local0)
            }

            Release (ECMX)
            Return (Local0)
        }

        // GBTC is renamed in native DSDT, so calls land here
        Method (GBTC, 0, NotSerialized)
        {
            Store ("Enter GetBatteryControl", Debug)
            Acquire (ECMX, 0xFFFF)
            If (ECRG)
            {
                Store (Package (0x03)
                {
                    0x00,
                    0x04,
                    Buffer (0x04) {}
                }, Local0)
                If (And (BATP, 0x01))
                {
                    Store (0x00, BSEL)
                    Store (0x00, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    If (LAnd (LAnd (LEqual (INAC, 0x00), LEqual (INCH, 0x00)), LEqual (IDIS, 0x00)))
                    {
                        Store (0x00, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    }
                    Else
                    {
                        If (LAnd (LAnd (LAnd (LEqual (INAC, 0x00), LEqual (INCH, 0x02)), LEqual (IDIS, 0x01)), LEqual (B1B2 (AXC0, AXC1), 0x00)))
                        {
                            Store (0x01, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                        }
                        Else
                        {
                            If (LAnd (LEqual (INAC, 0x01), LEqual (IDIS, 0x02)))
                            {
                                Store (0x02, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                            }
                            Else
                            {
                                If (LAnd (LAnd (LAnd (LEqual (INAC, 0x00), LEqual (INCH, 0x02)), LEqual (IDIS, 0x01)), LEqual (B1B2 (AXC0, AXC1), 0xFA)))
                                {
                                    Store (0x03, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                                }
                                Else
                                {
                                    If (LAnd (LEqual (INAC, 0x00), LEqual (INCH, 0x03)))
                                    {
                                        Store (0x04, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                                    }
                                }
                            }
                        }
                    }
                }
                Else
                {
                    Store (0xFF, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                }

                If (And (BATP, 0x02))
                {
                    Store (0x01, BSEL)
                    Store (0x00, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                    If (LAnd (LAnd (LEqual (INAC, 0x00), LEqual (INCH, 0x00)), LEqual (IDIS, 0x00)))
                    {
                        Store (0x00, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                    }
                    Else
                    {
                        If (LAnd (LAnd (LAnd (LEqual (INAC, 0x00), LEqual (INCH, 0x01)), LEqual (IDIS, 0x02)), LEqual (B1B2 (AXC0, AXC1), 0x00)))
                        {
                            Store (0x01, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                        }
                        Else
                        {
                            If (LAnd (LEqual (INAC, 0x01), LEqual (IDIS, 0x01)))
                            {
                                Store (0x02, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                            }
                            Else
                            {
                                If (LAnd (LAnd (LAnd (LEqual (INAC, 0x00), LEqual (INCH, 0x01)), LEqual (IDIS, 0x02)), LEqual (B1B2 (AXC0, AXC1), 0xFA)))
                                {
                                    Store (0x03, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                                }
                                Else
                                {
                                    If (LAnd (LEqual (INAC, 0x00), LEqual (INCH, 0x03)))
                                    {
                                        Store (0x04, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                                    }
                                }
                            }
                        }
                    }
                }
                Else
                {
                    Store (0xFF, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }
            }
            Else
            {
                Store (Package (0x02)
                {
                    0x35,
                    0x00
                }, Local0)
            }

            Release (ECMX)
            Return (Local0)
        }
    }

    Scope (\_SB)
    {
        // This is the replacement for native NBTI in DSDT
        // The NBTI in DSDT is renamed to XBTI
        Name (NBTI, Package(0x02)
        {
            Package(0x0F)
            {
                0x01,
                0xFFFFFFFF,
                0xFFFFFFFF,
                0x01,
                0xFFFFFFFF,
                0x00,
                0x00,
                0x64,
                0x64,
                "Primary",
                "100000",
                "LIon",
                "Hewlett-Packard",
                Zero,
                Zero,
            },
            Package(0x0F)
            {
                0x01,
                0xFFFFFFFF,
                0xFFFFFFFF,
                0x01,
                0xFFFFFFFF,
                0x00,
                0x00,
                0x64,
                0x64,
                "Travel",
                "100000",
                "LIon",
                "Hewlett-Packard",
                Zero,
                Zero,
            }
        })
    }

    Method (B1B2, 2, NotSerialized)
    {
        ShiftLeft (Arg1, 8, Local0)
        Or (Arg0, Local0, Local0)
        Return (Local0)
    }
}

//EOF
