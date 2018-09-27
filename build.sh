#!/bin/bash

./make_config.sh
./make_acpi.sh
./_tools/patch_hdainject.sh ProBook
./_tools/patch_hdazml.sh ProBook

#EOF
