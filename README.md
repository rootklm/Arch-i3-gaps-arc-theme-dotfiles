# Arch-i3-gaps-arc-theme-dotfiles
Install instructions/configuration files for Archlinux with i3gaps themed to match arc-dark gtk

Follow the guide here to install:
        https://wiki.archlinux.org/index.php/Installation_guide
        https://wiki.archlinux.org/index.php/Beginners'_guide

What the guide will probably tell you to do (command by command)
        Enable networking
                wifi-menu (follow prompts)
                wifi-menu (again, to make sure it worked)
                ping www.google.com (just in case)
                ctrl+c to stop ping
        Set time
                timedatectl set-ntp true
                timedatectl list-timezones
                timedatectl set-timezone <choose from list above>
        Create partition
                lsblk
                parted /dev/<whatever was in lsblk> (ie. /dev/sda)
                mklabel gpt
                mkpart ESP fat32 1MiB 513MiB
                set 1 boot on
                mkpart primary ext4 513MiB 100%
                q
                lsblk /dev/<whatever you used before> (ie. /dev/sda again)
                mkfs.ext4 /dev/<whatever shows up as the rest> (probably /dev/sda2)
                mount /dev/<the one you just made ext4> /mnt (again, this time /dev/sda2 probably)
                mkdir /mnt/boot
                mkfs.fat -F32 /dev/<whatever shows up as the 512m partition> (probably /dev/sda1)
                mount /dev/<the one you just made fat32> /mnt/boot (/dev/sda1 probably)
        Force packagemanager to use the best mirrors
                cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
                sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
                rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
        Install the base packages into your filesystem
                pacstrap /mnt base
                pacstrap /mnt base
        Configure those packages
                genfstab -p /mnt >> /mnt/etc/fstab
                arch-chroot /mnt
                echo <Name your computer here> > /etc/hostname
                ln -s /usr/share/zoneinfo/<your Country>/<closest (vertically) state> /etc/localtime (ls /usr/share/zoneinfo and ls/usr/share/zoneinfo/<your country> to figure out what is available)
                locale-gen
                echo LANG=<your local> > /etc/locale.conf (probably en_US.UTF-8)
                mkinitcpio -p linux (honestly IDK why this is necessary... creates ram disk)
                passwd (and enter. Just run passwd... it will prompt you to set the root password, no arguments needed)
                pacman -S iw wpa_supplicant dialog grub efibootmgr
                grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub --recheck
                grub-mkconfig -o /boot/grub/grub.cfg
                exit
                umount -R /mnt
                reboot

Tidbits to do after installation:
https://wiki.archlinux.org/index.php/General_recommendations

# root
$ user
Command by command:
  # useradd -m -G wheel -s /bin/bash <Username>
  # passwd <Username> (this will prompt you to create a password. Optional)
	# vim /etc/sudoers
		use / to find "root"
		add this line below the root user access specifications thing:
			<USER_NAME>   ALL=(ALL) ALL
		use ":w!" or ":x!" to write the file
  # wifi-menu (do that process again)
  # pacman -Syu / pacman -Syy
  # pacman -S vim
  $ vim /etc/pacman.conf
  type /multilib -> press "i" on your keyboard -> uncomment [multilib] and the line below it
  Do this stuff if you care enough: https://wiki.archlinux.org/index.php/Kernel_modules#Loading

Things to look up later:

        https://wiki.archlinux.org/index.php/Power_management#Power_management_with_systemd
        https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate
        https://wiki.archlinux.org/index.php/Maximizing_performance
        https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture#Unmuting_the_channels
        https://www.archlinux.org/packages/?name=ttf-dejavu
        https://wiki.archlinux.org/index.php/Font_configuration
        https://wiki.archlinux.org/index.php/Fonts
        https://wiki.archlinux.org/index.php/Fonts#Console_fonts
        https://wiki.archlinux.org/index.php/Console_mouse_support
        https://wiki.archlinux.org/index.php/Scrollback_buffer
        https://wiki.archlinux.org/index.php/File_systems
        https://wiki.archlinux.org/index.php/General_recommendations

Install yaourt (# pacman -S yaourt)
Install xorg and xinit (# pacman -S xorg)
Install Nvidia drivers:
	$ yaourt -S nvidia-rt
	(if it doesnt install the rt kernel as a dependancy automatically, add these lines to your /etc/pacman.conf, then run pacman -Syy and pacman -Syu
		[archaudio-production]
		SigLevel = Never
		Server = http://repos.archaudio.org/$repo/$arch
	)
	# grub-mkconfig -o /boot/grub/grub.cfg
Install i3-gaps:
  $yaourt -S i3-gaps-git
  echo "[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx" >> ~/.bash_profile (or copy from /etc/skel/.bash_profile)
  (or grab the correct ~/.bash_profile from this repo)
  echo exec i3 >> /etc/X11/xinit/xinitrc
  (or grab the correct /etc/X11/xinit/xinitrc from this repo)
Install firefox (# pacman -S firefox)
Install touchpad thingies maybe if you're into that (look it up again)

Set up audio:
        Add user to audio group:
                # usermod -aG audio rklm
        install utilities:
                # pacman -S alsa-utils alsa-plugins
                # pacman -S alsa-oss
                # modprobe snd-seq-oss
                # modprobe snd-pcm-oss
                # modprobe snd-mixer-oss
        Unmuting alsa:
                $ amixer sset Master unmute
                $ alsamixer
        Test:
                $ speaker-test -c 2

Install fonts ($ yaourt -S ttf-google-fonts-git ttf-font-awesome)

Install gtk3 (# pacman -S gtk3) configure with "lxappearance"

Install arc gtk theme ($ yaourt -S gtk-theme-arc-git)

Install arc firefox theme (download from here: https://github.com/horst3180/arc-firefox-theme/releases )

Install lxappearance (# pacman -S lxappearance) configure with "lxappearance"

Install and configure pulse?

install gedit (# pacman -S gedit) configure with GDK

install emacs (# pacman -S emacs)

install urxvt (# pacman -S rxvt-unicode (https://wiki.archlinux.org/index.php/rxvt-unicode)) configure with ~/.Xresources

install rofi ($ yaourt -S rofi-git (https://davedavenport.github.io/rofi/index.html)) configure with ~/.Xresources and in-line command arguments

install i3blocks ($ yaourt -S i3blocks (https://github.com/vivien/i3blocks)) configure with ~/.i3blocks.conf

install transmission-cli (# pacman -S transmission-cli) invoke with "transmission-cli -D -ep -w '/home/rklm/Downloads/' <magnet link>"

install xrandr and arandr (# pacman -S arandr)

install feh (# pacman -S feh) configure with /home/<user>/Pictures/Wallpaper.png

install compton ($ yaourt -S compton (https://wiki.archlinux.org/index.php/Compton)) configure with ~/.config/compton.conf

install ranger (# pacman -S ranger (https://wiki.archlinux.org/index.php/ranger)) configure with ~/.config/ranger

install htop (# pacman -S htop)

install screenfetch (# pacman -S screenfetch)

install nmon (# pacman -S nmon)

install mumble/skype/irssi (# pacman -S skype mumble irssi) (need to un-comment [multilib] in /etc/pacman.conf for skype to install)

install ncmpcpp (# pacman -S ncmpcpp mpd mpc (https://wiki.archlinux.org/index.php/ncmpcpp)) configure with ~/.ncmpcpp/config (sample in /usr/share/doc/ncmpcpp/config)
											 configure mpd with /etc/mpd.conf (sample in /usr/share/doc/mpd/mpdconf.example)
	Create a local-install directory for mpd and copy the config file into it:
		$ mkdir /home/rklm/.config/mpd
		$ cp /usr/share/doc/mpd/mpdconf.example ~/.config/mpd/mpd.conf
        Create these files and directories:
                $ mkdir ~/.config/mpd/playlists
		$ mkdir ~/.config/mpd/mpd-configure
                $ touch ~/.config/mpd/{database,log,pid,state,sticker.sql}
	Run the mpd configuration file sound quality optimizer:
		$ cd ~/.config/mpd/mpd-configure
		$ wget http://lacocina.nl/mpd-configure -O - | tar --strip-components=1 -zxf -
		$ sudo systemctl stop mpd
		$ sudo bash mpd-configure -o "/home/rklm/.config/mpd/mpd.conf"
		$ sudo mpd "/home/rklm/.config/mpd/mpd.conf"
	Change the following in ~/.config/mpd/mpd.conf:
		# Required files
		db_file            "~/.config/mpd/database"
		log_file           "~/.config/mpd/log"
		# Optional
		music_directory    "~/Music"
		playlist_directory "~/.config/mpd/playlists"
		pid_file           "~/.config/mpd/pid"
		state_file         "~/.config/mpd/state"
		sticker_file       "~/.config/mpd/sticker.sql"
        Add the following lines to ~/.config/mpd/mpd.conf: (between 327 and 328 or 15 and 16 probably)
                audio_output {
                    type                    "fifo"
                    name                    "my_fifo"
                    path                    "/tmp/mpd.fifo"
                    format                  "44100:16:2"
                }
	Add these lines to ~/.bash_profile:
		# MPD daemon start (if no other user instance exists)
		[ ! -s ~/.config/mpd/pid ] && mpd
	Change the following in ~/.ncmpcpp/config:
		mpd_host (localhost or 127.0.0.1)
		mpd_port (6600)
		mpd_music_dir  (/home/rklm/Music)
        Add the following lines to ~/.ncmpcpp/config:
                visualizer_fifo_path = "/tmp/mpd.fifo"
                visualizer_output_name = "my_fifo"
                visualizer_sync_interval = "30"
                visualizer_in_stereo = "yes"
                #visualizer_type = "wave" (spectrum/wave)
                visualizer_type = "spectrum" (spectrum/wave)
	Update the music database:
		run the following command:
			$ mpc update
		start ncmpcpp and press:
			u

make lock.sh file (look through existing one and find lock.png)

Installing Unreal Engine 4.0 editor: (https://wiki.unrealengine.com/Building_On_Linux)

	Find these dependanceies and install them:
		build-essential
		mono-gmcs
		mono-xbuild
		mono-dmcs
		libmono-corlib4.0-cil
		libmono-system-data-datasetextensions4.0-cil
		libmono-system-web-extensions4.0-cil
		libmono-system-management4.0-cil
		libmono-system-xml-linq4.0-cil
		cmake
		dos2unix
		clang
		xdg-user-dirs
		(potential solution:
			$ sudo pacman -S mono clang35 dos2unix cmake
			$ mkdir ~/bin/ && cd ~/bin/ && ln -s /bin/ld.bfd ./ld.gold
			Add this to .bashrc >> export PATH=$HOME/bin:$PATH
		)
	Link your github account to your epicgames account (because the git is private)
		Create a Github account
		Create an Epicgames account
		Go here and add your github user name to the field: https://www.unrealengine.com/dashboard/settings
`		Go here and accept the invitation: http://github.com/EpicGames
	Clone the repo:
		$ git clone -b 4.10 https://github.com/EpicGames/UnrealEngine.git /home/rklm/Downloads/UnrealEngine
		$ # or if you are using ssh authentication: 
		$ # git clone -b 4.10 git@github.com:EpicGames/UnrealEngine.git /home/rklm/Downloads/UnrealEngine
		$ cd UnrealEngine
	Configure
		$ ./Setup.sh
		$ ./GenerateProjectFiles.sh
	Install 
		$ make SlateViewer
		$ make UE4Editor UE4Game UnrealPak CrashReportClient ShaderCompileWorker UnrealLightmass
		or
		$ make UE4Editor-Linux-Debug UE4Game UnrealPak CrashReportClient ShaderCompileWorker UnrealLightmass
		$ make -j1 ShaderCompileWorker
	Run executable:
		$ cd Engine/Binaries/Linux && ./UE4Editor
	Generate project files:
		$ ./GenerateProjectFiles.sh -project="/home/user/Documents/Unreal\ Projects/MyProject/MyProject.uproject" -game -engine
	Opening project files:
		$ ./UE4Editor "/home/user/Documents/Unreal\ Projects/MyProject/MyProject.uproject"
		
Once all the stuff from above that you care about is done, make the following directories (if they don't already exist):

~/Desktop
~/Documents
~/Downloads
~/Music
~/Pictures

Then move all of the following files from this repo into their respective directories:

/etc/X11/xinit/xinitrc (if you didn't already make it perfect)
/etc/sudoers (if you didn't already make it perfect)
/etc/pacman.conf (if you didn't already make it perfect)
~/.config/i3/config
~/.Xresources
~/.config/i3/i3blocks.conf
~/.config/compton.conf
~/.config/ranger/ (if it doesn't already exist, which it probably does)
~/.ncmpcpp/config
/etc/mpd.conf
~/.bash_profile
~/.config/screen-lock.png
~/Pictures/wallpaper.png
