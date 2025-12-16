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

def fix_gns3_config():
    vbox_path = find_vboxmanage()
    if not vbox_path:
        print("Error: Could not find VBoxManage executable.")
        sys.exit(1)
        
    print(f"Found VBoxManage at: {vbox_path}")
    
    home = Path.home()
    config_dir = home / ".config" / "GNS3" / "2.2"
    
    if not config_dir.exists():
        print(f"Error: GNS3 config directory not found at {config_dir}")
        print("Please run GNS3 at least once to generate configuration files.")
        sys.exit(1)
        
    server_conf_path = config_dir / "gns3_server.conf"
    
    # Skip initial check, handle in loop
    pass

            
    # Update the path
    # The structure usually involves a 'VirtualBox' section or similar, 
    # but based on common issues, it's often a direct key or inside a specific section.
    # Let's check the structure if it exists, otherwise we might need to be careful.
    # Actually, GNS3 2.2 server config is usually flat JSON or INI-like but stored as JSON in recent versions?
    # Wait, gns3_server.conf is typically INI format in older versions but JSON in 2.2+.
    # Let's verify file content type first if possible, but assuming JSON for 2.2 as per path.
    
    # Actually, let's look at the file content first if we can, but we can't.
    # Standard GNS3 2.2 config for VBox is usually in gns3_server.conf under 'VirtualBox' -> 'vboxmanage_path'
    # OR in gns3_gui.conf under 'VirtualBox' -> 'vboxmanage_path'
    
    # Let's try to update both if they exist.
    
    files_to_check = ["gns3_server.conf", "gns3_gui.conf"]
    
    for filename in files_to_check:
        file_path = config_dir / filename
        if not file_path.exists():
            continue
            
        print(f"Checking {filename}...")
        try:
            with open(file_path, 'r') as f:
                content = f.read()
                
            # Simple check if it looks like JSON
            if content.strip().startswith('{'):
                try:
                    config = json.loads(content)
                except json.JSONDecodeError as e:
                    print(f"JSON Parse Error in {filename}: {e}")
                    print(f"File content preview: {content[:500]}")
                    continue # Skip to next file or try INI? If it starts with {, it's likely JSON.
                
                # Check for VirtualBox section
                if 'VirtualBox' not in config:
                    config['VirtualBox'] = {}
                
                current_path = config['VirtualBox'].get('vboxmanage_path')
                if current_path != vbox_path:
                    print(f"Updating vboxmanage_path in {filename}")
                    print(f"  Old: {current_path}")
                    print(f"  New: {vbox_path}")
                    config['VirtualBox']['vboxmanage_path'] = vbox_path
                    
                    with open(file_path, 'w') as f_out:
                        json.dump(config, f_out, indent=4)
                    print("  Updated successfully.")
                else:
                    print(f"  Path already correct in {filename}.")

                # Disable VMware to prevent crashes
                if 'VMware' not in config:
                    config['VMware'] = {}
                
                # Set vmware path to empty or invalid to prevent auto-detection if possible, 
                # or look for an 'enable' flag. GNS3 usually just tries to find it.
                # Setting path to something harmless might help.
                # Or just ensure it doesn't try to use the crashing one.
                # But the error is "Could not execute ... vmware-v".
                # Let's try to set vmware_path to something non-existent or empty.
                
                current_vmware = config['VMware'].get('vmware_path')
                if current_vmware != "":
                    print(f"Disabling VMware path in {filename}")
                    config['VMware']['vmware_path'] = "" 
                    # Also try to set enable_vmware if it exists (it might not)
                    
                    with open(file_path, 'w') as f_out:
                        json.dump(config, f_out, indent=4)
                    print("  VMware disabled.")

            else:
                # Assume INI format (older or different variant)
                # We'll do a simple string replacement for safety if we can't parse INI easily without deps
                # But Python has configparser.
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
                
                if not parser.has_section('VirtualBox'):
                    parser.add_section('VirtualBox')
                
                current_path = parser.get('VirtualBox', 'vboxmanage_path', fallback=None)
                if current_path != vbox_path:
                    print(f"Updating vboxmanage_path in {filename} (INI)")
                    parser.set('VirtualBox', 'vboxmanage_path', vbox_path)
                    with open(file_path, 'w') as f_out:
                        parser.write(f_out)
                    print("  Updated successfully.")
                else:
                    print(f"  Path already correct in {filename}.")

                # Disable VMware in INI
                if not parser.has_section('VMware'):
                    parser.add_section('VMware')
                
                current_vmware = parser.get('VMware', 'vmware_path', fallback=None)
                if current_vmware != "":
                    print(f"Disabling VMware path in {filename} (INI)")
                    parser.set('VMware', 'vmware_path', "")
                    with open(file_path, 'w') as f_out:
                        parser.write(f_out)
                    print("  VMware disabled.")

        except Exception as e:
            print(f"Failed to process {filename}: {e}")

if __name__ == "__main__":
    fix_gns3_config()
