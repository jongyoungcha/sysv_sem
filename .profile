# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -f ~/jong-base.sh ]; then
	source ~/jong-base.sh
fi


export TERM=xterm-256color
source ~/.swit_env

if [ $(uname) == "Darwin" ]; then
	export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
	export CLICOLOR=1
	export LSCOLORS=ExFxBxDxCxegedabagacad
	alias ls='ls -GFh'
fi

if [ $(uname) == "Darwin" ]; then
	export GOROOT=/usr/local/Cellar/go/1.13.4/libexec/
else
	export GOROOT=~/goroot
fi
export GOPATH=~/go
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin

export PATH=~/.local/bin:$PATH
export PATH=/usr/local/Cellar/mysql@5.7/5.7.28/bin:$PATH

export GOTRACEBACK=crash
export BOOST_ROOT=~/.local/boost

export RUST_HOME=~/.cargo/
export PATH=$PATH:$RUST_HOME/bin

#export RUST_BACKTRACE=1
export BOOTNODE=enode://b99c248be2ed40822a0d74976deeca49c63b7359966be549fbd8ccb3104909f988f3307df606344c384d9e873a48dfbca44aeb685acf9f34a5602bf36845da3a@192.168.0.160:30310
alias bash-import="source ~/.bash_profile"


export GCLOUD=~/google-cloud-sdk
export PATH=$PATH:$GCLOUD/bin

function bootnode-run { nohup bootnode -nodekey boot.key -verbosity 9 -addr :30310 >> ~/bootnode.log & }

alias bootnode-genkey='bootnode -genkey boot.key'
alias bootnode-address='bootnode -nodekey boot.key -verbosity 9 -addr :30310 -writeaddress'
alias bootnode-log="tail -f ~/bootnode.log"

alias brth-kill="ps -ef | grep geth | grep grep -v | awk '{print \$2}' | xargs -i  kill -2 {}"
alias brth-init='cp ~/genesis.json ~/testnet/genesis.json;nohup geth --datadir=~/testnet --nodiscover --cache=2048 init ~/testnet/genesis.json >> ~/geth.log &'

alias brth-console='geth --datadir=~/testnet --nodiscover console'
alias brth-attach='geth --datadir=~/testnet --nodiscover attach'
alias brth-remove-db='geth --datadir=~/testnet removedb'
alias brth-log='tail -f ~/geth.log'
alias netstat-listen='sudo lsof -i -P | grep -i "listen"'


# for golang debuging
ulimit -c unlimited

function brth-remove-data {
	local target="$HOME/testnet"
	if [[ ! -d "$target" ]]; then
		echo "$target was not existing..."
		return
	fi
	cd "$target"
	ls | grep -v genesis.json | grep -v keystore | xargs -i rm -rf {}
	cd
}


function brth-create-account {
    local datadir="testnet"
    local passwd="jongyoungcha"
    local passwdfile="eth-passwd"
    local accountsfile="eth-accounts"
	
    output=`which geth`
    if [[ "$output" == "" ]];then
        echo not found "$output"
        return 1
    else
        echo Found "$output"
    fi
	
	if [ ! -f "$passwdfile" ]; then
        touch ~/"$passwdfile"
        echo "$passwd" >> ~/"$passwdfile"
	fi
	
    if [ -f "$accountsfile" ]; then
        echo "Initializing the accounts file..."
        rm ~/"$accountsfile"
        touch ~/"$accountsfile"
    fi
	if [ ! -d "$datadir" ]; then
        mkdir ~/"$datadir" > /dev/null
	fi
	
    geth --datadir ~/"$datadir" account new --password ~/"$passwdfile"
	sleep 1
}


function brth-remove-accounts {
	local target="$HOME/testnet/keystore"
	
	if [[ -d "$target" ]]; then
		rm -rf "$target"
	else
		echo "The accounts directory was not existing...(dir path : $target)"
	fi

	return
}


function brth-init-poa {
	brth-kill
    sleep 1
    brth-remove-data
	cp ~/genesis-poa.json ~/testnet/genesis.json
	nohup geth --datadir=~/testnet --nodiscover --cache=2048 init ~/testnet/genesis.json >> ~/geth.log &
}


function brth-run { 
	nohup geth --datadir=~/testnet --bootnodes "$BOOTNODE" --syncmode "full" --cache=2048 >> ~/geth.log &
}


function goto-berith {
    cd $GOPATH/src/bitbucket.org/ibizsoftware/berith-chain
}


function brth-init-run {
    brth-kill
    sleep 1
	mkdir -p "~/testnet"
    brth-remove-data
    sleep 1
    brth-init
    sleep 1
    brth-run
}


function brth-init-run-poa {
    brth-kill
    sleep 1
	mkdir -p "~/testnet"
    brth-remove-data
    sleep 1
    brth-init-poa
    sleep 1
    brth-run
}


function pull-berith-env {
	git pull
}


function jong-set-homeenv-as-mine {
	cd
	git init
	git remote add https://github.com/jongyoungcha/Dictionary.git
	git fetch
	git checkout -t origin/master -f

	return
}


function brth-pull-as-master {
	
	echo "$FUNCNAME[*]()"
	
	if [[ -z "$GO_IBIZ_PATH" ]]; then
		echo "\$GO_IBIZ_PATH was not existing..."
		return
	fi

	mkdir -p "$GO_IBIZ_PATH"
	
	cd "$GO_IBIZ_PATH"
	
	echo "Removing Berith previous berith : $GO_BERITH_PATH"
	rm -rf "$GO_BERITH_PATH"
	git clone https://ycjo@bitbucket.org/ibizsoftware/berith-chain.git
	
	return
}

function brth-pull-as-ycjo {
	
	echo "$FUNCNAME[*]()"
	
	if [[ -z "$GO_IBIZ_PATH" ]]; then
		echo "\$GO_IBIZ_PATH was not existing..."
		return
	fi
	
	mkdir -p "$GO_IBIZ_PATH"

	cd "$GO_IBIZ_PATH"
	
	echo "Removing Berith previous berith : $GO_BERITH_PATH"
	rm -rf "$GO_BERITH_PATH"
	git clone https://ycjo@bitbucket.org/ycjo/berith-chain.git
	
	return
}


function brth-pull-replace-master-as-ycjo {
	
	echo "$FUNCNAME[*]()"
	
	if [[ -z "$GO_IBIZ_PATH" ]]; then
		echo "\$GO_IBIZ_PATH was not existing..."
		return
	fi
	
	brth-pull-as-master
	cd "berith-chain"
	git remote set-url origin https://ycjo@bitbucket.org/ycjo/berith-chain.git
	git push -f

	return
}


function brth-build-install {
	if [[ -z "$GO_BERITH_PATH" ]]; then
		echo "\$GO_BERITH_PATH was not existing..."
		return
	fi

	cd "$GO_BERITH_PATH"/cmd/geth
	go build
	go install
	cd
	
	return
}


