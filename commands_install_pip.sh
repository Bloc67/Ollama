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
