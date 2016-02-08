# Arch-i3-gaps-arc-theme-dotfiles
Install instructions/configuration files for Archlinux with i3gaps themed to match arc-dark gtk
![Alt text](http://i.imgur.com/3fdoEcM.png "Workspace 1")
![Alt text](http://i.imgur.com/waou1u7.png "Workspace 2")
![Alt text](http://i.imgur.com/CySKsv3.png "Workspace 3")

#References:
##Installation:
```
https://wiki.archlinux.org/index.php/Installation_guide
https://wiki.archlinux.org/index.php/Beginners'_guide
```

##Post install recommendations:
```
https://wiki.archlinux.org/index.php/General_recommendations
```

##Tweaking kernel modules:
```
https://wiki.archlinux.org/index.php/Kernel_modules#Loading
https://wiki.archlinux.org/index.php/Maximizing_performance
```

##Power Management:
```
https://wiki.archlinux.org/index.php/Power_management#Power_management_with_systemd
https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate
```

##Things I haven't researched yet:
```
https://wiki.archlinux.org/index.php/Console_mouse_support
https://wiki.archlinux.org/index.php/Scrollback_buffer
https://wiki.archlinux.org/index.php/File_systems
```
```
\# root (priority: sudo > su)
$ user
```

#Install:
```
Boot thumb drive in UEFI mode
```
##Enable networking:
```
\# wifi-menu (follow prompts)
\# ping google.com (make sure it worked)
ctrl+c (stop ping)
```

##Set time:
```
\# timedatectl set-ntp true
\# timedatectl list-timezones (choose the closest)
\# timedatectl set-timezone Chosen/Time_Zone
```

##Create/format partitions:
```
\# lsblk
\# parted /dev/sda (or whatever drive shows up in lsblk, ie: /dev/<your drive>)
\# mklabel gpt
\# mkpart ESP fat32 1MiB 513MiB
\# set 1 boot on
\# mkpart primary ext4 513MiB 100%
\# q
\# lsblk /dev/sda (ie: /dev/<whatever you used before>)
\# mkfs.ext4 /dev/sda2 (ie: /dev/<whatever you used before>2 most likely)
\# mount /dev/sda2 /mnt (ie: /dev/<whatever you used before>2 /mnt)
\# mkdir /mnt/boot
\# mkfs.fat -F32 /dev/sda1 (ie: /dev/<whatever you used before>1 most likely)
\# mount /dev/sda1 /mnt/boot (ie: /dev/<whatever you used before>1 /mnt/boot)
```

##Force packagemanager to use the best mirrors:

###Dotfiles from external drive method:
```
\# mkdir /media
\# mkdir /media/usb
\# chmod -r 777 /media/usb
\# mount /dev/sdc1 /media/usb (or whatever deive shows up in lsblk as your backup/dotfiles drive, ie: the drive that isnt 512 MiB or the size as the rest of your storage)
\# rm /etc/pacman.d/mirrorlist
\# cp /media/usb/Backup/mirrorlist /etc/pacman.d/
```

###Manual method:
```
\# cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
\# sed -i 's/^\#Server/Server/' /etc/pacman.d/mirrorlist.backup
\# rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
```

##Install the base packages into your filesystem:
```
\# pacstrap /mnt base base-devel
```

##Configure those packages
```
\# genfstab -p /mnt >> /mnt/etc/fstab
\# arch-chroot /mnt
\# echo <Name your computer here> > /etc/hostname
\# ln -s /usr/share/zoneinfo/Chozen/Time_Zone > /etc/localtime (ls /usr/share/zoneinfo and ls/usr/share/zoneinfo/<your country> to figure out what is available)
\# locale-gen
\# echo $LANG=en_US.UTF-8 > /etc/locale.conf
\# mkinitcpio -p linux
\# passwd (follow prompts)
\# pacman -S iw wpa_supplicant dialog grub efibootmgr
\# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub --recheck
\# grub-mkconfig -o /boot/grub/grub.cfg
\# exit
\# umount -R /mnt
\# reboot
```

#Make some folders in your home directory:
```
$ mkdir ~/Desktop
$ mkdir ~/Documents
$ mkdir ~/Downloads
$ mkdir ~/Music
$ mkdir ~/Pictures
$ mkdir ~/Software
$ mkdir ~/bin
```

#Reconnect to the internet:
```
\# wifi-menu (follow the prompts again)
```

#Update package manager:
```
\# pacman -Syy
\# pacman -Syu
```

#Install yaourt (for aur):
```
$ cd /home/rklm/Downloads
$ git clone https://aur.archlinux.org/package-query.git
$ cd package-query
$ makepkg -si
$ cd ..
$ git clone https://aur.archlinux.org/yaourt.git
$ cd yaourt
$ makepkg -si
```

#Install vim (to make the steps that require config file edits easier):
```
\# pacman -S vim
```

#Set up user:
```
\# useradd -m -G wheel -s /bin/bash <Username>
\# passwd <Username> (follow prompts)
\# vim /etc/sudoers
add the following line under "root ALL=(ALL) ALL":
     "rklm ALL=(ALL) ALL"
save the file with :w! or :x!
```

#Configure video drivers/server:

##Normal drivers (for normal kernel):
```
\# pacman -S nvidia xorg-xinit (automatically installs xorg)
```

##RT drivers (for realtime kernel:
```
$ yaourt -S nvidia-rt (automatically installs proper xorg and proper rt kernel)
\# pacman -S xorg-xinit
\# grub-mkconfig -o /boot/grub/grub.cfg
```

##If the nvidia-rt drivers and/or kernel don't show up in yaourt/pacman:

###Manual:

####Add the following lines to /etc/pacman.conf:
```
[archaudio-production]
SigLevel = Never
Server = http://repos.archaudio.org/$repo/$arch
\# pacman -Syy
\# pacman -Syu
```

####If it still doesn't work, add "SigLevel = Never" to the other repositories.

###or:
```
$ rm /etc/pacman.conf
$ cp /media/usb/Backup/pacman.conf /etc/
```

#Install i3:
```
$ yaourt -S i3-gaps-git
```

##Configure it to start at login:

###Manual:

####Add the following to ~/.bash_profile:
```
"[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx"
```

####Add the following to /etc/X11/xinit/xinitrc:
```
"exec i3"
```

###Automatic:
```
$ rm ~/.bash_profile
$ cp /media/usb/Backup/.bash_profile ~/
$ rm /etc/X11/xinit/xinitrc
$ cp /media/usb/Backup/xinitrc /etc/X11/xinit/
```

#Install Standard software:
```
\# pacman -S firefox gtk3 lxappearance gedit emacs rxvt-unicode transmission-cli arandr feh ranger htop nmon screenfetch 
$ yaourt -S ttf-google-fonts-git ttf-font-awesome gtk-theme-arc-git rofi-git i3blocks compton apulse 
```

#Configure software:
```
run lxappearance, and choose the arc gtk theme, and choose droid sans font.
Go to this address in firefox and install the arc firefox theme: https://github.com/horst3180/arc-firefox-theme/releases
Make a macro that runs transmission cli in the terminal using this syntax: "transmission-cli -D -ep -w '/home/rklm/Downloads/' <magnet link>"
move wallpaper.jpg to ~/Pictures
$ cp /usr/share/apulse/asoundrc.sample ~/.asoundrc
$ cp /media/usb/Backup/lock.sh ~/bin
$ cp /media/usb/Backup/lock.png ~/.config/i3/
```

#Install skype:

##Multilib:
```
un-comment [multilib] in /etc/pacman.conf
\# pacman -S skype
Replace exec line in /usr/share/applications/skype.desktop with Exec=/usr/bin/apulse32 /usr/bin/skype  %U
```

##Chroot:
```
Idk yet
```

#Install ncmpcpp: 
```
\# pacman -S ncmpcpp mpd mpc
```

##Create a local-install directory for mpd and copy the config file into it:
```
$ mkdir /home/rklm/.config/mpd
$ cp /usr/share/doc/mpd/mpdconf.example ~/.config/mpd/mpd.conf
```

##Create these files and directories:
```
$ mkdir ~/.config/mpd/playlists
$ mkdir ~/.config/mpd/mpd-configure
$ touch ~/.config/mpd/{database,log,pid,state,sticker.sql}
```

##Copying configs from dotfiles:
```
$ rm ~/.config/mpd/mpd.conf
$ cp /media/usb/Backup/mpd.conf ~/.config/mpd/
$ rm ~/.ncmpcpp/config
$ cp /media/usb/Backup/ncmpcpp/config ~/.ncmpcpp/
```

###Update the music database:

####run the following command:
```
$ mpc update
```

####start ncmpcpp and press:
```
u
```

##Manual configuration:

###Run the mpd configuration file sound quality optimizer:
```
$ cd ~/.config/mpd/mpd-configure
$ wget http://lacocina.nl/mpd-configure -O - | tar --strip-components=1 -zxf -
$ sudo systemctl stop mpd
$ sudo bash mpd-configure -o "/home/rklm/.config/mpd/mpd.conf"
$ sudo mpd "/home/rklm/.config/mpd/mpd.conf"
```

###Change the following in ~/.config/mpd/mpd.conf:
```
\# Required files
db_file            "~/.config/mpd/database"
log_file           "~/.config/mpd/log"
\# Optional
music_directory    "~/Music"
playlist_directory "~/.config/mpd/playlists"
pid_file           "~/.config/mpd/pid"
state_file         "~/.config/mpd/state"
sticker_file       "~/.config/mpd/sticker.sql"
```

###Add the following lines to ~/.config/mpd/mpd.conf: (between 327 and 328 or 15 and 16 probably)
```
audio_output {
   type"fifo"
   name"my_fifo"
   path"/tmp/mpd.fifo"
   format"44100:16:2"
}
```

###Add these lines to ~/.bash_profile:
```
\# MPD daemon start (if no other user instance exists)
[ ! -s ~/.config/mpd/pid ] && mpd
```

###Change the following in ~/.ncmpcpp/config:
```
mpd_host (localhost or 127.0.0.1)
mpd_port (6600)
mpd_music_dir  (/home/rklm/Music)
```
   
###Add the following lines to ~/.ncmpcpp/config:
```
visualizer_fifo_path = "/tmp/mpd.fifo"
visualizer_output_name = "my_fifo"
visualizer_sync_interval = "30"
visualizer_in_stereo = "yes"
\#visualizer_type = "wave" (spectrum/wave)
visualizer_type = "spectrum" (spectrum/wave)
```

###Update the music database:

####run the following command:
```
$ mpc update
```

####start ncmpcpp and press:
```
u
```

#Move your dotfiles over:
```
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
*.sh from ~/.config/i3/startScripts
*.json from ~/.config/i3/ (maybe make a new directory at ~/.config/i3/workspaceLayouts and change the references in ~/.config/i3/config)
```

#Install unreal engine: 

##Setup dependencies:
```
$ sudo pacman -S mono clang35 dos2unix cmake
```

##Use a workaround for a bug:
```
$ cd ~/bin/ && ln -s /bin/ld.bfd ./ld.gold
Add this to .bashrc >> export PATH=$HOME/bin:$PATH
```

##Link your github account to your epicgames account (because the git is private)
```
Create a Github account
Create an Epicgames account
Go here and add your github user name to the field: https://www.unrealengine.com/dashboard/settings
Go here and accept the invitation: http://github.com/EpicGames
```

##Clone the repo:
```
$ git clone -b 4.10 https://github.com/EpicGames/UnrealEngine.git /home/rklm/Downloads/UnrealEngine
$ \# or if you are using ssh authentication: 
$ \# git clone -b 4.10 git@github.com:EpicGames/UnrealEngine.git /home/rklm/Downloads/UnrealEngine
$ cd UnrealEngine
```

##Configure
```
$ ./Setup.sh
$ ./GenerateProjectFiles.sh
```

##Install 
```
$ make SlateViewer
$ make UE4Editor UE4Game UnrealPak CrashReportClient ShaderCompileWorker UnrealLightmass
or
$ make UE4Editor-Linux-Debug UE4Game UnrealPak CrashReportClient ShaderCompileWorker UnrealLightmass
$ make -j1 ShaderCompileWorker
```

##Create/Run executable:
```
$ mkdir ~/Software (if it doesn't exist
$ mv ~/Downloads/UnrealEngine/ ~/Software/UnrealEngine
$ echo -e '\#!/bin/bash\nExec=cd ~/Software/UnrealEngine/Engine/Binaries/Linux && ./UE4Editor-Linux-Debug' >> ~/bin/UnrealEngine.sh
$ chmod +x UnrealEngine.sh
```

##Generate project files:
```
$ ./GenerateProjectFiles.sh -project="/home/user/Documents/Unreal\ Projects/MyProject/MyProject.uproject" -game -engine
```

##Opening project files:
```
$ ./UE4Editor "/home/user/Documents/Unreal\ Projects/MyProject/MyProject.uproject"
```

#Install osu!: 

##Multilib install:
```
$ sudo usermod -a -G audio rklm
$ sudo usermod -a -G video rklm
$ mkdir ~/Backups
$ cp /etc/security/limits.conf ~/Backups
$ sudo echo -e '@audio - rtprio 99\n@audio - memlock 8000000\n@audio - nice -19' >> /etc/security/limits.conf
$ sudo echo -e 'options usbhid mousepoll=1' >> /etc/modprobe.d/modprobe.conf
$ echo -e '\#!/bin/bash\n\#wait for the desktop to settle\nsleep 10\n\# turn off mouse acceleration\nxset m 0 0' >> ~/bin/nomouseacc.sh
$ sudo chmod +x ~/bin/nomouseacc.sh
$ sudo pacman -Syu wine-staging
$ sudo pacman -S winetricks
$ ALSA_DEFAULT_PCM="plug:dmixer" WINEPREFIX=~/.wine WINEARCH=win32 winecfg
<prompts, prompts, prompts prompts accept all of them>
$ ALSA_DEFAULT_PCM="plug:dmixer" WINEPREFIX=~/.wine WINEARCH=win32 winetricks -q dotnet45 corefonts gdiplus cjkfonts
$ ALSA_DEFAULT_PCM="plug:dmixer" WINEPREFIX=~/.wine WINEARCH=win32 winecfg
<libraries tab, edit gdiplus -> "built in then native"
$ cd Downloads
$ wget 'https://m1.ppy.sh/release/osu!install.exe' --no-check-certificate
$ ALSA_DEFAULT_PCM="plug:dmixer" WINEPREFIX=~/.wine WINEARCH=win32 wine 'osu!install.exe'
$ echo -e '\#!/bin/bash\nExec=env ALSA_DEFAULT_PCM="plug:dmixer" env WINEPREFIX=/home/rklm/.wine env WINEARCH=win32 wine "/home/rklm/.wine/drive_c/Program Files/osu!/osu!.exe"' >> ~/bin/osu.sh
$ sudo chmod +x /home/rklm/bin/osu.sh
Then recompile winealsa to reduce audio lag:
$ cd Downloads (if you aren't already there)
$ wget http://ftp.winehq.org/pub/wine/source/1.9/wine-1.9.2.tar.bz2
$ tar -xvf wine-1.9.2.tar.bz2
$ cd wine-1.9.2
$ vim dlls/winealsa.drv/mmdevdrv.c
replace these lines:
static const REFERENCE_TIME DefaultPeriod = 10000;
static const REFERENCE_TIME MinimumPeriod = 10000;
\#define    EXTRA_SAFE_RT   5000
$ sudo pacman -S multilib-devel
$ ./configure --without-x --without-freetype
$ make dlls/winealsa.drv
$ cp /usr/lib/wine/winealsa.drv.so ~/Backups
$ cp /usr/lib64/wine/winealsa.drv.so ~/Backups/winealsa.drv.so_64
$ cp /usr/lib/wine/fakedlls/winealsa.drv ~/Backups/winealsa.drv.fake
$ cp /usr/lib64/wine/fakedlls/winealsa.drv ~/Backups/winealsa.drv.fake_64
$ sudo cp dlls/winealsa.drv/winealsa.drv.so /usr/lib/wine/winealsa.drv.so
$ sudo cp dlls/winealsa.drv/winealsa.drv.so /usr/lib64/wine/winealsa.drv.so
$ sudo cp dlls/winealsa.drv/winealsa.drv.fake /usr/lib/wine/fakedlls/winealsa.drv
$ sudo cp dlls/winealsa.drv/winealsa.drv.fake /usr/lib64/wine/fakedlls/winealsa.drv
```

##Chroot install:
```
idk yet
```

#Set up touchpad:
```
\# pacman -S xf86-input-synaptics
$ cp /usr/share/X11/xorg.conf.d/50-synaptics.conf /etc/X11/xorg.conf.d/
```

#Set up audio:

##Add user to audio group:
```
\# usermod -aG audio rklm
```

##install utilities:
```
\# pacman -S alsa-utils alsa-plugins
\# pacman -S alsa-oss
\# modprobe snd-seq-oss
\# modprobe snd-pcm-oss
\# modprobe snd-mixer-oss
```

##Unmuting alsa:
```
$ amixer sset Master unmute
$ alsamixer
```

##Test:
```
$ speaker-test -c 2
```
