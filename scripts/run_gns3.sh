#!/usr/bin/env bash

# NixOS launcher for GNS3 focused on VMware integration

# Ensure NixOS system binaries (including vmware / vmrun / gns3server) are in PATH
export PATH=/run/current-system/sw/bin:$PATH

echo "Starting GNS3 for VMware (using system vmware/vmrun)..."
/run/current-system/sw/bin/gns3 "$@"
