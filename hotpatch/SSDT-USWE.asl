// special fix for "wake on USB" for newer ProBook models

//DefinitionBlock("", "SSDT", 2, "hack", "_USWE", 0)
//{
    // This USWE code is specific to the Skylake G3 (and new a few other models)
    External(USWE, FieldUnitObj)
    Device(RMD3)
    {
        Name(_HID, "RMD30000")
        Method(_INI)
        {
            // disable wake on XHC (XHC._PRW checks USWE and enables wake if it is 1)
            If (CondRefOf(\USWE)) { \USWE = 0 }
        }
    }
//}

//EOF
