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
~