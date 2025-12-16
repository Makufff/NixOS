import os
import json
import shutil
import sys
from pathlib import Path


def find_vboxmanage():
    # Try standard NixOS path first
    nixos_path = "/run/current-system/sw/bin/VBoxManage"
    if os.path.exists(nixos_path):
        return nixos_path

    # Fallback to which
    path = shutil.which("VBoxManage")
    if path:
        return path

    return None


def find_vmware():
    # Prefer NixOS system path
    nixos_path = "/run/current-system/sw/bin/vmware"
    if os.path.exists(nixos_path):
        return nixos_path

    path = shutil.which("vmware")
    if path:
        return path

    return None


def find_vmrun():
    nixos_path = "/run/current-system/sw/bin/vmrun"
    if os.path.exists(nixos_path):
        return nixos_path

    path = shutil.which("vmrun")
    if path:
        return path

    return None


def fix_gns3_config():
    vbox_path = find_vboxmanage()
    if not vbox_path:
        print("Warning: Could not find VBoxManage executable.")
    else:
        print(f"Found VBoxManage at: {vbox_path}")

    vmware_path = find_vmware()
    if not vmware_path:
        print("Warning: Could not find vmware executable.")
    else:
        print(f"Found vmware at: {vmware_path}")

    vmrun_path = find_vmrun()
    if not vmrun_path:
        print("Warning: Could not find vmrun executable.")
    else:
        print(f"Found vmrun at: {vmrun_path}")

    if not any([vbox_path, vmware_path, vmrun_path]):
        print("Error: No relevant virtualization binaries found. Nothing to fix.")
        sys.exit(1)

    home = Path.home()
    config_dir = home / ".config" / "GNS3" / "2.2"

    if not config_dir.exists():
        print(f"Error: GNS3 config directory not found at {config_dir}")
        print("Please run GNS3 at least once to generate configuration files.")
        sys.exit(1)

    # Standard GNS3 2.2 config for VBox is usually in gns3_server.conf under 'VirtualBox' -> 'vboxmanage_path'
    # and for VMware under 'VMware' -> 'vmware_path' / 'vmrun_path'
    files_to_check = ["gns3_server.conf", "gns3_gui.conf"]

    for filename in files_to_check:
        file_path = config_dir / filename
        if not file_path.exists():
            continue

        print(f"Checking {filename}...")
        try:
            with open(file_path, "r") as f:
                content = f.read()

            # Simple check if it looks like JSON
            if content.strip().startswith("{"):
                try:
                    config = json.loads(content)
                except json.JSONDecodeError as e:
                    print(f"JSON Parse Error in {filename}: {e}")
                    print(f"File content preview: {content[:500]}")
                    continue  # Skip to next file

                # --- VirtualBox section ---
                if vbox_path:
                    if "VirtualBox" not in config:
                        config["VirtualBox"] = {}

                    current_path = config["VirtualBox"].get("vboxmanage_path")
                    if current_path != vbox_path:
                        print(f"Updating vboxmanage_path in {filename}")
                        print(f"  Old: {current_path}")
                        print(f"  New: {vbox_path}")
                        config["VirtualBox"]["vboxmanage_path"] = vbox_path

                # --- VMware section ---
                if vmware_path or vmrun_path:
                    if "VMware" not in config:
                        config["VMware"] = {}

                    if vmware_path:
                        current_vmware = config["VMware"].get("vmware_path")
                        if current_vmware != vmware_path:
                            print(f"Updating vmware_path in {filename}")
                            print(f"  Old: {current_vmware}")
                            print(f"  New: {vmware_path}")
                            config["VMware"]["vmware_path"] = vmware_path

                    if vmrun_path:
                        current_vmrun = config["VMware"].get("vmrun_path")
                        if current_vmrun != vmrun_path:
                            print(f"Updating vmrun_path in {filename}")
                            print(f"  Old: {current_vmrun}")
                            print(f"  New: {vmrun_path}")
                            config["VMware"]["vmrun_path"] = vmrun_path

                with open(file_path, "w") as f_out:
                    json.dump(config, f_out, indent=4)
                print("  Updated successfully.")

            else:
                # Assume INI format (older or different variant)
                print(f"File {filename} does not start with '{{', assuming INI or empty.")
                if not content.strip():
                    print("File is empty.")
                else:
                    print(f"File content preview: {content[:200]}")

                import configparser

                parser = configparser.ConfigParser()
                try:
                    parser.read(file_path)
                except configparser.Error as e:
                    print(f"ConfigParser Error: {e}")
                    continue

                # --- VirtualBox section ---
                if vbox_path:
                    if not parser.has_section("VirtualBox"):
                        parser.add_section("VirtualBox")

                    current_path = parser.get(
                        "VirtualBox", "vboxmanage_path", fallback=None
                    )
                    if current_path != vbox_path:
                        print(f"Updating vboxmanage_path in {filename} (INI)")
                        parser.set("VirtualBox", "vboxmanage_path", vbox_path)

                # --- VMware section ---
                if vmware_path or vmrun_path:
                    if not parser.has_section("VMware"):
                        parser.add_section("VMware")

                    if vmware_path:
                        current_vmware = parser.get(
                            "VMware", "vmware_path", fallback=None
                        )
                        if current_vmware != vmware_path:
                            print(f"Updating vmware_path in {filename} (INI)")
                            parser.set("VMware", "vmware_path", vmware_path)

                    if vmrun_path:
                        current_vmrun = parser.get(
                            "VMware", "vmrun_path", fallback=None
                        )
                        if current_vmrun != vmrun_path:
                            print(f"Updating vmrun_path in {filename} (INI)")
                            parser.set("VMware", "vmrun_path", vmrun_path)

                with open(file_path, "w") as f_out:
                    parser.write(f_out)
                print("  Updated successfully.")

        except Exception as e:
            print(f"Failed to process {filename}: {e}")


if __name__ == "__main__":
    fix_gns3_config()
