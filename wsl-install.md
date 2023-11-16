# WSL2 Ubuntu 22.04

# General

> - `sudo apt update`
> - `sudo apt upgrade`
> - `sudo apt autoremove`
> - `sudo apt install members`
> - `sudo apt install supervisor`
> - `sudo apt install composer`

# Apache

> - `sudo apt install apache2`

---

> - `cd /var/www/html`
> - `sudo rm index.html`
> - `cd /var`
> - `sudo chown -R USER:USERGROUP www`
> - `sudo chmod -R 775 www`
> - `sudo usermod -a -G USERGROUP www-data`
> - `sudo a2enmod rewrite`
> - `sudo service apache2 restart`

## Change executive user

https://www.simplified.guide/apache/change-user-and-group

> - `sudo vi /etc/apache2/apache2.conf`
> - search for line 115 & 116
  > <pre>
  > User USERNAME
  > Group GROUPNAME
  > </pre>
> - `sudo chown --recursive username:groupname /var/www`
> - `sudo service apache2 restart`

# PHP

https://linuxize.com/post/how-to-install-php-8-on-ubuntu-20-04/

> - `sudo apt install software-properties-common`
> - `sudo add-apt-repository ppa:ondrej/php`
> - `sudo apt install php7.4 libapache2-mod-php7.4`
> - `sudo apt install php7.4-mysql php7.4-curl php7.4-mbstring php7.4-xml php7.4-curl`

> - `sudo apt install php8.0 libapache2-mod-php8.0`
> - `sudo apt install php8.0-mysql php8.0-curl php8.0-mbstring php8.0-xml php8.0-curl`

> - `sudo apt install php8.1 libapache2-mod-php8.1`
> - `sudo apt install php8.1-mysql php8.1-curl php8.1-mbstring php8.1-xml php8.1-curl`

> - `sudo apt install php8.2 libapache2-mod-php8.2`
> - `sudo apt install php8.2-mysql php8.2-curl php8.2-mbstring php8.2-xml php8.2-curl`
> - `sudo service apache2 restart`

## PHP-FPM (FastCGI)

> - `sudo apt update`
> - `sudo apt install php7.4-fpm libapache2-mod-fcgid`
> - `sudo a2enmod proxy_fcgi setenvif actions fcgid alias`
> - `sudo a2enconf php7.4-fpm`
> - `sudo service apache2 restart`

---

> - `sudo apt update`
> - `sudo apt upgrade`

# MySQL

https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-20-04

> - `sudo apt install mysql-server`
> - `sudo service mysql start`  
> should start without error

## Fix mysql-password

> - `sudo service mysql stop`
> - `sudo vim /etc/my.cnf`
  > <pre>
  > [mysqld]
  > skip-grant-tables
  > </pre>
> - `sudo service mysql start`  
> - `sudo mysql`
> - `mysql> select mysql;`
> - `mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';`
> - `mysql> exit`
> - `sudo mysql_secure_installation`

## MySQL Secure Installation

> - `set mysql-password for user 'root'`
> - `reenter mysql-password for user 'root'`
> - `delete anonymous user: y`
> - `dissallow root-login from network: y`
> - `remove test-database: y`
> - `reload privileges table: y`
> - `sudo mysql -uroot -p`

This should open mysql-cli

## Fix mysql home directory

If `sudo service mysql start` shows error 'Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock'' do:

> - `sudo service mysql stop`
> - `sudo usermod -d /var/lib/mysql/ mysql`
> - `sudo service mysql start`

The error should now be gone.

# PhpMyAdmin

> - `sudo apt install phpmyadmin`
> - `sudo a2enconf phpmyadmin`
> - `sudo service apache2 restart`

## Upgrade PhpMyAdamin from lower version without default repository
  >
  > https://devanswers.co/manually-upgrade-phpmyadmin/  
  > Research for latest PhpMyAdmin version here: https://www.phpmyadmin.net/downloads/  
  > For version `5.2.0` there is a `config.sample.inc.php` located at `/usr/share/phpmyadmin`
  > use this file to copy and insert the 32-char blowfish_secret.

## PhpMyAdmin Blowfish Secret

https://www.hostnet.de/faq/was-bedeutet-ab-sofort-muss-ein-geheimes-passwort-zur-verschluesselung-in-der-konfigurationsdatei-gesetzt-werden-blowfish_secret.html

> - `cd /usr/share/phpmyadmin`
> - `sudo cp config.sample.inc.php config.inc.php`
> - `sudo vim config.inc.php`
  > <pre>
  > $cfg['blowfish_secret'] = 'RANDOMPASSWORD';
  > </pre>

## PHP FCGI

https://tecadmin.net/setup-apache-php-fpm-ubuntu-20-04/

- `sudo vim /etc/apache2/sites-available/000-default.conf`
  > <pre>
  > &lt;Directory /var/www/html>
  > 	Options -Indexes +FollowSymLinks +MultiViews
  >    	AllowOverride All
  >    	Require all granted
  > &lt;/Directory>
  > 
  > &lt;FilesMatch \.php$>
  > 	# 2.4.10+ can proxy to unix socket
  >    	SetHandler "proxy:unix:/var/run/php/php8.0-fpm.sock|fcgi://localhost"
  > &lt;/FilesMatch>
  > ``</pre>
- `cd /var/www/html`
- `vim info.php`
  > <pre>
  > &lt;?php
  > phpinfo();
  > </pre>

Each virtual host has to use this `<FileMatch>`-directive to ensure processing of php-files.

Request http://localhost/phpmyadmin to open login-page.

# VIM

- `cd ~`
- `vim .vimrc`
  > <pre>set number</pre>

# VSCode Remote-Server

- `cd ~/.vscode-server/server-env-setup`
  > <pre>umask 002</pre>

# WSL-Autostart

https://github.com/troytse/wsl-autostart
This only starts services for the wsl instance set as default

- `wsl --set-default Ubuntu-20.04`
- `sudo visudo`
  > <pre>
  > %sudo ALL=NOPASSWD: /etc/init.d/cron
  > %sudo ALL=NOPASSWD: /etc/init.d/mysql
  > %sudo ALL=NOPASSWD: /etc/init.d/apache2
  > %sudo ALL=NOPASSWD: /etc/init.d/php8.0-fpm
  > %sudo ALL=NOPASSWD: /etc/init.d/supervisor
  > </pre>

# WSL-Autostart Alternative

- `cd /usr/local/bin`
- `vim startup`
  > <pre>
  > /etc/init.d/cron start
  > /etc/init.d/mysql start
  > /etc/init.d/apache2 start
  > /etc/init.d/supervisor start
  > /etc/init.d/php8.0-fpm start
  > </pre>
- `chmod 700 startup`

# Tmux

- `sudo apt install tmux`
- `vim ~/.tmux.conf`
  > <pre>
  > set -g default-terminal "screen-256color"
  > </pre>

# Apache2 port-config for parallel WSL2 instances

https://ostechnix.com/how-to-change-apache-ftp-and-ssh-default-port-to-a-custom-port-part-1/

- `sudo vi /etc/apache2/ports.conf`
  > <pre>
  > Listen 8080
  > </pre>
- `sudo vi /etc/apache2/sites-available/000-default.conf`
  > <pre>
  > &lt;VirtualHost *:8080>
  > </pre>

# MySQL port-config for parallel WSL2 instances

https://github.com/microsoft/WSL/issues/2113#issuecomment-704856068

- `sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf`
  > <pre>
  > port= 8090
  > </pre>

## Add SSH-identity

https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04-de

- `ssh-keygen`

### Add ssh-key permanently to avoid input passphrase everytime

https://askubuntu.com/questions/362280/enter-ssh-passphrase-once

- `ssh-agent bash`
- `ssh-add ~/.ssh/id_rsa`

# Directory permissions

## Create all new object as 664/ 775

- `sudo vim /etc/profile`

  > <pre>umask 002</pre>

- `vim ~/.profile`

  > <pre>umask 002</pre>

- `vim ~/.bashrc`

  > <pre>umask 002</pre>

- `setSource`

# PHP CS-Fixer

Install csfixer for PHP  
composer require friendsofphp/php-cs-fixer  
https://redberry.international/linting-a-laravel-project-using-cs-fixer/  
https://github.com/RedberryProducts/configs/blob/php-cs-fixer/.php-cs-fixer.php

# Aliases

- `vim ~/.bash_aliases`
  > <pre>
  > alias html='cd /var/www/html'
  > alias www='cd /var/www/'
  > alias ..='cd ../'
  > alias ...='cd ../../'
  > alias ....='cd ../../../'
  > 
  > ### PROGRAMS
  > alias explore='explorer.exe .'
  > 
  > ### GENERAL
  > alias setSource='source ~danaq/.bashrc'
  > alias apti='apt install -y'
  > 
  > ### GIT
  > alias gs='git status'
  > alias gc='git commit -m'
  > 
  > ### LARVEL
  > alias pa='php artisan'
  > alias pf='clear && ./vendor/bin/phpunit --filter'
  > alias punit='clear && ./vendor/bin/phpunit'
  > alias pest='clear && ./vendor/bin/pest'
  > 
  > ### SSH
  > alias ssh[XYZ]='ssh [SSH-USER]@[SERVER_DOMAIN]'
  </pre>

# Composer

https://www.digitalocean.com/community/tutorials/how-to-install-and-use-composer-on-ubuntu-20-04-de

## Composer self-update fails

Remove composer  
> `sudo-apt remove composer`  

Then install manually:  
> `php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"`  
> `php composer-setup.php`  
> `php -r "unlink('composer-setup.php');"`
> `sudo mv composer.phar /usr/local/bin/composer`  

Check version afterwards:  
> `composer --version`  

Output: Composer version 2.5.8 2023-06-09 17:13:21
> You should be able to run `composer global self-update` now.

# SQlite >3.38 for PHP (relevant for e.g. JSON-columns in laravel >=9)

https://vikborges.com/articles/making-php-8-use-the-latest-version-of-sqlite3-on-ubuntu-20-04-lts

https://sqlite.org/download.html

```shell
	wget https://sqlite.org/2021/sqlite-autoconf-3340100.tar.gz # select current version from sqlite.org
	tar -xvf sqlite-autoconf-3340100.tar.gz && cd sqlite-autoconf-3340100
	sudo apt-get install libreadline-dev
	./configure
	make
	sudo apt-get purge sqlite3
	sudo make install
	export PATH="/usr/local/bin:$PATH"  # also add in your .bashrc
	sqlite3 --version
```

# Useful tools

## Pipe Viewer

https://www.ivarch.com/programs/pv.shtml

> usefull to see for example progress of sql-import
>
> ```shell
> $ pv sqlfile.sql | mysql -u[USER] -p[PASSWORD] dbname
> ```
