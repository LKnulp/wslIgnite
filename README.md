# WSL-Ignite

This is a set of configuration files and tools to quickly set up a fresh WSL-Distro.

> ## Be Aware
>
> `wsl.cfg` and `wsl.conf` aren't the same.
>
> > ### WSL.CFG
> >
> > This file holds configuration for the WSL-Ignite tooling package.
>
> > ### WSL.CONF
> >
> > This file is a configuration file percieved by the Windows host system.  
> > Please note, that the [boot]-option only applies under Win11.

```console
$ cd ~
```

```console
$ git clone git@github.com:LKnulp/wslIgnite.git
```

```console
$ cd wslIgnite
```

```console
$ cp wsl.cfg.example wsl.cfg
$ sudo ln -sf $HOME/wslIgnite/wsl.cfg /wsl.cfg
$ nano wsl.cfg
```

```console
$ cp .bash_aliases.example .bash_aliases
$ ln -sf $HOME/wslIgnite/.bash_aliases $HOME/.bash_aliases
$ nano .bash_aliases
$ source ~/.bashrc
```

```console
$ ln -sf $HOME/wslIgnite/.tmux.conf $HOME/.tmux.conf
```

```console
$ ln -sf $HOME/wslIgnite/.vimrc $HOME/.vimrc
```

```console
$ sudo ln -sf $HOME/wslIgnite/vhost /usr/local/bin/vhost
```

```console
$ sudo ln -sf $HOME/wslIgnite/changePHP /usr/local/bin/changePHP
```

```console
$ sudo ln -sf $HOME/wslIgnite/wsl.conf /etc/wsl.conf
```
