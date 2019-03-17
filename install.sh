#!/bin/bash

# Version 0.1
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

[ -e /bin/rclone ] && echo " Already installed (/bin/rclone)? Exiting..." && exit
[ -e /usr/bin/rclone ] && echo " Already installed (usr/bin/rclone)? Exiting..." && exit

sudo apt install rclone

[ -e ~/scripts/backup.sh ] && echo " Script already installed (~/scripts/backup.sh)? Exiting..." && exit

[ ! -d ~/scripts ] && mkdir ~/scripts
[ ! -d ~/.rclone ] && mkdir ~/.rclone

wget -q -O ~/scripts/backup.sh https://github.com/ptath/pi-rclone/raw/master/scripts/backup.sh
wget -q -O ~/.rclone/backup.list https://github.com/ptath/pi-rclone/raw/master/.rclone/backup.list
wget -q -O ~/.rclone/excludes.list https://github.com/ptath/pi-rclone/raw/master/.rclone/excludes.list

chmod +x ~/scripts/backup.sh
echo " Downloaded script to ~/scripts directory, here is its content:"
cd ~/scripts && ls -a

echo " Configuring rclone..."
rclone config

echo "  Editing .rclone/backup.list in vi (press $(print_cyan "i") to edit mode),"
echo "    add directories to backup,"
echo "    then press ESC and type $(print_cyan ":wq") then ENTER)"
read -p "   Press ENTER to proceed..."
vi ~/.rclone/backup.list

echo "  Editing .rclone/excludes.list in vi (press $(print_cyan "i") to edit mode),"
echo "    add file types to exclude from backup,"
echo "    then press ESC and type $(print_cyan ":wq") then ENTER)"
read -p "   Press ENTER to proceed..."
vi ~/.rclone/excludes.list

echo "  Editing ~/scripts/backup.sh in vi (press $(print_cyan "i") to edit mode),"
echo "    add file types to exclude from backup,"
echo "    then press ESC and type $(print_cyan ":wq") then ENTER)"
read -p "   Press ENTER to proceed..."
vi ~/scripts/backup.sh

echo " Installing backup cron job in 04:15 every day"
(crontab -l ; echo "30 4 * * * ~/scripts/backup.sh > /dev/null 2>&amp;1") | crontab -
echo " Installed, run $(print_cyan "crontab -e") to edit"

print_title "That's all!" "Run ~/scripts/backup.sh"
