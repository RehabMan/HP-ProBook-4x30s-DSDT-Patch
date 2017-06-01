#define DEFINED_RMCF_XPEE

// Usually used on Skylake/KabyLake to disable XHC.PMEE on shutdown
// include only after SSDT-RMCF.asl

    Scope(RMCF)
    {
        // XPEE
        //
        // 0: do not manipulate XHC.PMEE during shutdown
        // 1: disable XHC.PMEE during shutdown
        Name(XPEE, 1)
    }

//EOF
