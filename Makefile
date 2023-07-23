update:
	sudo dnf -y update

add-repositories:
	sudo dnf -y install fedora-workstation-repositories
	sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	sudo dnf -y install dnf-utils
	sudo rpm --import https://raw.githubusercontent.com/UnitedRPMs/unitedrpms/master/URPMS-GPG-PUBLICKEY-Fedora
	sudo dnf -y install https://github.com/UnitedRPMs/unitedrpms/releases/download/20/unitedrpms-$(rpm -E %fedora)-20.fc$(rpm -E %fedora).noarch.rpm

install-basic:
	sudo dnf -y install unrar p7zip p7zip-plugins java git clipgrab chromium gcc vim zsh make curl wget git neofetch docker unrar clang cmake gtk3-devel

git-configure:
	git config --global init.defaultBranch main
	git config --global user.name "diego-garro"
	git config --global user.email "diego.garromolina@yahoo.com"
	git config --global alias.s "status -s -b"
	git config --global alias.lg "log --oneline --all --graph --decorate"

codecs:
	sudo dnf -y install gstreamer1-{libav,plugins-{good,ugly,bad{-free,-nonfree}}} --setopt=strict=0
	sudo dnf -y --allowerasing install xine-lib xine-lib-extras xine-lib-extras-freeworld libdvdread libdvdnav lsdvd libdvbpsi libmatroska xvidcore gstreamer-ffmpeg gstreamer-plugins-ugly
	sudo dnf -y install libdvdread libdvdnav lsdvd libdvdcss

install-go:
	sudo dnf install golang

install-node:
	sudo dnf -y install nodejs

enable-docker:
	sudo systemctl enable docker
	sudo systemctl start docker
	# Enable Docker to run on OpenSUSE without sudo
	sudo groupadd docker
	sudo gpasswd -a $(USER) docker
	newgrp docker

ohmyzsh:
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	echo 'alias python="python3"' >> ~/.zshrc
	echo 'alias py="python3"' >> ~/.zshrc
	echo 'alias c="clear"' >> ~/.zshrc
	echo 'alias C="clear"' >> ~/.zshrc

powerlevel-theme:
	# First install the Meslo Nerd Font
	# https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k
	# If you want to make the font available system-wide, copy the font files to /usr/share/fonts
	# and then run sudo mkfontdir
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
	echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
	exec zsh
	p10k configure

pyenv:
	sudo dnf -y install make gcc patch zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel libuuid-devel gdbm-devel libnsl2-devel
	curl https://pyenv.run | zsh
	echo '# pyenv commands' >> ~/.zshrc
	echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
	echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
	echo 'eval "$(pyenv init -)"' >> ~/.zshrc
	echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
	source ~/.zshrc

poetry:
	curl -sSL https://install.python-poetry.org | python3 -
	exho '# poetry' >> ~/.zshrc
	echo 'export PATH="/home/diego/.local/bin:$PATH"' >> ~/.zshrc
	mkdir /home/diego/.oh-my-zsh/plugins/poetry
	poetry completions zsh > /home/diego/.oh-my-zsh/plugins/poetry/_poetry

py-libs:
	sudo zypper in python3-pip
	sudo pip install numpy pandas matplotlib pipenv ipython jupyter notebook jupyterlab

install-v:
	cd
	git clone https://github.com/vlang/v
	mv v /home/
	cd v
	make
	sudo ln -sf ~/v/v /usr/local/bin/v
	# Download VLS and put it in the v installation directory
	# https://github.com/vlang/vls/releases/tag/latest

install-rust:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

vscode:
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
	dnf check-update
	sudo dnf -y install code

vivaldi:
	sudo dnf config-manager --add-repo https://repo.vivaldi.com/archive/vivaldi-fedora.repo
	sudo dnf install vivaldi-stable

brave:
	sudo dnf install dnf-plugins-core
	sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
	sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
	sudo dnf install brave-browser brave-keyring

games:
	sudo yum -y install abuse alienblaster boswars dd2 enigma foobillard freedoom gweled hedgewars neverball njam openlierox pingus pipenightdreams pokerth pychess scorchwentbonkers seahorse-adventures shippy supertux supertuxkart vodovod worminator wormux xmoto xgalaxy python-sqlalchemy fceux

audio-video:
	sudo dnf -y --allowerasing install transmageddon handbrake-gui avidemux kdenlive openshot lives vlc mpv gnome-mpv soundconverter audacity-freeworld muse lmms amarok flowblade

zoom:
	wget https://zoom.us/client/latest/zoom_x86_64.rpm
	sudo dnf -y install ./zoom_x86_64.rpm
	rm zoom_x86_64.rpm
