if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if [ -f ~/jong-base.sh ]; then
	. ~/jong-base.sh
fi

export GOROOT=~/go
export GOPATH=~/goworks-berith
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin
export GO_IBIZ_PATH=$GOPATH/src/bitbucket.org/ibizsoftware
export GO_BERITH_PATH=$GO_IBIZ_PATH/berith-chain


export BOOTNODE=enode://637a54e3de83e4978efbaad91745dbee1fc60ff7c1608fddca3f23ce2d8c2878ae10a05f0f768b78dd46ca723449ae6cb34e76b7639d0cc2b6c0bea805f32527@192.168.0.160:30310
alias bash-import="source ~/.bash_profile"

function bootnode-run { nohup bootnode -nodekey boot.key -verbosity 9 -addr :30310 >> ~/bootnode.log & }

alias bootnode-address='bootnode -nodekey boot.key -verbosity 9 -addr :30310 -writeaddress'
alias bootnode-log="tail -f ~/bootnode.log"

alias brth-kill="ps -ef | grep geth | grep grep -v | awk '{print \$2}' | xargs -i  kill -2 {}"
alias brth-init='cp ~/genesis.json ~/testnet/genesis.json;nohup geth --datadir=~/testnet --nodiscover --cache=2048 init ~/testnet/genesis.json >> ~/geth.log &'

alias brth-console='geth --datadir=~/testnet --nodiscover console'
alias brth-attach='geth --datadir=~/testnet --nodiscover attach'
alias brth-remove-db='geth --datadir=~/testnet removedb'
alias brth-log='tail -f ~/geth.log'
alias brth-remove-data='cd ~/testnet;ls | grep -v genesis.json | grep -v keystore | xargs -i rm -rf {}'

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



export GOROOT=~/go
export GOPATH=~/goworks-berith
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin
