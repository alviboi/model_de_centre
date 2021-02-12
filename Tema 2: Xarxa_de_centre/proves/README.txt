OPX VM -- Version 2.3.2
-------
This tool allows a user to setup and run a OPX Virtual Machine instance.

Prerequisite (ALL PLATFORMS):
---------------------------
- Install VirtualBox: https://www.virtualbox.org and ensure the installed directory is added to the PATH.

Prerequisite (MS Windows ONLY): 
------------------------------
- Install OpenSSH for Windows (https://winscp.net/eng/docs/guide_windows_openssh_server). Please ensure the installed directory is added to the PATH.

FILES:
------
- vm.exe:   Standalone executable for MS Windows (tested on Windows 7 and 10)
- mvm:      Standalone executable for Mac OS X (tested on macOS Sierra)
- lvm:      Standalone executable for Linux platform (tested on Ubuntu 16.04LTS)

USAGE:
------
- Copy the appropriate executable to a local directory.
- RUN the executable. Examples:
   > vm.exe create <vm_name> --gui    // create a new VM with the GUI terminal session
   > vm.exe poweroff <vm_name>        // power off a VM session
   > vm.exe restart <vm_name>         // restart an existing VM session
   > vm.exe delete <vm_name>	      // delete a specific VM
   > vm.exe cleanVms                  // delete all existing VMs
- RUN with --help for a complete list of options.
 
VM tool is able to download onie-recovery and onie-installer files from an URL. But users can optionally use local copies
of these files. Here is a few examples:

- Use URL to get a specific .iso and .bin files:> vm.exe create vm1 --iso http://<your_url>/onie-kvm_x86_64-r0.iso --bin  https://<your_url>/OPX-installerXX_x86_64.bin

- Use local copies of the files:
> vm.exe create vm1 --iso c:\temp\onie-kvm_x86_64-r0.iso --bin c:\opx-onie-installer.bin
