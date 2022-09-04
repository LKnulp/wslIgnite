# WSL-Ignite

&nbsp; This is a set of configuration files and tools to quickly set up a fresh WSL-Distro.  
&nbsp; It's created to use it on Windows 10/11 with WSL1, apache2 and PHP ^7.4.

<div style="background-color: purple; padding: 5px;border-radius:5px;margin-bottom: 10px;">
<b><u>WARNING:</u> This set was createt and tested to the best of our knowledge and belief. Althoug, make sure you know what you're doing.</b><br />
<b>Never use this at critical infrastructure like production-environment, etc!</b>
</div>

---

## Contents

1. [How to use](#1-how-to-use)
2. [Installation](#2-installation)
   1. [By Script](#21-installation-by-script)
   2. [Manually](#22-manual-install)
   3. [Removing](#23-removing)
3. [Whats in here](#3whats-in-here)
   1. [General](#31-general)
   2. [Tmux](#32-tmux)
   3. [Vim](#33-vim)
   4. [Bash-Aliases](#34-aliases)
   5. [Change-PHP](#35-changephp)
   6. [Vhost](#36-vhost)
   7. [Wsl.conf](#37-wslconf)
   8. [WslIgnite.conf](#38-wsligniteconf)
   9. [Config-PHP](#39-configphp)
4. [Manual Steps](#5-manual-installation)

## 1. How to use

---

&nbsp; It is suggested to clone this repository into your home-directory.

```console
$ cd ~
$ git clone git@github.com:LKnulp/wslIgnite.git ./wslIgnite
$ cd wslIgnite
```

## 2. Installation

---

### 2.1 Installation by script

&nbsp; If you want to use the install-script call `spark.sh`.  
&nbsp; If you specified a different name of the directory or used a whole different path, please make sure to update  
&nbsp; the `spark.conf` before runing the installation.

```console
$ sudo ./spark.sh
```

&nbsp; See

```console
$ sudo ./spark.sh -h
```

&nbsp; to learn how to modify the installation.

&nbsp; Make sure to run

```console
source ~/.bashrc
```

&nbsp; after the installation finished.

---

### 2.2 Manual install

&nbsp; Although the installation by script is recommended, if you want to perform the installation manually, you can find the steps [here](#5-manual-installation).

---

### 2.3 Removing

&nbsp; You can remove all changes, links and files created by the install by calling

```console
$ sudo ./spark.sh -r
```

&nbsp; Don't worry, you don't have to give the uninstall the exact same parameters as used for install.  
&nbsp; The script will complain that locations cannot be removed but it will succeed anyway.

## 3. What's in here

---

```
wslIgnite/............................ Your wslIgnite-package directory, may vary on the clone-name you choose.
│
├── fuel/............................. Holds all the files for local use/ change after copying and linking.
│   │
│	├── .bash_aliases.example......... A suggestion for useful shortcuts
│   │
│	├── changePHP.sh.example.......... A tool to change the active PHP-version for CLI and apache2 in one command
|	│
|	├── configPHP.sh.example.......... A tool to change basic setting of a PHP-version to make local-dev easier.
│   │                                  For CLI and apache2
│	├── tmux.conf.example............ A very basic tmux configuration to make live easier (mouse-support)
│   │
│	├── vhost.sh.example.............. A tool to create or remove vhosts (directories and configuration) for apache2
│   │
│	├── vimrc.example................ A very basic vim configuration to make it look better
│   │
|	├── wsl.conf.example.............. A basic configuration of WSL to make networking easier
│   │
│	└── wslIgnite.conf.example........ A configuration for the tool-scripts included here
│
├── ***.bash_aliases
│
├── .gitignore
│
├── ***changePHP.sh
│
├── ***configPHP.sh
│
├── README.md
│
├── spark.conf........................ The configuration for the install-script
│
├── spark.sh.......................... The install-script
│
├── ***tmux.conf
│
├── ***vhost.sh
│
├── ***vimrc
│
├── wsl-install.md.................... A collection of steps and tips to make WSL1 a local DEV-environment
│
├── ***wsl.conf
│
└── ***wslIgnite.cfg
```

### 3.1 General

---

Each file (`*.example`) within the `fuel`-directory will be copied into the root directory by the `spark.sh` install script for you.  
Also, all of these (potentially) copied files are added to the `.gitignore` by default, to give you the ability to modify them the way you want.  
All of these config-files and tool-scripts will then be made usable by creating [sym-links](https://wiki.ubuntuusers.de/ln/) at the preferred locations all over the WSL-distro.

<div style="background-color: #E67E22; padding: 5px;border-radius:5px;margin-bottom: 10px;">
<b><u>Attention:</u> At the moment, this package is created an maintained to support a WSL-instance of Ubuntu 18/20/22 on a Windows-hostsystem 10/11. </b><br />  
<b>Moreover it assumes that an apache2 webserver as well as VS-Code is used.</b>
</div>

### 3.2 Tmux

---

> This basic config was grabbed from [https://juliu.is/a-simple-tmux/](https://juliu.is/a-simple-tmux/)

If you choose to install this, a sym-link within your $HOME-directory named `.tmux.conf` will be created,  
pointing to the copied `.tmux.conf` within the root of this package.

### 3.3 Vim

---

> This basic config was grabbed from [https://www.freecodecamp.org](https://www.freecodecamp.org/news/vimrc-configuration-guide-customize-your-vim-editor/)

If you choose to install this, a sym-link within your $HOME-directory named `.vimrc`will be created,  
pointing to the copied `.vimrc` within the root of this package.

### 3.4 Aliases

---

> This is just a set of bash-aliases which were found useful over the time. Feel free to extend or change them by your flavor.

If you choose to install this, a sym-link within your $HOME-directory named `.bash_aliases` will be created,
pointing to the copied `.bash_aliases` within the root of this package.

Among other things, aliases are included to give you quick access (VS-Code) to the different config files of this package as well as a shortcut to edit the windows hosts-file.

It also sets a new code for you PS1 promt. If you dont want this, just remove the last line in the `.bash_aliases` file.

If a `$HOME/.bash_aliases`-file already exists, the install-script will take care, that your current custom aliases  
are prependet to those suggestet by this package. Your previous `.bash_aliases` is then replaced by the sym-link.

### 3.5 ChangePHP

---

> This was created by the need of having a shortcut for this task in the meantime. Consider to use [docker](https://www.udemy.com/course/lokale-web-entwicklung-mit-docker-fur-nicht-devops/) for instance.

If you choose to install this, a sym-link at `/usr/local/bin/changePHP` will be created,  
pointing to the copied `changePHP.sh` within the root of this package.

### 3.6 Vhost

---

> This was originally grabbed from [https://github.com/RoverWire/virtualhost](https://github.com/RoverWire/virtualhost) and adapted to the needs in WSL.

If you choose to install this, a sym-link at `/usr/local/bin/vhost` will be created,  
pointing to the copied `vhost.sh` within the root of this package.

`vhost` will create or remove:

- vhost directory
- document-root directory (if specified) with phpinfo-file
- apache2 vhost configuration
- reloading apache2 (add or remove vhost from apache2)
- open Windows hosts file in VS-Code for quick editing

### 3.7 wsl.conf

---

> This file holds basic configuration for the WSL-distribution and was created using [documentation](https://docs.microsoft.com/de-de/windows/wsl/wsl-config).
> Extend or change it by your needs.

If you choose to install this, a sym-link at `/etc/wsl.conf` will be created,  
pointing to the copied `wsl.conf` within the root of this package.

<div style="background-color: #E67E22; padding: 5px; border-radius:5px;margin-bottom: 10px;">
<b><u>Attention:</u> If you are using this on a Win10 host, make sure to remove the last line of this file as it only works correctly with Win11<br />
and can cause unexpected behavior on Win10.</b>
</div>

### 3.8 wslIgnite.conf

---

> This file is used to hold any configuration for the tools within this package.  
> Change it by your needs, expecally to make the vhost-script working if you don't have a default WSL-installation (different Linux-Distro, etc.).

<div style="background-color: #E67E22; padding: 5px; border-radius:5px;margin-bottom: 10px;">
<b><u>Attention:</u> Make sure that this file exists in the same directory as the actual tool-script-executables as they are searching for it next to themself.</b> <br />  
<b>But don't worry, the fact that executables are called as sym-links is covered.</b><br />
<b>So for exaple if you have the default <code style="color: #6E2C00;">/usr/local/bin/vhost</code> => <code style="color: #6E2C00;">$HOME/wslIgnite/vhost.sh</code>, <code style="color: #6E2C00;">vhost</code> want's the <code style="color: #6E2C00;">wslIgnite.conf</code> at <code style="color: #6E2C00;">$HOME/wslIginte/wslIgnite.conf</code>.</b>
</div>

### 3.9 ConfigPHP

---

> This tool was createt to have a shortcut for editing the most importatnt things of a fresh installed php-version for local-development.

If you choose to install this, a sym-link at `/usr/local/bin/configPHP` will be created,  
pointing to the copied `configPHP.sh` within the root of this package.

`configurePHP` will set the folowing directives at apache2/php.ini & cli/php.ini:

- `memory_limit` : 1024M (not for cli-ini as it is `-1`)
- `post_max_size` : 2048M
- `upload_max_filesize`: 2048M

## 4. Manual Installation

---

### 4.1 wslIgnite-conf

```console
$ cp $HOME/wslIgnite/fuel/wslIgnite.conf.example $HOME/wslIgnite/wslIgnite.conf
$ nano $HOME/wslIgnite/wslIgnite.conf
```

### 4.2 bash-aliases

```console
$ cp $HOME/wslIgnite/fuel/.bash_aliases.example $HOME/wslIgnite/.bash_aliases
$ echo $HOME/wslIgnite/.bash_aliases >> $HOME/.bash_aliases
$ echo $HOME/.bash_aliases > $HOME/wslIgnite/.bash_aliases
$ rm $HOME/.bash_aliases
$ ln -sf $HOME/wslIgnite/.bash_aliases $HOME/.bash_aliases
$ nano $HOME/wslIgnite/.bash_aliases
$ source $HOME/.bashrc
```

### 4.3 tmux-conf

```console
$ cp $HOME/wslIgnite/fuel/tmux.conf.example $HOME/wslIgnite/tmux.conf
$ ln -sf $HOME/wslIgnite/tmux.conf $HOME/.tmux.conf
```

### 4.4 vimrc

```console
$ cp $HOME/wslIgnite/fuel/vimrc.example $HOME/wslIgnite/vimrc
$ mkdir -p $HOME/.vim $HOME/.vim/autoload $HOME/.vim/backup $HOME/.vim/colors $HOME/.vim/plugged
$ ln -sf $HOME/wslIgnite/vimrc $HOME/.vimrc
$ cd $HOME/.vim/colors
$ curl -o molokai.vim https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim
```

### 4.5 vhost

```console
$ cp $HOME/wslIgnite/fuel/vhost.sh.example $HOME/wslIgnite/vhost.sh
$ sudo ln -sf $HOME/wslIgnite/vhost.sh /usr/local/bin/vhost
```

### 4.6 changePHP

```console
$ cp $HOME/wslIgnite/fuel/changePHP.sh.example $HOME/wslIgnite/changePHP.sh
$ sudo ln -sf $HOME/wslIgnite/changePHP.sh /usr/local/bin/changePHP
```

### 4.7 wsl-conf

```console
$ cp $HOME/wslIgnite/fuel/wsl.conf.example $HOME/wslIgnite/wsl.conf
$ sudo ln -sf $HOME/wslIgnite/wsl.conf /etc/wsl.conf
$ nano $HOME/wslIgnite/wsl.conf
```

### 4.8 config.php

```console
$ cp $HOME/wslIgnite/fuel/configPHP.sh.example $HOME/wslIgnite/configPHP.sh
$ sudo ln -sf $HOME/wslIgnite/configPHP.sh /usr/local/bin/configPHP
```
