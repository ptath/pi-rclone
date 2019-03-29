#!/bin/bash

# Version 0.5
# By ptath (https://ptath.ru)
# rclone installation script

# Colors for terminal
if test -t 1; then
    ncolors=$(which tput > /dev/null && tput colors)
    if test -n "$ncolors" && test $ncolors -ge 8; then
        termcols=$(tput cols)
        bold="$(tput bold)"
        standout="$(tput smso)"
        normal="$(tput sgr0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
        cyan="$(tput setaf 6)"
    fi
fi

print_red() {
        text="$1"
        printf "${bold}${red}${text}${normal}"
}

print_green() {
        text="$1"
        printf "${bold}${green}${text}${normal}"
}

print_cyan() {
        text="$1"
        printf "${bold}${cyan}${text}${normal}"
}

print_title() {
    title="$1"
    text="$2"

    echo
    echo "${cyan}================================================================================${normal}"
    echo
    echo -e "  ${bold}${cyan}${title}${normal}"
    echo
    echo -en "  ${text}"
    echo
    echo "${cyan}================================================================================${normal}"
    echo
}

print_title "rclone installation script" "Press CTRL+C anytime to abort"

curl https://rclone.org/install.sh | sudo bash

[ -e ~/scripts/backup.sh ] && echo " Script already installed ($(print_cyan "~/scripts/backup.sh"))? Exiting..." && exit

[ ! -d ~/scripts ] && mkdir ~/scripts
[ ! -d ~/.rclone ] && mkdir ~/.rclone

wget -q -O ~/scripts/backup.sh https://github.com/ptath/pi-rclone/raw/master/scripts/backup.sh
wget -q -O ~/.rclone/backup.list https://github.com/ptath/pi-rclone/raw/master/.rclone/backup.list
wget -q -O ~/.rclone/excludes.list https://github.com/ptath/pi-rclone/raw/master/.rclone/excludes.list

chmod +x ~/scripts/backup.sh

read -p " Configure rclone now? (y/N)? " yn
case $yn in
  [Yy]* )
    rclone config
  ;;
  * )
    echo " OK, skipping config..."
  ;;
esac

echo " "
echo " Please review following files and edit them if necessary: "
echo " "
echo "  ~/.rclone/backup.list   — List of directories to backup"
echo "  ~/.rclone/excludes.list — Exclude special files or directories from backup"
echo "  ~/scripts/backup.sh     — Insert yours service name and path to backup"
echo " "

read -p " Install $(print_cyan "cron job") at 04:15 every day (y/N) ? " yn
case $yn in
  [Yy]* )
    (crontab -l ; echo "30 4 * * * ~/scripts/backup.sh > /dev/null 2>&amp;1") | crontab -
    echo " Installed, run $(print_cyan "crontab -e") to edit"
  ;;
  * )
    exit
  ;;
esac

print_title "That's all!" "Run ~/scripts/backup.sh"
