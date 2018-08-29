#!/bin/bash

export DOCKER_IMAGE="eosio/eos-dev:v1.1.4"
export NODE_HOST=""

# variables to initialized (relative with the master node)
export MASTER_NAME="eosio"
export MASTER_HOST="0.0.0.0"
export MASTER_NODEOS_PORT=8888
export MASTER_P2P_LISTEN_PORT=9876

# variables relative with slave nodes...
export SLAVE_NAME="bp1"
export SLAVE_PUB=""
export SLAVE_PRIV=""
export SLAVE_HOST="0.0.0.0"
export SLAVE_NODEOS_PORT=8888
export SLAVE_P2P_LISTEN_PORT=9876
export SLAVE_P2P_PEER_PORT=9876

alias cleos=\
'docker exec -it eosio /opt/eosio/bin/cleos \
-u http://$MASTER_HOST:$MASTER_NODEOS_PORT \
--wallet-url http://$MASTER_HOST:$MASTER_NODEOS_PORT'

# accounts imformation
export ACC_EOSIO="eosio"
export PUB_EOSIO="EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV"
export PRI_EOSIO="5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"

export ACC_EOSIO_TOKEN="eosio.token"
export PUB_EOSIO_TOKEN="EOS64AedSqepyBJBj6m9m6zEsqnPaWi4nFCy2V2xnKnJWoCnoMzYF"
export PRI_EOSIO_TOKEN="5JAoRq8Jx5Kb9z9F5RCWQpDoETbcufwioAz8mwxfKEUkW6aJDjp"

export ACC_BP1="bp1"
export PUB_BP1="EOS5pns4NFSnNwskU44P1RcrFWF2t6o6GNJ2uAH7tCbz1rjciGNmQ"
export PRI_BP1="5HyMapbcZpwFXPbDCBk5J7816eafhzWjNNAyKUYYYFiBaAzpysv"

export ACC_BP2="bp2"
export PUB_BP2="EOS52qg8jo6Tk8Xq6tq9U7gQPXPHzE229ypp9tkhbWYC5U72TsVux"
export PRI_BP2="5JPAJkrCDqXSdT3mwRE87iLkNC5zMpkwbJ1Lg6NEcqEkYoaP6t8"

export ACC_BP3="bp3"
export PUB_BP3="EOS6wyqE8gojDBbWd4fm8TATr3Ft68QYidGKkX3C3Hw6zv8ahL35L"
export PRI_BP3="5JAPmgtGJVR7biXaoKSZoJDGweDBHD1mAnc4mYxHZiWtuCGJCgE"

export ACC_BP4="bp4"
export PUB_BP4="EOS6dSsVXKBuwhjC1WAMkFcgKx6YNnANPfKKqWQHL6nJw67ecm5XC"
export PRI_BP4="5JjamLeaTARoa47WEbH6X6Y2y4e9kAevALFuvmUrBWdALrntjPs"

export ACC_VOTER1="voter1"
export PUB_VOTER1="EOS6CQxfXULbevrfMBuhD2rw1C3AJkr6w4JdGqKTB3jdzmWr6y9wf"
export PRI_VOTER1="5J9wujfcT6WYxVgkV7JhUnuo8KpRj5huKQWR79iuwb22xizu92Q"

export ACC_VOTER2="voter2"
export PUB_VOTER2="EOS7aDyhQ3GVP8vdyicD8AANjF7GWN4PMHLsrLSQi6GoHj5iY36Ev"
export PRI_VOTER2="5J5LD8wMcKL4BPCfKCgq6Fu2jokkobtYubDMGfEE2pJ1QiL2e49"

export ACC_VOTER3="voter3"
export PUB_VOTER3="EOS7Xr1rNyhpokcTAsKuVyHjKoNtUiCExrZ8aHkLQkNQZbds87vrB"
export PRI_VOTER3="5KV7fj7LPma7TTG4eyCXWm3SKvMvLUw8NCJE9yp8pcDq2Cymhg5"

export ACC_IBIZ="ibiz"
export PUB_IBIZ="EOS6Luy39ZpqPpNnQiXY3YFiJhHkvs1zFpo92J7J51TcNXdt1BTzy"
export PRI_IBIZ="5HxLz1W2NQPFzwaXuzw2Q4D3DHHJyBApeAWV5M3mEM8jfPAuyFM"

export ACC_SYKIM="sykim"
export PUB_SYKIM="EOS6nEPZaFJ2qBYnUxMfMmZYFC1MAxy1XcN5oXoaeFhJePAvt7YUM"
export PRI_SYKIM="5Jz5TJsoFdchjUBcW2C6oWM1Ksd5GvTfupkYoRPQptYwJhK7Vzv"

# accounts imformation
eos-init-bp-step1 () {
    echo ">>>> Calling $FUNCNAME ()"

    cleos wallet create | tail -1 | sed -e 's/"//g' > wallet_pwd.log
    local cmd

    echo '>>>> importing public keys...'
    cleos wallet import --private-key=$PRI_EOSIO
    cleos wallet import --private-key=$PRI_EOSIO_TOKEN
    cleos wallet import --private-key=$PRI_BP1
    cleos wallet import --private-key=$PRI_BP2
    cleos wallet import --private-key=$PRI_BP3
    cleos wallet import --private-key=$PRI_BP4
    cleos wallet import --private-key=$PRI_VOTER1
    cleos wallet import --private-key=$PRI_VOTER2
    cleos wallet import --private-key=$PRI_VOTER3
    cleos wallet import --private-key=$PRI_IBIZ
    cleos wallet import --private-key=$PRI_SYKIM

    echo ">>>> creating essential accounts (eosio.bpay, eosio.msig, eosio.names, eosio.ram...)"
    cleos create account eosio eosio.bpay $PUB_EOSIO_TOKEN $PUB_EOSIO_TOKEN
    cleos create account eosio eosio.msig $PUB_EOSIO_TOKEN $PUB_EOSIO_TOKEN
    cleos create account eosio eosio.names $PUB_EOSIO_TOKEN $PUB_EOSIO_TOKEN
    cleos create account eosio eosio.ram $PUB_EOSIO_TOKEN $PUB_EOSIO_TOKEN
    cleos create account eosio eosio.ramfee $PUB_EOSIO_TOKEN $PUB_EOSIO_TOKEN
    cleos create account eosio eosio.saving $PUB_EOSIO_TOKEN $PUB_EOSIO_TOKEN
    cleos create account eosio eosio.stake $PUB_EOSIO_TOKEN $PUB_EOSIO_TOKEN
    cleos create account eosio eosio.token  $PUB_EOSIO_TOKEN $PUB_EOSIO_TOKEN
    cleos create account eosio eosio.vpay  $PUB_EOSIO_TOKEN $PUB_EOSIO_TOKEN
    cleos create account eosio eosio.sudo  $PUB_EOSIO_TOKEN $PUB_EOSIO_TOKEN

    echo ">>>> loading smart contracts..."
    cleos set contract eosio /contracts/eosio.bios
    cleos set contract eosio.token /contracts/eosio.token
    cleos set contract eosio.msig /contracts/eosio.msig
    cleos set contract eosio.sudo /contracts/eosio.sudo

    echo ">>>> creating accounts for transfer..."
    cleos create account eosio ibiz $PUB_IBIZ $PUB_IBIZ
    cleos create account eosio sykim $PUB_SYKIM $PUB_SYKIM

    echo ">>>> creating 'SYS' token and issuing..."
    cleos push action eosio.token create '{"issuer":"eosio", "maximum_supply": "1000000000.0000 SYS", "can_freeze": 0, "can_recall": 0, "can_whitelist": 0}' -p eosio.token
    cleos push action eosio.token issue '{"to":"eosio","quantity":"1000000000.0000 SYS","memo":"issue"}' -p eosio

    echo ">>>> loading eosio.system smart contracts...(after loaded, u cant make any other accounts..)"
    cleos set contract eosio /contracts/eosio.system

    echo ">>>> checking SYS token status..."
    cleos get currency balance eosio.token eosio
    cleos get currency stats eosio.token 'SYS'

    echo ">>>> creating BP accounts..."
    cleos system newaccount eosio $ACC_BP1 $PUB_BP1 $PUB_BP1 --buy-ram '1000000.0000 SYS' \
          --stake-net '1000000.0000 SYS' --stake-cpu '1000000.0000 SYS'
    cleos system newaccount eosio $ACC_BP2 $PUB_BP2 $PUB_BP2 --buy-ram '1000000.0000 SYS' \
          --stake-net '1000000.0000 SYS' --stake-cpu '1000000.0000 SYS'
    cleos system newaccount eosio $ACC_BP3 $PUB_BP3 $PUB_BP3 --buy-ram '1000000.0000 SYS' \
          --stake-net '1000000.0000 SYS' --stake-cpu '1000000.0000 SYS'
    cleos system newaccount eosio $ACC_BP4 $PUB_BP4 $PUB_BP4 --buy-ram '1000000.0000 SYS' \
          --stake-net '1000000.0000 SYS' --stake-cpu '1000000.0000 SYS'
    
    echo ">>>> registering block producers..."
    cleos system regproducer $ACC_BP1 $PUB_BP1
    cleos system regproducer $ACC_BP2 $PUB_BP2
    cleos system regproducer $ACC_BP3 $PUB_BP3
    cleos system regproducer $ACC_BP4 $PUB_BP4

    cleos system listproducers
}


eos-init-bp-step2 () {
    echo ">>>> creating voter accounts..."
    cleos system newaccount eosio $ACC_VOTER1 $PUB_VOTER1 $PUB_VOTER1 --buy-ram '50.0000 SYS' \
          --stake-net '50.0000 SYS' --stake-cpu '50.0000 SYS'
    cleos system newaccount eosio $ACC_VOTER2 $PUB_VOTER2 $PUB_VOTER2 --buy-ram '50.0000 SYS' \
          --stake-net '50.0000 SYS' --stake-cpu '50.0000 SYS'
    cleos system newaccount eosio $ACC_VOTER3 $PUB_VOTER3 $PUB_VOTER3 --buy-ram '50.0000 SYS' \
          --stake-net '50.0000 SYS' --stake-cpu '50.0000 SYS'

    echo ">>>> issuing SYS token..."
    cmd="cleos push action eosio.token transfer '[\"eosio\",\"$ACC_VOTER1\",\"100000000.0000 SYS\",\"vote\"]' -p eosio"
    echo ">>>> $cmd"
    eval $cmd
    
    cmd="cleos push action eosio.token transfer '[\"eosio\",\"$ACC_VOTER2\",\"100000000.0000 SYS\",\"vote\"]' -p eosio"; echo ">>>> $cmd"
    eval $cmd

    cmd="cleos push action eosio.token transfer '[\"eosio\",\"$ACC_VOTER3\",\"100000000.0000 SYS\",\"vote\"]' -p eosio"; echo ">>>> $cmd"
    eval $cmd

    echo ">>>> check the balance and stats of voters..."
    cleos get currency balance eosio.token $ACC_VOTER1
    cleos get currency balance eosio.token $ACC_VOTER2
    cleos get currency balance eosio.token $ACC_VOTER3

    echo ">>> delegating band width by self..."
    cleos system delegatebw $ACC_VOTER1 $ACC_VOTER1 "50000000.0000 SYS" "50000000.0000 SYS"
    cleos system delegatebw $ACC_VOTER2 $ACC_VOTER2 "50000000.0000 SYS" "50000000.0000 SYS"
    cleos system delegatebw $ACC_VOTER3 $ACC_VOTER3 "50000000.0000 SYS" "50000000.0000 SYS"

    echo ">>>> voting..."
    cleos system voteproducer prods $ACC_VOTER1 $ACC_BP1 $ACC_BP2 $ACC_BP3 $ACC_BP4
    cleos system voteproducer prods $ACC_VOTER2 $ACC_BP1 $ACC_BP2 $ACC_BP3 $ACC_BP4
    cleos system voteproducer prods $ACC_VOTER3 $ACC_BP1 $ACC_BP2 $ACC_BP3 $ACC_BP4

    echo ">>>> check votes..."
    cleos system listproducers
    cleos get table eosio eosio voters
}


eos-create-token () {
    local CMD
    local OWNER
    local TOKEN
    local MAX

    read -p "** A token name [default:SYS] : " TOKEN
    if [[ $TOKEN == "" ]]; then TOKEN="SYS"; fi

    read -p "** A owner [owner:eosio] : " OWNER
    if [[ $OWNER == "" ]]; then OWNER="eosio"; fi

    read -p "** A maximum count of the token [1000000000.0000] : " MAX
    if [[ $MAX == "" ]]; then MAX=1000000000.0000; fi
    if ! [[ $MAX =~ ^[0-9]+.[0-9]+$ ]]; then
        echo "maximum was not double..."
        return 1
    fi

    CMD="cleos push action eosio.token create '[\"$OWNER\", \"$MAX $TOKEN\"]' -p eosio.token@active"
    echo ">>>> $CMD"
    eval $CMD
}

eos-issue-token () {
    local CMD
    local USER
    local TOKEN
    local QUANTITY
    local COMMENT
    
    read -p "** A user to be given token [default:ibiz] : " USER
    if [[ $USER == "" ]]; then USER="ibiz"; fi

    read -p "** token name [default:SYS] : " TOKEN
    if [[ $TOKEN == "" ]]; then TOKEN="SYS"; fi

    read -p "** A quantity (SYS) [default : 1000.0000] : " QUANTITY
    if [[ $QUANTITY == "" ]]; then QUANTITY=1000.0000; fi
    if ! [[ $QUANTITY =~ ^[0-9]+.[0-9]+$ ]]; then
        echo "quantity was not double..."
        return 1
    fi

    read -p "** A quantity (SYS) [default : memo] : " COMMENT
    if [[ $COMMENT == "" ]]; then COMMENT="memo"; fi

    CMD="cleos push action eosio.token issue '[\"$USER\", \"$QUANTITY $TOKEN\" \"$COMMENT\"]' -p eosio@active"
    echo ">>>> $CMD"
    eval $CMD
}

eos-staking () {
    local CMD
    local FROM
    local TO
    local QUANTITY
    
    read -p "** from name [default:ibiz] : " FROM
    if [[ $FROM == "" ]]; then FROM="ibiz"; fi
    
    read -p "** to name [default:sykim] : " TO
    if [[ $TO == "" ]]; then TO="sykim"; fi
    
    read -p "** quantity (SYS) [default:10] : " QUANTITY
    if [[ $QUANTITY == "" ]]; then QUANTITY=10; fi
    if ! [[ $QUANTITY =~ ^[0-9]+$ ]]; then
        echo "quantity was not integer..."
        return 1
    fi
    
    CMD="cleos system delegatebw --buyram \"$QUANTITY SYS\" $FROM $TO \"$QUANTITY SYS\" \"$QUANTITY SYS\""
    echo ">>>> $CMD"
    eval $CMD
}


# Initialize eos environment variables
eos-init-master () {
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

eos-init-slave () {
    echo ">>>> Calling $FUNCNAME ()"

    read -p "** Slave name [default:bp1] : " SLAVE_NAME
    if [[ $SLAVE_NAME == "" ]]; then SLAVE_NAME="bp1"; fi
    
    read -p "** Public key of BP [not existing default] : " SLAVE_PUB
    if [[ $SLAVE_PUB == "" ]]; then
        echo "The Public key was empty..."
        return 1
    fi

    read -p "** Private key of BP [not existing default] : " SLAVE_PRIV
    if [[ $SLAVE_PRIV == "" ]]; then
        echo "The Private key was empty..."
        return 1
    fi
    
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
	docker run -it $DOCKER_IMAGE /bin/bash
}

# Start the first producer node
eos-start-master-eosio () {
	echo ">>>> Calling $FUNCNAME ()"

    local ret=0
	local CMD=""
    
    #Initialize attributes of the master
    eos-init-master; ret=$?
    
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
	$DOCKER_IMAGE /bin/bash -c
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
	--http-validate-host=false"
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
    
    eos-init-slave; ret=$?
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
	$DOCKER_IMAGE /bin/bash -c
	"nodeos -e -p $SLAVE_NAME
    	--private-key '[ "$SLAVE_PUB", "$SLAVE_PRIV" ]'
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
	--http-validate-host=false
	--delete-all-blocks"
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
    cleos wallet create

    return 0
}

