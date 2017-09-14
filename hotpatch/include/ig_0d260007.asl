//
// Some Haswell laptops need ig-platform-id 0x0d260007 instead of 0x0a260006
// For those laptops, HDMI does not work on 10.12.x with 0x0a260006
// This is an override of the default.

    Scope(RMCF)
    {
        Name(IGPI, 0x0d260007)
        Name(LMAX, 0x07a1)
    }

//EOF
