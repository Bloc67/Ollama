curl -fsSL https://ollama.com/install.sh | sh
systemctl status ollama
ollama pull gemma3:27b

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


sudo apt install syncthing
mkdir .config
mkdir .config/systemd
mkdir .config/systemd/user
cd .config/systemd/user
micro syncthing.service

   add this:
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

systemctl --user enable syncthing.service
systemctl --user start syncthing.service
systemctl --user status syncthing.service

systemctl --user stop syncthing.service
systemctl --user disable syncthing.service

ls -la /home/bloc67/.config
ls -la /home/bloc67/.config/syncthing/
micro /home/bloc67/.config/syncthing/config.xml
  - set 127.0.0.1 to 0.0.0.0
systemctl --user enable syncthing.service
systemctl --user start syncthing.service

http://192.168.10.235:8384/

  
git clone https://github.com/nfl0/OllamaSubtitleTranslator.git
cd OllamaSubtitleTranslator/

sudo apt install python3.10-venv
python3 -m venv env
source env/bin/activate
pip install pydantic tqdm

pip install 'langchain<0.3.27'
pip install 'langchain_community<0.3.27'
pip install 'langchain-ollama<0.3.27'

# python translate.py test.srt -i English -o Norwegian -m "gemma3:27b"
sudo apt install bashtop
