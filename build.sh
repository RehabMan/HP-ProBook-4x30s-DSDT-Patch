#!/bin/bash

./make_config.sh
./make_acpi.sh
# using AppleALC.kext, no need to build patched HDA
#./tools/patch_hdainject.sh ProBook
#./tools/patch_hdazml.sh ProBook

#EOF
