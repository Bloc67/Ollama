#!/bin/bash

RED=$'\e[1;31m'
GREEN=$'\e[1;32m'
YELLOW=$'\e[1;33m'
BLUE=$'\e[1;34m'
MAGENTA=$'\e[1;35m'
CYAN=$'\e[1;36m'
END=$'\e[0m'
BOLD=$'\033[1m'
ITALIC=$'\033[3m'
UNDERLINE=$'\033[4m'

sudo apt update
sudo apt upgrade
echo "${CYAN}Installing micro.."
sudo apt install micro
echo "${CYAN}Copying micro to nano"
sudo cp /bin/micro /bin/nano

echo "${GREEN}Fetching ollama..${END}"
curl -fsSL https://ollama.com/install.sh | sh
systemctl status ollama
echo "${CYAN}Ollama pulling 27b..${END}"
ollama pull gemma3:27b
ollama pull mdq100/Gemma3-Instruct-Abliterated:27b

echo "${CYAN}Installing syncthing..${END}"
sudo apt install syncthing
echo "${CYAN}making config folders..${END}"
mkdir .config
mkdir .config/systemd
mkdir .config/systemd/user
cd .config/systemd/user

echo "
${BLUE}------------${END}
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
${BLUE}---------------------${END}
"
read -p "Copy the code into a service? (j/n)? " answer
case ${answer:0:1} in
    j|J )
        micro syncthing.service
    ;;
    * )
        echo "Skipping.."
    ;;
esac

echo "${CYAN}Starting up service..${END}"
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
systemctl --user status syncthing.service --no-pager

read -p "Editing syncthing to 0.0.0.0? (j/n)? " answer
case ${answer:0:1} in
    j|J )
        echo "Fetching config..."
    ;;
    * )
        echo "Skipping.."
    ;;
esac

systemctl --user stop syncthing.service
systemctl --user disable syncthing.service
wait 20
micro /home/bloc67/.config/syncthing/config.xml

systemctl --user enable syncthing.service
systemctl --user start syncthing.service
wait 20
cd "/home/bloc67/Ollama"
echo "${CYAN}Installing python..${END}"
sudo apt install python3.10-venv
python3 -m venv env
source env/bin/activate
echo "${CYAN}Installing python bits..${END}"
pip install pydantic tqdm
echo "${CYAN}Installing python langchain(older version)..${END}"
pip install 'langchain<0.3.27'
pip install 'langchain_community<0.3.27'
pip install 'langchain-ollama<0.3.27'

echo "${CYAN}Installing python alive-progress..${END}"
pip install alive-progress
# python translate.py test.srt -i English -o Norwegian -m "gemma3:27b"
echo "${CYAN}Installing bashtop..${END}"
sudo apt install bashtop

cd /home/bloc67/Ollama
echo "${YELLOW}Running a first speed test...${END}"
bash do_srt.sh
