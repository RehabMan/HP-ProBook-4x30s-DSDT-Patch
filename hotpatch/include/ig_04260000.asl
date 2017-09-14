//
// Some Haswell laptops need ig-platform-id 0x04260000 instead of 0x0a260006
// For those laptops, there can be glitches with 0x0a260006 or 0x0d260007
// This is an override of the default.

    Scope(RMCF)
    {
        Name(IGPI, 0x04260000)
        Name(LMAX, 0x1499)
    }

//EOF
