#!/bin/bash

# git 설치
function jong-init-common-bins {
	# git
	apt-get install -y git

	# silver searcher
	cd
	apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
	git clone https://github.com/ggreer/the_silver_searcher.git
	cd the_silver_searcher
	./build.sh
	make install
}

# autotool 설치
function jong-init-c-bins {
	apt-get install -y build-essential
	apt-get install -y automake
	apt-get install -y autotools-devel
	apt-get install -y cmake
	apt-get install -y clang
	apt-get install -y llvm

	# rtags install
	cd
	git clone --recursive https://github.com/Andersbakken/rtags.git
	cd rtags	

	git submodule init
	git submodule update
	
	cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
	make
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
	apt-get install -y libgtk-3-dev;
	apt-get install -y libxpm-dev;
	apt-get install -y gnutls-dev;
	apt-get install -y libncurses5-dev;
	apt-get install -y libx11-dev;
	apt-get install -y libxpm-dev;
	apt-get install -y libjpeg-dev;
	apt-get install -y libpng-dev;
	apt-get install -y libgif-dev;
	apt-get install -y libtiff-dev;
	apt-get install -y libgtk2.0-dev;

	cd ./emacs-26.1
	./configure
	make install

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











