#!/usr/bin/env bash

# Ensure VBoxManage is in PATH
export PATH=/home/makufff/NixOS/scripts/fake_vmware:$PATH:/run/current-system/sw/bin

# Explicitly set VBoxManage path env var if GNS3 respects it (it might not, but doesn't hurt)
export VBOX_INSTALL_PATH=/run/current-system/sw/bin

# Run GNS3
echo "Starting GNS3 with corrected PATH..."
/run/current-system/sw/bin/gns3 "$@"
