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
			INST_CMD="yum"
			echo "$INST_CMD"
	 fi
}
jong-check-os-system





# git 설치
function jong-init-common-bins {
	 # git
	 sudo "$INST_CMD" install -y git

	 if [ "$OS_TYPE"="CentOS Linux" ]; then
			sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm
			sudo yum install -y git2u-all
	 fi

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


	 if [ ! -d "$HOME/.local" ]; then
		mkdir -p "$HOME/.local"
	 fi

	 # ccls install
	 cd
	 git clone --depth=1 --recursive https://github.com/MaskRay/ccls
	 cd ccls
	 cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/usr/local/bin/
	 cmake --build Release
}


function jong-install-llvm {
	 local llvm_version="llvmorg-8.0.0-rc5"
	 local target_path="$HOME/.local"

	 if [ ! -d "$target_path" ]; then
			mkdir -p "$target_path"
	 fi

	 cd
	 git clone https://github.com/llvm/llvm-project.git
	 cd llvm-project
	 git fetch && git checkout llvm_version

	 mkdir build-llvm
	 mkdir build-clang

	 cd build-llvm
	 cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS=clang -G "Unix Makefiles" ../llvm
	 make -j4
	 make prefix="$target_path" install


	 cd ../build-llvm
	 cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS=clang -G "Unix Makefiles" ../clang
	 make -j4
	 make prefix="$target_path" install
}



function jong-install-bear {
		if [ ! -d "$HOME/.local" ]; then
				mkdir -p "$HOME/.local"
		fi

		# install Bear
		cd
		git clone https://github.com/rizsotto/Bear.git
		cd Bear
		cmake -DCMAKE_PREFIX_PATH="$HOME/.local/bin" .
		sudo make install
}


# go 설치
function jong-init-golang-bins {
	 cd
	 wget https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz
	 tar -xvf go1.11.5.linux-amd64.tar.gz
	 echo "export GOROOT=~/go" >> ~/.bash_profile
	 echo "export GOPATH=~/goworks-berith" >> ~/.bash_profile
	 echo "export PATH=\$PATH:\$GOROOT/bin" >> ~/.bash_profile
	 echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bash_profile

	 # dlv
	 source ~/.bash_profile
	 go get -u github.com/go-delve/delve/cmd/dlv
}


function jong-init-java-bins {
	cd
	wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/13+33/5b8a42f3905b406298b72d750b6919f6/jdk-13_linux-x64_bin.tar.gz
	tar -xvf jdk-13_linux-x64_bin.tar.gz
	export JAVA_HOME=$HOME/jdk-13
	export PATH=$JAVA_HOME/bin:$PATH

}


function jong-init-scala-bins {
	cd
	wget https://downloads.lightbend.com/scala/2.13.1/scala-2.13.1.tgz
	tar -xvf scala-2.13.1.tgz
	echo 'export SCALA_HOME="$HOME/scala-2.13.1"' >> ~/.bash_profile
	echo 'export PATH=$SCALA_HOME/bin:$PATH' >> ~/.bash_profile
	source ~/.bash_profile

	cd
	wget https://piccolo.link/sbt-1.3.3.tgz
	tar -xvf sbt-1.3.3.tgz
	sudo cp -Rf sbt/bin/* /usr/local/bin/
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


function jong-init-boost-lib {
		local boost_version="boost-1.68.0"
		local target_dir="/usr/local/"
		cd "$HOME/.local" &&
				git clone https://github.com/boostorg/boost.git &&
			 cd boost &&
				git checkout "$boost_version" &&
				git submodule init &&
				git submodule update &&
				./bootstrap.sh --prefix="$target_dir" &&
				sudo ./b2 install;
}
