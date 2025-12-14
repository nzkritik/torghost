# WARNING — DEVELOPMENT / DO NOT USE ON PRODUCTION SYSTEMS

> IMPORTANT: This project is currently under active development and testing.
> Running the torghost script can modify system network settings (iptables/nftables),
> replace /etc/resolv.conf, stop system services (systemd-resolved, Docker), and
> otherwise change system state. You should NOT run this on a production,
> critical, or non-disposable machine. Use only in a disposable VM or on a snapshot
> you can roll back. The authors are not responsible for damage or loss.

# TorGhost
This tool was originally for Kali Linux. It has now been converted to work with Arch Linux distros.   
This is a powerful tool that can connect your whole PC with Tor network.   

Forget the Tor Browser.   
Now you can even use `Sudo pacman -S <package_name>` ANONYMOUSLY.

## INSTALL

Clone the repo or download the files, open the directory and follow the commands:
	
	chmod +x install.sh
	./install.sh

-----------------------------------------------------------------------------------------
```
▄▄▄▄▄▄▄▄▄           ▄▄▄▄▄▄▄  ▄▄                      
▀▀▀███▀▀▀          ███▀▀▀▀▀  ██                 ██   
   ███ ▄███▄ ████▄ ███       ████▄ ▄███▄ ▄█▀▀▀ ▀██▀▀ 
   ███ ██ ██ ██ ▀▀ ███  ███▀ ██ ██ ██ ██ ▀███▄  ██   
   ███ ▀███▀ ██    ▀██████▀  ██ ██ ▀███▀ ▄▄▄█▀  ██   
                                                            
    v3.0 - rewritten by nzkritik for Arch Linux
    


    USAGE:
        sudo torghost start   (start torghost)
        sudo torghost stop    (stop torghost) 
        sudo torghost switch  (switch IP)
        torghost status       (show status)
        sudo torghost check-leak [interval_seconds]
            (run continuous DNS leak monitoring; default interval 10s)
```
-----------------------------------------------------------------------------------------

## REQUIREMENTS
- Arch Linux based distro
- root privileges (sudo)
- tor package (will be installed by install.sh if not present)
- stem package (will be installed by install.sh if not present)
- iptables (comes pre-installed with Arch Linux)
- systemctl (comes pre-installed with Arch Linux)       
- torghost package (will be installed by install.sh)
- A working internet connection 

## DISCLAIMER
This tool is developed for educational purposes only. The developer is not responsible for any misuse or damage caused by this tool. Use it at your own risk.  

## References
- [Tor Project](https://www.torproject.org/)
- [Torsocks](https://gitweb.torproject.org/torsocks.git)
- [Iptables](https://netfilter.org/projects/iptables/index.html)
- [Systemd](https://www.freedesktop.org/wiki/Software/systemd/)
- [Kali Linux](https://www.kali.org/)
- [Technical Dada](https://technicaldada.in/)  

## Author
- Original Author: [Technical Dada](https://technicaldada.in/)
- Arch Linux Port: [nzkritik](https://github.com/nzkritik)  

---   

## USAGE (check-leak)

The new "check-leak" command runs a continuous DNS leak monitor while TorGhost is active.

- Run: sudo torghost check-leak
- Optional: provide an interval in seconds: sudo torghost check-leak 15
- Behavior:
  - Uses tcpdump (if available) to watch for non-local DNS (UDP/53) traffic for both IPv4 and IPv6.
  - Applies iptables/ip6tables heuristics when tcpdump is not available.
  - Runs repeatedly at the chosen interval and prints findings for each cycle.
- Exit:
  - Type q then Enter to quit monitoring, or press Ctrl-C.

Notes:
- tcpdump is recommended for accurate packet-level detection (install via pacman in the installer).
- The script includes added hardening (iptables/ip6tables) to reduce DNS leaks, but check-leak helps verify that behavior.
- Use this mode to validate there are no DNS or IPv6 leaks before relying on TorGhost for sensitive traffic.

~