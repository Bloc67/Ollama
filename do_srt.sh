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

echo "${YELLOW}**************${END}"

COUNT=0
SECONDS=0
DATO_START=$(date '+%H:%M')
for FIL in *.en.srt; do
    python translate.py "$FIL" --skip-consistency
    python3 translate.py "$FIL" --skip-consistency -b 5 -m gemma3:12b
    wait
    let "COUNT++"
    echo "${GREEN}Finished file ${COUNT}------------------------------------------------${END}"
done
DATO_END=$(date '+%H:%M')
duration=$SECONDS
echo "${GREEN}**************${END}"
echo "Translated ${COUNT} files in ${YELLOW}$(($diff / 3600)) hours${END}, ${GREEN}$((($diff / 60) % 60)) minutes${END} and ${CYAN}$(($diff % 60)) seconds${END}"
#echo "Translated ${COUNT} files in ${YELLOW}$((duration / 60)) minutes${END} and ${GREEN}$((duration % 60)) seconds${END}"
echo "Start: ${DATO_START} End: ${DATO_END}"
echo "${GREEN}**************${END}"
