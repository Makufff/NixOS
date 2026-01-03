{ pkgs, lib, ... }:
{
  # Only enable either docker or podman -- Not both
  virtualisation = {
    spiceUSBRedirection.enable = true;

    docker = {
      enable = true;
    };

    podman.enable = false;

    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm;
      # แนะนำ: ถ้าใช้ GNS3 VM ให้ตั้ง network ของ VM เป็น Bridged หรือ Host-only
    };

    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };

    vmware.host.enable = true; # VMware Workstation/Player host modules

    # NOTE: After installing VMware, you may need to run:
    #   sudo vmware-modconfig --console --install-all
    # and accept the EULA/license in the GUI on first launch.
    # For more info: https://nixos.wiki/wiki/VMware
  };
  # Ensure the default NAT network (virbr0) is always available for GNS3 VM and VMs
  environment.etc."libvirt/qemu/networks/default.xml".source =
    "${pkgs.libvirt}/etc/libvirt/qemu/networks/default.xml";

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    spice-webdavd.enable = true;
  };

  programs = {
    virt-manager.enable = true;
  };

  security.wrappers = {
    ubridge = {
      source = "${pkgs.ubridge}/bin/ubridge";
      capabilities = "cap_net_admin,cap_net_raw=ep";
      owner = "root";
      group = "root";
      permissions = "u+rx,g+x,o+x";
    };
    dynamips = {
      source = "${pkgs.dynamips}/bin/dynamips";
      capabilities = "cap_net_admin,cap_net_raw=ep";
      owner = "root";
      group = "root";
      permissions = "u+rx,g+x,o+x";
    };
  };

  environment.systemPackages = with pkgs; [
    virt-viewer # View Virtual Machines
    spice
    spice-gtk
    spice-protocol
    spice-vdagent
    win-virtio
    win-spice

    lazydocker
    docker-client
    gsettings-desktop-schemas
  ];

  environment.etc."vmware/hostd/proxy.xml".text = ''
    <ConfigRoot>
      <httpProxy>
        <enabled>false</enabled>
      </httpProxy>
    </ConfigRoot>
  '';
}
