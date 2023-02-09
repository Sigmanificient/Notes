# Qemu, libvirt & virtmanager installation


## Requirement

Check if the virtualisation support is enabled, use the command
```sh
LC_ALL=C lscpu | grep Virtualization
```
If you dont see any ouput, you might need to enable virtualisation in your computer bios/uefi.

## Install

```
pacman -S qemu virt-manager ebtables dnsmasq vde2
```

- Qemu: Provides the actual emulation layer.
- KVM: The technology in the Linux kernel for using accelerated virtualization.
- Virt-manager: GUI for libvirt, a software for managing virtual machines.
- Ebtables: Filtering tool for a Linux-based bridging firewall.
- Dnsmasq: DNS forwarder and DHCP server.
- Bridge-utils : Network bridge needed for VMs
- Vde2: Virtual Distributed Ethernet for QEMU and other emulators.

Enable libvirtd service
```
systemctl enable --now libvirtd
```

Give the user the `libvirt` group to manage virtual machines

```sh
usermod -G libvirt -a $(whoami)
```

Mark default network to be started automatically

```sh
sudo virsh net-autostart "default"
```


## Nested VMs

If you need to use nested vitual machines, run the following commands, replace `[cpu]` with either amd or intel

```sh
sudo modprobe -r kvm_[cpu]
sudo modprobe kvm_[cpu] nested=1
systool -m kvm_[cpu] -v | grep nested
```