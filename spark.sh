#!/bin/bash

### Set colors
ERROR='\033[1;35m' # light purple
QUESTION='\033[1;33m' # yellow
SUCCESS='\033[0;32m' # green
PROCESSING='\033[1;36m' # light cyan
NC='\033[0m' # No Color

function show_help {
	echo -e "Usage:  $BASH_SOURCE [ OPTIONS ]"
	echo -e "   This will install content from the wslIgnite-package."
	echo -e "   To skip steps, set the respective option."
	echo -e "   ========================================="
	echo -e "	OPTIONS := { "
	echo -e "		-a[liases]		skip install of .bash_aliases"
	echo -e "		-c[hangePHP] 		skip install of changePHP-script"
	echo -e "		-e[ditor]		skip install of .vimrc config"
	echo -e "		-t[mux]			skip install of .tmux-config"
	echo -e "		-v[host]		skip install of vhost-script"
	echo -e "		-w[sl]			skip install of wsl.conf"
	echo -e "		-p[hp]			skip install of configPHP-script"
	echo -e "		==================================================="
	echo -e "       -r[emove]       remove all parts"
	echo -e "		==================================================="
	echo -e "		-d[ebug]		show used parameters of this script"
	echo -e "		-h[elp]			show this help message"
	echo -e "	}"
}

debug="false"
changePHP="true"
aliases="true"
tmux="true"
vimrc="true"
vhost="true"
wsl="true"
configPHP="true"
install="true"
remove="false"
configFile=./spark.conf
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

while [ -n "$1" ]; do # while loop starts
	case "$1" in
		-c) changePHP="false";;
		-a) aliases="false";;
		-t) tmux="false";;
		-e) vimrc="false";;
		-v) vhost="false";;
		-w) wsl="false";;
		-p) configPHP="false";;
		-r) install="false"
			remove="true"
			;;
		-d) debug="true";;
		-h) show_help
			exit;;
		*) echo -e "Unexpected option $1" 
			show_help
			exit 1
			;;
	esac
	shift
done

if [ $debug == "true" ]; then
	echo -e "\n DEBUG: >"
	echo -e " ========"
	echo -e "   ${PROCESSING}changePHP:${NC} $changePHP"
	echo -e "   ${PROCESSING}aliases:${NC} $aliases"
	echo -e "   ${PROCESSING}tmux:${NC} $tmux"
	echo -e "   ${PROCESSING}vimrc:${NC} $vimrc"
	echo -e "   ${PROCESSING}vhost:${NC} $vhost"
	echo -e "   ${PROCESSING}wsl:${NC} $wsl"
	echo -e "   ${PROCESSING}configPHP:${NC} $configurePHP"
	echo -e " ========"
	echo -e "   ${PROCESSING}install:${NC} $install"
	echo -e "   ${PROCESSING}remove:${NC} $remove"
	echo -e " ========"
	echo -e "   ${PROCESSING}SCRIPT_DIR:${NC} $SCRIPT_DIR"
	echo -e "   ${PROCESSING}WSL_IGNITE_EXEC_PATH:${NC} $WSL_IGNITE_EXEC_PATH"
	echo -e "   ${PROCESSING}WSL_IGNITE_WSLCONF_PATH:${NC} $WSL_IGNITE_WSLCONF_PATH"
	echo -e "\n"
	exit 1;
fi

if [ $install == "true" ]; then
	echo -e $"\n* ${PROCESSING}We will start VS-Code. Installation will continue here...${NC}\n"
else
	echo -e $"\n* ${PROCESSING}We will start VS-Code. Uninstall will continue here...${NC}\n"
fi

/mnt/c/Program\ Files/Microsoft\ VS\ Code/bin/code > /dev/null
sleep 1s
echo -e $"* ${PROCESSING}Starting VS-Code...${NC}\n"
sleep 1s

if [ $install == "true" ]; then
	echo -e $"* ${PROCESSING}Installing spark.conf...\n${NC}"
	cp $SCRIPT_DIR/fuel/spark.conf.example $SCRIPT_DIR/spark.conf

	echo -e $"${QUESTION}Please complete the install configuration with your linux user${NC}\n"
	echo -e -n $"${QUESTION}Press ENTER to open install-config...${NC}\n"
	read configSet
	nano $SCRIPT_DIR/spark.conf

	echo -e -n $"${QUESTION}Configuration OK?... Great! Press ENTER to continue...${NC}\n"
	read configSet
fi

if [ ! -f $configFile ]; then
	echo -e $"${ERROR}You have no configuration file at '$SCRIPT_DIR/spark.conf'!${NC}"
	exit 1;
else
	source $configFile
	WSL_IGNITE_EXEC_PATH=$(echo $WSL_IGNITE_EXEC_PATH | sed 's:/*$::')
	WSL_IGNITE_WSLCONF_PATH=$(echo $WSL_IGNITE_WSLCONF_PATH | sed 's:/*$::')
	chown $WSL_IGNITE_USER:$WSL_IGNITE_USER $SCRIPT_DIR/spark.conf
fi

if [ $$WSL_IGNITE_USER == '' ]; then
	echo -e $"${ERROR}There is no user set in the configuration. Please check!${NC}"
	exit 1;
fi

if [ $install == "true" ]; then

	if [[ $changePHP == "true" || $vhost == "true" || $configPHP == "true" ]]; then
		echo -e $"* ${PROCESSING}Installing wslIgnite.conf...\n${NC}"
		
		cp $SCRIPT_DIR/fuel/wslIgnite.conf.example $SCRIPT_DIR/wslIgnite.conf
		chown $WSL_IGNITE_USER:$WSL_IGNITE_USER $SCRIPT_DIR/wslIgnite.conf
		/mnt/c/Program\ Files/Microsoft\ VS\ Code/bin/code $SCRIPT_DIR/wslIgnite.conf > /dev/null
	fi

	if [ $changePHP == "true" ]; then
		echo -e $"* ${PROCESSING}Installing changePHP-tool...\n${NC}"

		cp $SCRIPT_DIR/fuel/changePHP.sh.example $SCRIPT_DIR/changePHP.sh
		ln -sf $SCRIPT_DIR/changePHP.sh $WSL_IGNITE_EXEC_PATH/changePHP
		chown $WSL_IGNITE_USER:$WSL_IGNITE_USER $SCRIPT_DIR/changePHP.sh
		chmod 775 $SCRIPT_DIR/changePHP.sh
	fi

	if [ $aliases == "true" ]; then
		echo -e $"* ${PROCESSING}Installing .bash_aliases...\n${NC}"

		cp $SCRIPT_DIR/fuel/.bash_aliases.example $SCRIPT_DIR/.bash_aliases
		cat $SCRIPT_DIR/.bash_aliases >> $HOME/.bash_aliases
		echo > $SCRIPT_DIR/.bash_aliases
		cat $HOME/.bash_aliases >> $SCRIPT_DIR/.bash_aliases
		rm $HOME/.bash_aliases
		ln -sf $SCRIPT_DIR/.bash_aliases $HOME/.bash_aliases
		chown $WSL_IGNITE_USER:$WSL_IGNITE_USER $SCRIPT_DIR/.bash_aliases
		/mnt/c/Program\ Files/Microsoft\ VS\ Code/bin/code $SCRIPT_DIR/.bash_aliases > /dev/null
		source $HOME/.bashrc
	fi

	if [ $tmux == "true" ]; then
		echo -e $"* ${PROCESSING}Installing tmux.conf...\n${NC}"

		cp $SCRIPT_DIR/fuel/tmux.conf.example $SCRIPT_DIR/tmux.conf
		ln -sf $SCRIPT_DIR/tmux.conf $HOME/.tmux.conf
		chown $WSL_IGNITE_USER:$WSL_IGNITE_USER $SCRIPT_DIR/tmux.conf
	fi

	if [ $vimrc == "true" ]; then
		echo -e $"* ${PROCESSING}Installing vimrc...\n${NC}"

		cp $SCRIPT_DIR/fuel/vimrc.example $SCRIPT_DIR/vimrc
		mkdir $HOME/.vim 
		chown $WSL_IGNITE_USER:$WSL_IGNITE_USER $HOME/.vim 
		mkdir $HOME/.vim/autoload
		chown $WSL_IGNITE_USER:$WSL_IGNITE_USER $HOME/.vim/autoload 
		mkdir $HOME/.vim/backup
		chown $WSL_IGNITE_USER:$WSL_IGNITE_USER $HOME/.vim/backup 
		mkdir $HOME/.vim/colors
		chown $WSL_IGNITE_USER:$WSL_IGNITE_USER $HOME/.vim/colors 
		mkdir $HOME/.vim/plugged
		chown $WSL_IGNITE_USER:$WSL_IGNITE_USER $HOME/.vim/plugged
		ln -sf $SCRIPT_DIR/vimrc $HOME/.vimrc
		chown $WSL_IGNITE_USER:$WSL_IGNITE_USER $SCRIPT_DIR/vimrc
		cd $HOME/.vim/colors
		echo -e $"* ${PROCESSING}Installing vim colorscheme 'molokai'...\n${NC}"
		curl -o molokai.vim https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim
		echo -e "\n"
		chown $WSL_IGNITE_USER:$WSL_IGNITE_USER $HOME/.vim/colors/molokai.vim
	fi

	if [ $vhost == "true" ]; then
		echo -e $"* ${PROCESSING}Installing vhost-tool...\n${NC}"

		cp $SCRIPT_DIR/fuel/vhost.sh.example $SCRIPT_DIR/vhost.sh
		ln -sf $SCRIPT_DIR/vhost.sh $WSL_IGNITE_EXEC_PATH/vhost
		chown $WSL_IGNITE_USER:$WSL_IGNITE_USER $WSL_IGNITE_EXEC_PATH/vhost
		chmod 775 $SCRIPT_DIR/vhost.sh
	fi

	if [ $wsl == "true" ]; then
		echo -e $"* ${PROCESSING}Installing wsl.conf...\n${NC}"

		cp $SCRIPT_DIR/fuel/wsl.conf.example $SCRIPT_DIR/wsl.conf
		ln -sf $SCRIPT_DIR/wsl.conf $WSL_IGNITE_WSLCONF_PATH/wsl.conf
		chown $WSL_IGNITE_USER:$WSL_IGNITE_USER $WSL_IGNITE_WSLCONF_PATH/wsl.conf
        chmod 666 $SCRIPT_DIR/wsl.conf
		/mnt/c/Program\ Files/Microsoft\ VS\ Code/bin/code $SCRIPT_DIR/wsl.conf > /dev/null
	fi

	if [ $configPHP == "true" ]; then
		echo -e $"* ${PROCESSING}Installing configPHP-tool...\n${NC}"

		cp $SCRIPT_DIR/fuel/configPHP.sh.example $SCRIPT_DIR/configPHP.sh
		ln -sf $SCRIPT_DIR/configPHP.sh $WSL_IGNITE_EXEC_PATH/configPHP
		chown $WSL_IGNITE_USER:$WSL_IGNITE_USER $WSL_IGNITE_EXEC_PATH/configPHP
		chmod 775 $SCRIPT_DIR/configPHP.sh
	fi

	echo -e -n $"${QUESTION}Please check VS-Code to complete all installed config-files. Press ENTER to continue...${NC}\n"
	read installComplete

	echo -e $"\n${SUCCESS}Installation complete!!${NC}"
	echo -e $"${QUESTION}Please run source ~/.bashrc to enable new configuration${NC}\n"
	exit 1;
fi

if [ $remove == "true" ]; then

	echo -e $"\n* ${PROCESSING}Removing wslIgnite.conf...\n${NC}"
	
	rm $SCRIPT_DIR/wslIgnite.conf

	echo -e $"* ${PROCESSING}Removing changePHP-tool...\n${NC}"

	rm $SCRIPT_DIR/changePHP.sh
	rm $WSL_IGNITE_EXEC_PATH/changePHP

	echo -e $"* ${PROCESSING}Removing .bash_aliases...\n${NC}"

	rm $HOME/.bash_aliases
	cat $SCRIPT_DIR/.bash_aliases >> $HOME/.bash_aliases
	chown $WSL_IGNITE_USER:$WSL_IGNITE_USER $HOME/.bash_aliases
	rm $SCRIPT_DIR/.bash_aliases
	/mnt/c/Program\ Files/Microsoft\ VS\ Code/bin/code $HOME/.bash_aliases > /dev/null
	source $HOME/.bashrc

	echo -e $"* ${PROCESSING}Removing tmux.conf...\n${NC}"

	rm $HOME/.tmux.conf
	rm $SCRIPT_DIR/tmux.conf

	echo -e $"* ${PROCESSING}Removing vimrc...\n${NC}"

	rm $HOME/.vimrc
	rm $SCRIPT_DIR/vimrc
	rm -Rf $HOME/.vim 

	echo -e $"* ${PROCESSING}Removing vhost-tool...\n${NC}"

	rm $SCRIPT_DIR/vhost.sh
	rm $WSL_IGNITE_EXEC_PATH/vhost

	echo -e $"* ${PROCESSING}Removing wsl.conf...\n${NC}"

	rm $SCRIPT_DIR/wsl.conf
	rm $WSL_IGNITE_WSLCONF_PATH/wsl.conf

	echo -e $"* ${PROCESSING}Removing configPHP-tool...\n${NC}"

	rm $SCRIPT_DIR/configPHP.sh
	rm $WSL_IGNITE_EXEC_PATH/configPHP

	echo -e $"* ${PROCESSING}Removing spark.conf...\n${NC}"

	rm $SCRIPT_DIR/spark.conf

	echo -e -n $"${QUESTION}Please check VS-Code to see your new .bash_alises file. Press ENTER to continue...${NC}\n"
	read installComplete

	echo -e $"\n${SUCCESS}Uninstall complete!!${NC}"
	echo -e $"${QUESTION}Please run source ~/.bashrc to enable new configuration${NC}\n"
	exit 1;
fi
