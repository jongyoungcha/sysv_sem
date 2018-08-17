#!/bin/bash

# variables to initialized (relative with the master node)
export MASTER_NAME="eosio"
export MASTER_HOST="0.0.0.0"
export MASTER_NODEOS_PORT=8888
export MASTER_P2P_LISTEN_PORT=9876

# variables relative with slave nodes...
export SLAVE_NAME="slave.node"
export SLAVE_HOST="0.0.0.0"
export SLAVE_NODEOS_PORT=8888
export SLAVE_P2P_LISTEN_PORT=9876
export SLAVE_P2P_PEER_PORT=9876

alias cleos-master=\
'docker exec -it eosio /opt/eosio/bin/cleos \
-u http://$MASTER_HOST:$MASTER_NODEOS_PORT \
--wallet-url http://$MASTER_HOST:$MASTER_NODEOS_PORT'

alias cleos-slave=\
'docker exec -it eosio /opt/eosio/bin/cleos \
-u http://$SLAVE_HOST:$SLAVE_NODEOS_PORT \
--wallet-url http://$SLAVE_HOST:$SLAVE_NODEOS_PORT'

alias nodeos='docker exec -it eosio nodeos'

# Initialize eos environment variables
eos-initialize-master () {
    echo ">>>> Calling $FUNCNAME ()"
    
    read -p "** Master name [default:eosio] : " MASTER_NAME
    if [[ $MASTER_NAME == "" ]]; then MASTER_NAME="eosio"; fi
    
    read -p "** Master node host [default:0.0.0.0] : " MASTER_HOST
	if [[ "$MASTER_HOST" == "" ]]; then MASTER_HOST="0.0.0.0"; fi
    if ! [[ $MASTER_HOST =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		echo "Master host was invalid..."
		return -1
	fi
    
    read -p "** Master nodeos post [default:8888] : " MASTER_NODEOS_PORT
    if [[ $MASTER_NODEOS_PORT == "" ]]; then MASTER_NODEOS_PORT=8888; fi
    if ! [[ $MASTER_NODEOS_PORT =~ ^[0-9]+$ ]]; then
		echo "The number was not integer..."
		return -1
	fi

    read -p "** Master p2p listen port [default:9876] : " MASTER_P2P_LISTEN_PORT
    if [[ $MASTER_P2P_LISTEN_PORT == "" ]]; then MASTER_P2P_LISTEN_PORT=9876; fi
    if ! [[ $MASTER_P2P_LISTEN_PORT =~ ^[0-9]+$ ]]; then
		echo "The number was not integer..."
		return -1
	fi

    echo ""
    echo ">>>> Initializing job was completed !!!"
    echo "** MASTER_NAME : $MASTER_NAME"
    echo "** MASTER_HOST : $MASTER_HOST"
    echo "** MASTER_NODEOS_PORT : $MASTER_NODEOS_PORT"
    echo "** MASTER_P2P_LISTEN_PORT : $MASTER_P2P_LISTEN_PORT"
    echo ""
    
    return 0
}

eos-initialize-slave () {
    echo ">>>> Calling $FUNCNAME ()"

    read -p "** Slave name [default:slave.node] : " SLAVE_NAME
    if [[ $SLAVE_NAME == "" ]]; then SLAVE_NAME="slave.node"; fi
    
    read -p "** Slave node host [default:0.0.0.0] : " SLAVE_HOST
	if [[ $SLAVE_HOST == "" ]]; then SLAVE_HOST="0.0.0.0"; fi
    if ! [[ $SLAVE_HOST =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		echo "Slave host was invalid..."
		return 1
	fi
    
    read -p "** Slave http port [default:8888] : " SLAVE_NODEOS_PORT
    if [[ $SLAVE_NODEOS_PORT == "" ]]; then SLAVE_NODEOS_PORT=8888; fi
    if ! [[ $SLAVE_NODEOS_PORT =~ ^[0-9]+$ ]]; then
		echo "The number was not integer..."
		return 1
	fi

    read -p "** Slave p2p listen port [default:9876] : " SLAVE_P2P_LISTEN_PORT
    if [[ $SLAVE_P2P_LISTEN_PORT == "" ]]; then SLAVE_P2P_LISTEN_PORT=9876; fi
    if ! [[ $SLAVE_P2P_LISTEN_PORT =~ ^[0-9]+$ ]]; then
		echo "The number was not integer..."
		return 1
	fi

    read -p "** Master node host (Used to connect master) [not existing default] : " MASTER_HOST
    if ! [[ "$MASTER_HOST" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		echo "Master host was invalid..."
		return 1
	fi
    if [[ $MASTER_HOST == "127.0.0.1" ]]; then
        echo "The Master node host can't be localhost(127.0.0.1)..."; echo
        return 1
    fi
    if [[ $MASTER_HOST == $SLAVE_HOST ]]; then
        echo "The Master node host can't equal with the slave host..."; echo
        return 1
    fi
    read -p "** Slave p2p peer port (P2P listen port of master) [default:9876] : " SLAVE_P2P_PEER_PORT
    if [[ $SLAVE_P2P_PEER_PORT == "" ]]; then SLAVE_P2P_PEER_PORT=9876; fi
    if ! [[ $SLAVE_P2P_PEER_PORT =~ ^[0-9]+$ ]]; then
		echo "The number was not integer..."
		return 1
	fi

    echo ""
    echo ">>>> Initializing job was completed !!!"
    echo "** SLAVE_HOST : $SLAVE_HOST"
    echo "** SLAVE_NODEOS_PORT : $SLAVE_NODEOS_PORT"
    echo "** SLAVE_P2P_LISTEN_PORT : $SLAVE_P2P_LISTEN_PORT"
    echo "** MASTER_HOST : $MASTER_HOST"
    echo "** SLAVE_P2P_PEER_PORT (Master listening) : $SLAVE_P2P_PEER_PORT"
    echo ""

    return 0
}

# Connect the eosio docker
eos-connect () {
	docker run -it eosio/eos-dev /bin/bash
}

# Start the first producer node
eos-start-master-eosio () {
	echo ">>>> Calling $FUNCNAME ()"

    local ret=0
	local CMD=""
    
    #Initialize attributes of the master
    eos-initialize-master; ret=$?
    
    if [[ $ret == 1 ]]; then
        echo "Initailizing master was failed..."; echo
        return 1;
    fi

    echo ""
    echo ">>>> Trying to make a master node..."
    echo ""

read -d '' CMD << EOF
	docker run --rm --name eosio -d
	-p $MASTER_NODEOS_PORT:$MASTER_NODEOS_PORT
	-p $MASTER_P2P_LISTEN_PORT:$MASTER_P2P_LISTEN_PORT
	-v /tmp/work:/work
	-v /tmp/eosio/data:/mnt/dev/data
	-v /tmp/eosio/config:/mnt/dev/config
	eosio/eos-dev /bin/bash -c
	"nodeos -e -p eosio
	--plugin eosio::wallet_api_plugin
	--plugin eosio::wallet_plugin
	--plugin eosio::producer_plugin
	--plugin eosio::history_plugin
	--plugin eosio::chain_api_plugin
	--plugin eosio::history_api_plugin
	--plugin eosio::http_plugin
	-d /mnt/dev/data
	--config-dir /mnt/dev/config
	--http-server-address=$MASTER_HOST:$MASTER_NODEOS_PORT
	--p2p-listen-endpoint=$MASTER_HOST:$MASTER_P2P_LISTEN_PORT    
	--access-control-allow-origin=*
	--contracts-console
	--http-validate-host=false
    --delete-all-blocks"
EOF
    
	echo '** Conducting command :'
	echo $CMD; echo

	eval $CMD
}


# Start the other producer node
eos-start-slave-eosio () {
	echo ">>>> Calling $FUNCNAME ()"

    # Initialize attributes of the slave
    local ret=0
    local CMD=""
    
    eos-initialize-slave; ret=$?
    if [[ $ret == 1 ]]; then
        echo "Initailizing slave was failed..."; echo
        return 1;
    fi
    
	sleep 1
read -d '' CMD << EOF
	docker run --rm --name eosio 
	-p $SLAVE_NODEOS_PORT:$SLAVE_NODEOS_PORT
	-p $SLAVE_P2P_LISTEN_PORT:$SLAVE_P2P_LISTEN_PORT
	-v /tmp/work:/work
	-v /tmp/eosio/data:/mnt/dev/data
	-v /tmp/eosio/config:/mnt/dev/config
	eosio/eos-dev /bin/bash -c
	"nodeos -e -p $SLAVE_NAME
	--plugin eosio::wallet_api_plugin
	--plugin eosio::wallet_plugin
	--plugin eosio::producer_plugin
	--plugin eosio::history_plugin
	--plugin eosio::chain_api_plugin
	--plugin eosio::history_api_plugin
	--plugin eosio::http_plugin
	-d /mnt/dev/data 
	--config-dir /mnt/dev/config
	--http-server-address=0.0.0.0:$SLAVE_NODEOS_PORT
	--p2p-listen-endpoint=0.0.0.0:$SLAVE_P2P_LISTEN_PORT
	--p2p-peer-address=$MASTER_HOST:$SLAVE_P2P_PEER_PORT
	--access-control-allow-origin=*
	--contracts-console
	--http-validate-host=false"
EOF
	echo '>>>> Conducting command :'
	echo $CMD; echo
	eval $CMD
    
    return 0
}

# Stop the eosio container
eos-stop-eosio () {
	echo ">>>> Calling $FUNCNAME ()"
	docker stop eosio

    return 0
}

# Show logs from the eosio docker container
eos-eosio-logs () {
	echo ">>>> Calling $FUNCNAME ()"
	docker logs -f eosio

    return 0
}

# Create the default wallet
eos-create-default-wallet () {
    echo ">>>> Calling $FUNCNAME ()"
    cleos-master wallet create

    return 0
}

