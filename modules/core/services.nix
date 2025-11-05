{ ... }:
{
  # Services to start
  services = {
    libinput.enable = true; # Input Handling
    fstrim.enable = true; # SSD Optimizer
    devmon.enable = true; # For Mounting USB & More
    gvfs.enable = true; # For Mounting USB & More
    udisks2.enable = true; # For Mounting USB & More

    # Userspace CPU Scheduler for Improved Latency for Gaming (Hardware Specific)
    # services.scx = {
    #   enable = true;
    #   package = pkgs.scx.rustscheds;
    #   scheduler = "scx_lavd"; # https://github.com/sched-ext/scx/blob/main/scheds/rust/README.md
    # };

    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = true;
        AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      };
    };
    blueman.enable = true; # Bluetooth Support
    tumbler.enable = true; # Image/video preview

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      
      wireplumber = {
        enable = true;
        configPackages = [
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-alsa-disable-dsp.conf" ''
            monitor.alsa.rules = [
              {
                matches = [
                  {
                    node.name = "~alsa_.*"
                  }
                ]
                actions = {
                  update-props = {
                    api.alsa.period-size = 2048
                    api.alsa.period-num = 2
                    api.alsa.headroom = 8192
                    session.suspend-timeout-seconds = 0
                  }
                }
              }
            ]
          '')
        ];
      };
      
      extraConfig.pipewire."92-audio-quality" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 2048;
          "default.clock.min-quantum" = 2048;
          "default.clock.max-quantum" = 8192;
          "link.max-buffers" = 16;
          "log.level" = 2;
        };
        "context.modules" = [
          {
            name = "libpipewire-module-rtkit";
            args = {
              "nice.level" = -15;
              "rt.prio" = 88;
              "rt.time.soft" = 200000;
              "rt.time.hard" = 200000;
            };
            flags = [ "ifexists" "nofail" ];
          }
          {
            name = "libpipewire-module-protocol-native";
          }
        ];
      };
      
      extraConfig.pipewire-pulse."92-audio-quality" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "2048/48000";
              pulse.default.req = "2048/48000";
              pulse.max.req = "8192/48000";
              pulse.min.quantum = "2048/48000";
              pulse.max.quantum = "8192/48000";
              pulse.min.frag = "2048/48000";
              pulse.default.frag = "2048/48000";
              pulse.default.tlength = "8192/48000";
              pulse.min.tlength = "2048/48000";
            };
          }
        ];
        "stream.properties" = {
          resample.quality = 10;
          resample.disable = false;
          channelmix.normalize = false;
          channelmix.mix-lfe = false;
          channelmix.upmix = false;
        };
      };
    };
  };
}
