#!/bin/bash



export OS_TYPE
export INST_CMD


function jong-check-os-system {
	OS_TYPE=`awk -F= '/^NAME/{print $2}' /etc/os-release`
	# echo $OS_TYPE
	if [ "$OS_TYPE" = \""Ubuntu"\" ]; then
		INST_CMD="apt-get"
		echo "$INST_CMD"
	else
		INST_CMD="sudo yum"
		echo "$INST_CMD"
	fi
}
jong-check-os-system


# git 설치
function jong-init-common-bins {
	# git
	sudo "$INST_CMD" install -y git

	# silver searcher
	cd
	sudo "$INST_CMD" install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
	git clone https://github.com/ggreer/the_silver_searcher.git
	cd the_silver_searcher
	./build.sh
	sudo make install
}

# autotool 설치
function jong-init-c-bins {
	sudo "$INST_CMD" install -y build-essential
	sudo "$INST_CMD" install -y automake
	sudo "$INST_CMD" install -y autotools-dev
	sudo "$INST_CMD" install -y cmake
	sudo "$INST_CMD" install -y clang
	sudo "$INST_CMD" install -y llvm
	sudo "$INST_CMD" install -y libclang-dev

	# rtags install
	cd
	git clone --recursive https://github.com/Andersbakken/rtags.git
	cd rtags	

	git submodule init
	git submodule update
	
	cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
	make
	sudo make install
}

# go 설치
function jong-init-golang-bins {
	cd
	wget https://dl.google.com/go/go1.11.5.linux-amd64.tar.gz
	tar -xvf go1.11.5.linux-amd64.tar.gz
	echo "export GOROOT=~/go" >> ~/.bash_profile
	echo "export GOPATH=~/goworks-berith" >> ~/.bash_profile
	echo "export PATH=\$PATH:\$GOROOT/bin" >> ~/.bash_profile
	echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bash_profile

	# dlv
	source ~/.bash_profile
	go get -u github.com/go-delve/delve/cmd/dlv
}



function jong-init-berith {
	# berith 설치
	cd
	source .bash_profile
	TARGET_PATH=$GOPATH/src/bitbucket.org/ibizsoftware
	mkdir -p "$TARGET_PATH"
	cd "$TARGET_PATH"
	git clone https://ycjo@bitbucket.org/ibizsoftware/berith-chain.git
}


function jong-init-emacs {
	cd
	wget http://ftp.kaist.ac.kr/gnu/emacs/emacs-26.1.tar.gz
	tar -xvf emacs-26.1.tar.gz
	sudo "$INST_CMD" install -y libgtk-3-dev;
	sudo "$INST_CMD" install -y libxpm-dev;
	sudo "$INST_CMD" install -y gnutls-dev;
	sudo "$INST_CMD" install -y libncurses5-dev;
	sudo "$INST_CMD" install -y libx11-dev;
	sudo "$INST_CMD" install -y libxpm-dev;
	sudo "$INST_CMD" install -y libjpeg-dev;
	sudo "$INST_CMD" install -y libpng-dev;
	sudo "$INST_CMD" install -y libgif-dev;
	sudo "$INST_CMD" install -y libtiff-dev;
	sudo "$INST_CMD" install -y libgtk2.0-dev;

	cd ./emacs-26.1
	./configure
	sudo make install

	cd
	git clone https://github.com/jongyoungcha/.emacs.d.git
}


function jong-init-all-kinds-things {
	jong-init-common-bins
	jong-init-c-bins
	jong-init-golang-bins
	jong-init-berith
	jong-init-emacs
}


function jong-set-rtags-wrapper {
	mkdir -p ~/.local/bin
	cd ~/.local/bin
	for c in cc c++ gcc g++; do
		if [ ! -z `which gcc-rtags-wrapper.sh` ]; then
			ln -s `which gcc-rtags-wrapper.sh` "$c"
		else
			echo "Coulnt find gcc-rtags-wrapper.sh"
		fi
	done
}











