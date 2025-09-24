![](=500x)

# Sway-trixie Installation Script
This script takes care of installing the Sway WM on a Debian Trixie minimal install. 

# Requisites
- A minimal installation of Trixie
> Make sure that you do not select any option other than "Standard system utilities" since this is not neccessary. Also DO NOT provide a root password ( you can do that later ) since if you don't do that, sudo is not installed for the user.

- Internet access during installation
> Make sure you have either WiFi or LAN access. This script installes all packets from remote sources.

You may execute this script remotely by running:

```
wget -qO- https://raw.githubusercontent.com/dsancheznet/sway-trixie/refs/heads/main/sway-install.sh | bash
```

Enjoy
D.Sánchez
