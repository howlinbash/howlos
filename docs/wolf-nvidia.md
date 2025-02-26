

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

## Howlin

cat /efi/loader/entries/ee96e19319d64dac92a6e1f0b91f61a0-6.13.1-arch2-1.conf 
# Boot Loader Specification type#1 entry
# File created by /etc/kernel/install.d/90-loaderentry.install (systemd 254.1-1-arch)
title      EndeavourOS
version    6.13.1-arch2-1
machine-id ee96e19319d64dac92a6e1f0b91f61a0
sort-key   endeavouros-6.13.1-arch2-1
options    nvme_load=YES nowatchdog rw root=UUID=6d1f1dc0-c0da-49ca-918c-546bd199565f resume=UUID=6ac12427-0e0b-4a34-a83e-c47faebe8942 systemd.machine_id=ee96e19319d64dac92a6e1f0b91f61a0
linux      /ee96e19319d64dac92a6e1f0b91f61a0/6.13.1-arch2-1/linux
initrd     /ee96e19319d64dac92a6e1f0b91f61a0/6.13.1-arch2-1/initrd
