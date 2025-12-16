import os
import shutil
import sys

print(f"PATH: {os.environ.get('PATH')}")
print(f"VBOX_INSTALL_PATH: {os.environ.get('VBOX_INSTALL_PATH')}")

vbox = shutil.which("VBoxManage")
print(f"shutil.which('VBoxManage'): {vbox}")

if vbox:
    print("VBoxManage found!")
else:
    print("VBoxManage NOT found via shutil.which")

# Check direct path
direct_path = "/run/current-system/sw/bin/VBoxManage"
if os.path.exists(direct_path):
    print(f"Direct path {direct_path} exists")
else:
    print(f"Direct path {direct_path} DOES NOT exist")
