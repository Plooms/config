export EDITOR="nano"
export LANG="en_US.UTF-8"
source /usr/local/bin/VAR-SCRIPT-COLOR

[ "$UID" != "0" ] && [ "$USER" = "abz" ] && source /usr/local/bin/VAR-SCRIPT
[ "$HOST" = C0 ] && [ $USER = "abz" ] && source /usr/share/doc/pkgfile/command-not-found.zsh

# Prevent Screen Turning off
[ $USER = "abz" ] && sudo xset -dpms 2>/dev/null  && sudo xset s off 2>/dev/null

# Terminator title
printf "\e]2;Terminator\a"


### Linux Commands
alias e='echo'
alias df='df -h'
alias fd='sudo fdisk -l'
alias ls='ls -1'
alias io='sudo iotop -oPa'
alias grep='grep -i --color'
alias parallel='parallel --no-notice'
alias s='sudo'
alias mk='mkdir'
alias smk='sudo mkdir'
alias mo='sudo mount -v'
alias um='sudo umount'
alias hist='history -n 1'
alias sce='sudo systemctl enable "$@"'
alias scd='sudo systemctl disable "$@"'
alias scs='sudo systemctl start "$@"'
alias scr='sudo systemctl restart "$@"'
alias scsp='sudo systemctl stop "$@"'
alias scst='sudo systemctl status "$@"'
alias calc='python'
alias up='uptime'
alias gp='sudo gparted'
alias beep="beep 2>/dev/null"


# Paths
alias c='cd /usr/local/bin/'




# Edit & View Files
alias an='systemd-analyze blame|cat;echo;systemd-analyze;echo -e "\n\n";uptime -p'
alias ec='crontab -e'
[ "$HOST" = C0 ] && [ $USER = "abz" ]  && alias ec='EDITOR=geany ; crontab -e &'
alias ny='sudo nano /etc/yaourtrc'
alias np='sudo nano /etc/pacman.conf'
alias nf='sudo nano /etc/fstab'
alias nv='sudo nano /usr/local/bin/VAR-SCRIPT*'
alias gv='sudo geany /usr/local/bin/VAR-SCRIPT* 2>/dev/null &'
alias nz='sudo nano ~/.zshrc'
alias gz='sudo geany ~/.zshrc 2>/dev/null &'
alias sz='source /home/abz/.zshrc'




# Personal Shortcuts
alias dfree='df -h |grep /media |cut -b 26- | sort'
alias g='sudo geany $@ 2>/dev/null '
alias gg='cd /usr/local/bin ; sudo geany $@  2>/dev/null'
alias n='sudo nano $@'
alias nn='cd /usr/local/bin ; sudo nano $@'
alias png='ping google.com'
alias ki='sudo killall $@'
alias pk='sudo pkill $@'
alias git-pack="git add . ; git commit -m N/A"
alias ms="mysql -uroot -p"$DB_PASSWORD" movies"
alias on="onboard &"

#alias xclip='xclip -selection c'



# SSH Hosts
alias s0='ssh C0' # Desktop

alias s1='ssh C1'	# Nas 1
alias s1-vm='ssh C1-VM' # Nas 1 (VM)

alias s2='ssh C2'	# Nas 2
alias s2-vm='ssh C2-VM'	# Nas 2 (VM)

alias s3='ssh C3'	# Nas 3 - Offsite

alias s4='ssh C4'	# Nas 4
alias s4-vm='ssh C4-VM'	# Nas 4 (VM)

alias ssv1-SB-CP="ssh SB-CP-VM"         # SB-CP (VM)
alias ssv2-Sabnzbd="ssh Sabnzbd-VM"     # Sabnzbd (VM)
alias ssv3-Torrents="ssh Torrents-VM"   # Torrents (VM)


# Global & Suffix aliases
alias -s conf='sudo nano'
alias -s cfg='sudo nano'
alias -s log='sudo nano'
alias -s txt='sudo nano'

# alias -g s="sudo "  <<< Global alias = will work if it appears anywhere on the command line
# alias -s txt="nano" <<< Suffix alias = it will open files ending with txt with nano , e.g file.txt



## For zenity & Cron
export DISPLAY=:0.0
xhost + 2>&1 >/dev/null



# My Functions ######################
nt() { a="$(mktemp)" ; sudo nano $a ; echo $a ;}
gt() { a="$(mktemp)" ; sudo geany $a ; echo $a ;}
dt() { cd $(mktemp -d) ;}


#delink() { 
#	tmpfile="$1-$(date)"
#	cp -a "$1" "$tmpfile"
#	mv "$tmpfile" "$1"
#	echo "(De-linked) $1"
#}



exit-note() {

echo ""
echo "The files have been downloaded to:"
echo ""
echo "Scripts:	$DIR/abz-scripts"
echo "Tips & Tricks:	$DIR/abz-tips"
echo "Config-Files:	$DIR/abz-config"

}

abz-scripts() {

if [ -z "$1" ]
then echo "USAGE : abz-scripts [ git | wget ]"
echo -e "\n""NOTE: git is better (if available)"
return
fi


DIR="$(mktemp -d /tmp/abz-XXX)"
cd "$DIR"

if [ "$1" = "git" ]
then
# git way (best)
if [ -f /bin/git -o -f /usr/bin/git ]
then echo ""
else
echo "Please install git"
return
fi

echo "Downloading the Awesome ABZ-SCRIPTS into $DIR"
git clone https://github.com/Plooms/bin.git abz-scripts 2>/dev/null
git clone https://github.com/Plooms/tips.git abz-tips 2>/dev/null
git clone https://github.com/Plooms/config.git abz-config 2>/dev/null
echo -e "\n\n"
echo -e "\n\n\nStarting DRY-RUN"
echo ""
sudo rsync -navhPi --del --exclude='.git' "$DIR"/abz-scripts/ /usr/local/bin/
echo ""
echo -e "\n\n\n\n""Move new scripts to /usr/local/bin and delete old scripts?           y""\n\n\n\n"
read confirmation

if [ "$confirmation" = "y" ]
then
sudo rsync -avhPi --del --exclude='.git' "$DIR"/abz-scripts/ /usr/local/bin/
clear
echo ""
echo "The Scripts have been synced to /usr/local/bin"
else
echo "Canceled the Operation (go do it yourself b**ch)"
fi

echo -e "\n\n\n\n""Move new zshrc to "/home/$USER/.zshrc" and "/root/.zshrc"  ?           y""\n\n\n\n"
read confirmation

if [ "$confirmation" = "y" ]
then
sudo rsync -avhPi "$DIR"/abz-config/.zshrc /home/"$USER"/
sudo rsync -avhPi "$DIR"/abz-config/.zshrc /root/
else
echo "Canceled the Operation (go do it yourself b**ch)"
fi

exit-note

fi


if [ "$1" = "wget" ]
then
# wget way (if git is not available)
echo "Downloading the Awesome ABZ-SCRIPTS into $DIR"
mkdir abz-scripts >/dev/null
mkdir abz-tips >/dev/null
mkdir abz-config >/dev/null
wget --quiet https://github.com/Plooms/bin/archive/master.tar.gz -O - | tar xz -C abz-scripts
wget --quiet https://github.com/Plooms/tips/archive/master.tar.gz -O - | tar xz -C abz-tips
wget --quiet https://github.com/Plooms/config/archive/master.tar.gz -O - | tar xz -C abz-config
mv abz-scripts/bin-master/* abz-scripts/ ; rmdir abz-scripts/* 2>/dev/null
mv abz-tips/tips-master/* abz-tips/ ; rmdir abz-tips/* 2>/dev/null
mv abz-config/config-master/* abz-config/ ; rmdir abz-config/* 2>/dev/null
echo -e "\n\n"
echo -e "\n\n\nStarting DRY-RUN"
echo ""
sudo rsync -navhPi --del --exclude='.git' "$DIR"/abz-scripts/ /usr/local/bin/
echo -e "\n\n\n\n""Move new scripts to /usr/local/bin and delete old scripts?           y""\n\n\n\n"
read confirmation

if [ "$confirmation" = "y" ]
then
sudo rsync -avhPi --del --exclude='.git' "$DIR"/abz-scripts/ /usr/local/bin/
clear
echo ""
echo "The Scripts have been synced to /usr/local/bin"
echo ""
else
exit-note
fi

echo -e "\n\n\n\n""Move new zshrc to "/home/$USER/.zshrc" and "/root/.zshrc"  ?           y""\n\n\n\n"
read confirmation

if [ "$confirmation" = "y" ]
then
sudo rsync -avhPi "$DIR"/abz-config/.zshrc /home/"$USER"/
sudo rsync -avhPi "$DIR"/abz-config/.zshrc /root/
else
exit-note
echo ""
echo ""
echo "Canceled the Operation (go do it yourself b**ch)"
fi

exit-note

fi

}




# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
[[ -n "${key[PageUp]}"  ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"   end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.

zle-line-init () {
    echoti smkx
}

zle-line-finish () {
    echoti rmkx
}

zle -N zle-line-init

zle -N zle-line-finish




# Autoload screen if we aren't in it.  (Thanks Fjord!)
# if [[ $STY = '' ]] then screen -xR; fi

#{{{ ZSH Modules

autoload -U compinit promptinit zcalc zsh-mime-setup zmv
compinit
promptinit
zsh-mime-setup

autoload -U colors && colors



#}}}

#{{{ Options

# why would you type 'cd dir' if you could just type 'dir'?
setopt AUTO_CD

# Now we can pipe to multiple outputs!
setopt MULTIOS

# Spell check commands!  (Sometimes annoying)
setopt CORRECTALL

# This makes cd=pushd
# setopt AUTO_PUSHD

# This will use named dirs when possible
setopt AUTO_NAME_DIRS

# If we have a glob this will expand it
setopt GLOB_COMPLETE
setopt PUSHD_MINUS

# No more annoying pushd messages...
# setopt PUSHD_SILENT

# blank pushd goes to home
setopt PUSHD_TO_HOME

# this will ignore multiple directories for the stack.  Useful?  I dunno.
# setopt PUSHD_IGNORE_DUPS

# 10 second wait if you do something that will delete everything.  I wish I'd had this before...
# setopt RM_STAR_WAIT

# use magic (this is default, but it can't hurt!)
setopt ZLE

setopt NO_HUP

#setopt VI

# disable ctrl-d for exiting the terminal and force typing (exit) 
# setopt IGNORE_EOF

# If I could disable Ctrl-s completely I would!
setopt NO_FLOW_CONTROL

# beeps are annoying
setopt NO_BEEP

# Keep echo "station" > station from clobbering station
setopt NO_CLOBBER

# Case insensitive globbing
setopt NO_CASE_GLOB

# Be Reasonable!
setopt NUMERIC_GLOB_SORT

# I don't know why I never set this before.
setopt EXTENDED_GLOB

# hows about arrays be awesome?  (that is, frew${cool}frew has frew surrounding all the variables, not just first and last
setopt RC_EXPAND_PARAM


unsetopt LIST_AMBIGUOUS

setopt  COMPLETE_IN_WORD



#}}}

#{{{ Variables

declare -U path



#}}}

#{{{ Completion Stuff

# Faster! (?)
zstyle ':completion::complete:*' use-cache 1

# case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _oldlist _expand _complete
zstyle ':completion:*' completer _expand _complete _approximate _ignored

# generate descriptions with magic.
zstyle ':completion:*' auto-description 'specify: %d'

# Don't prompt for a huge list, page it!
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Don't prompt for a huge list, menu it!
zstyle ':completion:*:default' menu 'select=0'

# Have the newer files last so I see them first
zstyle ':completion:*' file-sort modification reverse

# color code completion!!!!  Wohoo!
zstyle ':completion:*' list-colors "=(#a) #([0-9]#)*=36=31"

# Separate man page sections.  Neat.
zstyle ':completion:*:manuals' separate-sections true

# Egomaniac!
# zstyle ':completion:*' list-separator 'ASS'

# complete with a menu for xwindow ids
zstyle ':completion:*:windows' menu on=0
zstyle ':completion:*:expand:*' tag-order all-expansions

# more errors allowed for large words and fewer for small words
zstyle ':completion:*:approximate:*' max-errors 'reply=(  $((  ($#PREFIX+$#SUFFIX)/3  ))  )'

# Errors format
zstyle ':completion:*:corrections' format '%B%d (errors %e)%b'

# Don't complete stuff already on the line
zstyle ':completion::*:(rm|vi):*' ignore-line true

# Don't complete directory we are already in (../here)
zstyle ':completion:*' ignore-parents parent pwd

zstyle ':completion::approximate*:*' prefix-needed false


#}}}

#{{{ History Stuff

# Where it gets saved
HISTFILE=~/.zhistory

# Remember about a years worth of history (AWESOME)
SAVEHIST=100000
HISTSIZE=100000

# Don't overwrite, append!
setopt APPEND_HISTORY

# Write after each command
setopt INC_APPEND_HISTORY

# Killer: share history between multiple shells
setopt SHARE_HISTORY

# If I type cd and then cd again, only save the last one
setopt HIST_IGNORE_DUPS

# Even if there are commands inbetween commands that are the same, still only save the last one
setopt HIST_IGNORE_ALL_DUPS

# Pretty    Obvious.  Right? (Goddamit this is the culprit in history corruption)
#setopt HIST_REDUCE_BLANKS

# If a line starts with a space, don't save it.
#setopt HIST_IGNORE_SPACE
#setopt HIST_NO_STORE

# When using a hist thing, make a newline show the change before executing it.
setopt HIST_VERIFY

# Save the time and how long a command ran
setopt EXTENDED_HISTORY

setopt HIST_SAVE_NO_DUPS
#setopt HIST_EXPIRE_DUPS_FIRST
#setopt HIST_FIND_NO_DUPS




# add colors to completions
# general completion
#--------------------------------------------------
zstyle ':completion:*:descriptions' format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'
#-------------------------------------------------- 
#--------------------------------------------------
# zstyle ':completion:*:corrections' format $'%{\e[0;32m%}%d (errors: %e)%}'
#-------------------------------------------------- 
zstyle ':completion:*:messages' format '%d'
#--------------------------------------------------
zstyle ':completion:*:warnings' format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'
#-------------------------------------------------- 
#--------------------------------------------------
# zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' format '%d'
#-------------------------------------------------- 
#--------------------------------------------------
zstyle ':completion:*' format $'%{\e[0;31m%}%B%d%b%{\e[0m%}'
#-------------------------------------------------- 



# My ZSH Prompt

if [[ ${HOST} == "C0" ]]
then
 
 if [[ ${EUID} == "0" ]]
 then
 
 	if [[ ! -z "$SSH_CLIENT" ]]
 	then

PS1="
%F{red}%B - %@% %f - %w - %F{yellow}%B %/   - %f %(?.%F{green}%B[%?]%f.%F{red}%B[%?] )%f

%F{red}%B[%m]%f %F{blue}%B>> %F{white}%B(ssh) %f%b "

else

PS1="
%F{red}%B - %@% %f - %w - %F{yellow}%B %/   - %f %(?.%F{green}%B[%?]%f.%F{red}%B[%?] )%f

%F{red}%B[%m]%f %F{blue}%B>>%f%b "

	fi

else
 	if [[ ! -z "$SSH_CLIENT" ]]
 	then
	
PS1="
%F{green}%B - %@% %f - %w - %F{yellow}%B %/   - %f %(?.%F{green}%B[%?]%f.%F{red}%B[%?] )%f

%F{cyan}%B[%m]%f %F{blue}%B>> %F{white}%B(ssh) %f%b "

else

PS1="
%F{green}%B - %@% %f - %w - %F{yellow}%B %/   - %f %(?.%F{green}%B[%?]%f.%F{red}%B[%?] )%f

%F{cyan}%B[%m]%f %F{blue}%B>>%f%b "

	fi

fi



elif [[ ${HOST} == * ]]
then
 
 if [[ ${EUID} == "0" ]]
 then
 
 	if [[ ! -z "$SSH_CLIENT" ]]
 	then
	
PS1="
%F{red}%B - %@% %f - %w - %F{yellow}%B %/   - %f %(?.%F{green}%B[%?]%f.%F{red}%B[%?] )%f

%F{red}%B[%m]%f %F{blue}%B>> %F{white}%B(ssh) %f%b "

else

PS1="
%F{red}%B - %@% %f - %w - %F{yellow}%B %/   - %f %(?.%F{green}%B[%?]%f.%F{red}%B[%?] )%f

%F{red}%B[%m]%f %F{white}%B>>%f%b "


fi



else
 	if [[ ! -z "$SSH_CLIENT" ]]
 	then
	
PS1="
%F{green}%B - %@% %f - %w - %F{yellow}%B %/   - %f %(?.%F{green}%B[%?]%f.%F{red}%B[%?] )%f

%F{yellow}%B[%m]%f %F{white}%B>> %F{white}%B(ssh) %f%b "

else

PS1="
%F{green}%B - %@% %f - %w - %F{yellow}%B %/   - %f %(?.%F{green}%B[%?]%f.%F{red}%B[%?] )%f

%F{yellow}%B[%m]%f %F{white}%B>>%f%b "

	fi


fi
fi











preexec () {

    START_TIME=$(date +%s)
    CMD_NAME=$1
    echo -e "\n"

}
precmd () {
    if [ $? = 0 ];
	then
	STATUS="${GREEN}SUCCESS"
	else
	STATUS="${RED}FAILURE"
	fi

	
    if ! [[ -z $START_TIME ]]; then
	END_TIME=$(date +%s)
	END_TIME_SEC=$(( END_TIME - START_TIME ))
	END_TIME_MIN=$(( (END_TIME - START_TIME) / 60 ))
	END_TIME_HR=$(echo "scale=1; $END_TIME_MIN / 60" | bc)
    
	echo -e "\n\n\n${YELLOW}Command: ${COLOR_OFF}"
	echo -e "$CMD_NAME"
	echo ""

RUN_TIME="$(echo $END_TIME_SEC s)"

[[ "$END_TIME_MIN" -gt 1 ]] && RUN_TIME="$(echo $RUN_TIME - $END_TIME_MIN Min)"
[[ "$END_TIME_HR"  -gt 1 ]] && RUN_TIME="$(echo $RUN_TIME - $END_TIME_HR Hrs)"

echo -e "${YELLOW}Run Time: ${COLOR_OFF} $RUN_TIME"
echo -e "${YELLOW}Status: ${COLOR_OFF} $STATUS"

# For the command time history file (~/.zhistory-times)
if [[ "$END_TIME_SEC" -gt 5 ]] ;then
echo "
Time: $(date)
Command: $CMD_NAME
Run Time: $RUN_TIME" >>| ~/.zhistory-times
fi



	fi
}

