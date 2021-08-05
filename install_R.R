## source
https://cran.r-project.org/bin/linux/ubuntu/README.html


## add CRAN GPG key
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9



## add repository to APT repository
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/'
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'


## update to incolude package manifests from new repository
sudo apt update
sudo apt upgrade

## install R
sudo apt install r-base

## check R version
R --version


## need to compile R package
sudo apt-get install r-base-dev


## list all PPA
apt policy

## remove PPA
sudo add-apt-repository --remove ppa:videolan/master-daily

## autoclean and auto remove apt
sudo apt-get autoclean
sudo apt-get autoremove


## install ppa remover
sudo apt-get install ppa-purge
## remove ppa by url
sudo ppa-purge ppa-url


## edit sources.list file, remove or comment (#) entries;
sudo gedit /etc/apt/sources.list

##
apt-get upgrade will not change what is installed (only versions),
apt-get dist-upgrade will install or remove packages as necessary to complete the upgrade,
apt upgrade will automatically install but not remove packages.
apt full-upgrade performs the same function as apt-get dist-upgrade.


##
update.packages()

## install libfrididi-dev
sudo apt-get update -y
sudo apt-get install -y libfribidi-dev


## for sf package
sudo apt install -y libudunits2-0 libudunits2-dev
sudo apt install libgdal-dev
sudo apt-get install libxmu-dev libxmu-headers freeglut3-dev libxext-dev libxi-dev
sudo apt install libgdal-dev
sudo apt-get install libgcc1 lib32gcc1 libx32gcc1
sudo apt-get update
sudo apt-get install gdal-bin
sudo apt-get install libgdal-dev
sudo apt-get install libgeos-dev

sudo apt-get update
sudo apt-get install libgdal-dev libproj-dev
sudo apt install libgeos++dev
sudo apt install gdal-bin libgdal-dev libproj-dev

sudo apt-get install libgdal1-dev libproj-dev


sudo add-apt-repository ppa:ubuntugis/ppa
ogrinfo --version

sudo add-apt-repository ppa:ubuntugis/ppa && sudo apt-get update
sudo add-apt-repository ppa:ubuntugis/ppa


sudo dpkg -i libgdal1-dev_1.11.3+dfsg-3build2_all.deb

## search for current lib name
apt-cache search libgdal
## libgdal-dev is already the newest version (2.4.2+dfsg-1~bionic0).

## for install R rgdal package
sudo apt-get install gdal-bin proj-bin libgdal-dev libproj-dev

## install gcc g++ c++ complier
sudo apt install g++

## sudo apt remove pckage

    sudo apt remove package


## check if installed
dpkg -l packag


apt-cache policy will only show the repos after you have run apt-get update. If you just added a repo with add-apt-repository, it will not show up with apt-cache policy until you run apt-get update

## list all sources
sudo ls /etc/apt/sources.list.d

## remove
sudo rm -i /etc/apt/sources.list.d/PPA_Name.list

sudo gedit /etc/apt/sources.list


apt-cache policy emacs26-common emacs25-common

sudo apt upgrade package - name;

## remove;
sudo rm -f /usr/local/bin/gdal-config

sudo apt-get --purge remove gimp


## remove onld link cache
sudo ldconfig


sudo apt-get install libwebp5
