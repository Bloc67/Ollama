sudo apt update
sudo apt upgrade
echo "Installing micro.."
sudo apt install micro
echo "Copying micro to nano"
sudo cp /bin/micro /bin/nano

echo "Fetching ollama.."
curl -fsSL https://ollama.com/install.sh | sh
systemctl status ollama
echo "Ollama pulling 27b.."
ollama pull gemma3:27b
echo "Ollama pulling 12b.."
ollama pull gemma3:12b

echo "Installing syncthing.."
sudo apt install syncthing
echo "making config folders.."
mkdir .config
mkdir .config/systemd
mkdir .config/systemd/user
cd .config/systemd/user

echo "
------------
[Unit]
Description=Syncthing - Open Source Continuous File Synchronization
Documentation=man:syncthing(1)
StartLimitIntervalSec=60
StartLimitBurst=4

[Service]
Environment="STLOGFORMATTIMESTAMP="
Environment="STLOGFORMATLEVELSTRING=false"
Environment="STLOGFORMATLEVELSYSLOG=true"
ExecStart=/usr/bin/syncthing serve --no-browser --no-restart
Restart=on-failure
RestartSec=1
SuccessExitStatus=3 4
RestartForceExitStatus=3 4

# Hardening
SystemCallArchitectures=native
MemoryDenyWriteExecute=true
NoNewPrivileges=true

# Elevated permissions to sync ownership (disabled by default),
# see https://docs.syncthing.net/advanced/folder-sync-ownership
#AmbientCapabilities=CAP_CHOWN CAP_FOWNER

[Install]
WantedBy=default.target
---------------------
"
read -p "Copy the code.Start editing syncthing.service? (j/n)? " answer
case ${answer:0:1} in
    j|J )
        micro syncthing.service
    ;;
    * )
        echo "Skipping.."
    ;;
esac

echo "Starting up syncthing.."
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
systemctl --user status syncthing.service

systemctl --user stop syncthing.service
systemctl --user disable syncthing.service
echo "Stopped syncthing. Edit 127.0.0.1 to 0.0.0.0"
read -p "Start editing syncthing config? (j/n)? " answer
case ${answer:0:1} in
    j|J )
        micro /home/bloc67/.config/syncthing/config.xml
    ;;
    * )
        echo "Skipping.."
    ;;
esac
systemctl --user enable syncthing.service
systemctl --user start syncthing.service

echo "Go to http://192.168.10.xxx:8384/ for further synthing config."

cd "/home/bloc67/Ollama"
echo "Installing python.."
sudo apt install python3.10-venv
python3 -m venv env
source env/bin/activate
echo "Installing python bits.."
pip install pydantic tqdm
echo "Installing python langchain(older version).."
pip install 'langchain<0.3.27'
pip install 'langchain_community<0.3.27'
pip install 'langchain-ollama<0.3.27'

# python translate.py test.srt -i English -o Norwegian -m "gemma3:27b"
echo "Installing bashtop.."
sudo apt install bashtop

cd /etc/netplan
ls -la
echo "
network:
  ethernets:
    enp9s0:
      addresses:
      - 192.168.122.48/24
      nameservers:
        addresses:
        - 8.8.8.8
        - 8.8.4.4
        search: []
      routes:
      - to: default
        via: 192.168.122.1
  version: 2
"
