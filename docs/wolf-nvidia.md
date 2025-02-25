

Nvidia Setup
============


## packages

nvidia-prime
nvidia-settings

### Possible helpers
optimus-manager-git

## Files

vim /efi/loader/entries/[hash]-[version]-arch1-1.conf
options    nvme_load=YES nowatchdog rw root=UUID=56564aa8-5b1d-4bff-bb08-12fc5562d90e resume=UUID=818a28d4-571d-4ec2-9b81-76e0b074c79b rw root=UUID=56564aa8-5b1d-4bff-bb08-12fc5562d90e resume=UUID=818a28d4-571d-4ec2-9b81-76e0b074c79b systemd.machine_id=562623055b9b4973954427820677a228 nvidia-drm.modeset=1 nouveau.modeset=0

/etc/X11/xorg.conf.d/20-nvidia.conf
Section "ServerLayout"
    Identifier "layout"
    Screen 0 "nvidia"
EndSection

Section "Device"
    Identifier "nvidia"
    Driver "nvidia"
    BusID "PCI:1:0:0"
    Option "AllowEmptyInitialConfiguration"
EndSection

Section "Screen"
    Identifier "nvidia"
    Device "nvidia"
EndSection

/etc/dracut.conf.d/nvidia.conf 
add_drivers+=" nvidia nvidia_modeset nvidia_uvm nvidia_drm "
force_drivers+=" nvidia nvidia_modeset nvidia_uvm nvidia_drm "

## Troubleshooting

$ lspci -k | grep -EA3 'VGA|3D'
$ glxinfo | g "OpenGL renderer"
$ cat /var/log/Xorg.0.log | grep -E "NVIDIA"
$ lsmod | grep nvidia
$ sudo nvidia-smi
