#!/bin/bash

./make_config.sh
./make_acpi.sh
./tools/patch_hdainject.sh ProBook
./tools/patch_hdazml.sh ProBook

#EOF
