#!/bin/bash

source ~/.bashrc
sudo apt update
sudo apt upgrade

# Install preferred software
sudo apt install csh m4 build-essential nasm cmake unzip libxmu-dev libcairo-dev libbz2-dev libxaw7-dev libx11-dev xorg-dev flex bison subversion liburi-perl evince tcsh cpp m4 quota cvs libomp-dev python3-pip freeglut3-dev libjpeg-dev file
# Install compiler
sudo apt install gcc gfortran g++ 
mkdir $HOME/Build_WRF
cd $HOME/Build_WRF
mkdir src
mkdir LIBRARIES
#-----------------------------------------------------------------------------------
## Downloading Libraries in directory of source code
#-----------------------------------------------------------------------------------
# Download and install MPICH library
cd $HOME/Build_WRF/src
wget -c http://www.mpich.org/static/downloads/4.0.2/mpich-4.0.2.tar.gz
tar -zxvf mpich-4.0.2.tar.gz
cd  mpich-4.0.2/
FFLAGS=-fallow-argument-mismatch FCFLAGS=-fallow-argument-mismatch ./configure --prefix=$HOME/Build_WRF/LIBRARIES/mpich
make -j4
make install
#create PATH variable in file .profile.
# vim ~/.profile
#export PATH=$HOME/Build_WRF/LIBRARIES/mpich/bin:$PATH
# source ~/.profile
#----------------------------------------------------------
# Download and install zlib library
cd $HOME/Build_WRF/src
wget -c https://www.zlib.net/zlib-1.2.12.tar.gz
tar  -xvzf zlib-1.2.12.tar.gz
cd zlib-1.2.12/
./configure --prefix=$HOME/Build_WRF/LIBRARIES/zlib
make -j4
make install
#----------------------------------------------------------
# Download and install hdf5 library for netcdf4 functionality
cd $HOME/Build_WRF/src
wget -c https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.2/src/hdf5-1.12.2.tar.gz
tar -xvzf  hdf5-1.12.2.tar.gz
cd hdf5-1.12.2
./configure --prefix=$HOME/Build_WRF/LIBRARIES/hdf5 --with-zlib=$HOME/Build_WRF/LIBRARIES/zlib --enable-fortran --enable-fortran2003 --enable-cxx --with-default-api-version=v18
make -j4
make install
# vim ~/.profile
#export PATH=$HOME/Build_WRF/LIBRARIES/hdf5/bin:$PATH
#export LD_LIBRARY_PATH=$HOME/Build_WRF/LIBRARIES/hdf5/lib:$LD_LIBRARY_PATH
# source ~/.profile
#----------------------------------------------------------
# Download and install Curl library 
cd $HOME/Build_WRF/src
wget -c https://curl.se/download/curl-8.1.2.tar.gz
tar  -xvzf curl-8.1.2.tar.gz
cd curl-8.1.2
./configure --prefix=$HOME/Build_WRF/LIBRARIES/curl --with-zlib=$HOME/Build_WRF/LIBRARIES/zlib --without-ssl
make -j4
make install
#---------------------------------------------------------- 	
# Download and install NETCDF C Library
cd $HOME/Build_WRF/src
wget -c https://downloads.unidata.ucar.edu/netcdf-c/4.9.2/netcdf-c-4.9.2.tar.gz
tar -xzvf netcdf-c-4.9.2.tar.gz
cd netcdf-c-4.9.2
CFLAGS=-fPIC CPPFLAGS='-I$HOME/Build_WRF/LIBRARIES/hdf5/include -I$HOME/Build_WRF/LIBRARIES/curl/include' 
LDFLAGS='-L$HOME/Build_WRF/LIBRARIES/hdf5/lib -L$HOME/Build_WRF/LIBRARIES/curl/lib' 
./configure --prefix=$HOME/Build_WRF/LIBRARIES/netcdf --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-dap
make -j4
make install
#----------------------------------------------------------
# Download and install NetCDF fortran library
cd $HOME/Build_WRF/src
wget -c https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.3.tar.gz
tar -xzvf netcdf-fortran-4.5.3.tar.gz
cd netcdf-fortran-4.5.3
CPPFLAGS='-I$HOME/Build_WRF/LIBRARIES/netcdf/include'
LDFLAGS='-L$HOME/Build_WRF/LIBRARIES/netcdf/lib' 
FCFLAGS='-m64'
./configure --prefix=$HOME/Build_WRF/LIBRARIES/netcdf
make -j4
make install

# vim ~/.profile
#export PATH=$HOME/Build_WRF/LIBRARIES/netcdf/bin:$PATH
#export NETCDF=$HOME/Build_WRF/LIBRARIES/netcdf
#export LD_LIBRARY_PATH=$HOME/Build_WRF/LIBRARIES/netcdf/lib:$LD_LIBRARY_PATH
# source ~/.profile
#----------------------------------------------------------
#Download and install LIBPNG library
cd $HOME/Build_WRF/src
wget -c https://jaist.dl.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.gz 
tar -xvzf libpng-1.6.37.tar.gz
cd libpng-1.6.37
CPPFLAGS='-I$HOME/Build_WRF/LIBRARIES/netcdf/include' FCFLAGS='-m64'
./configure --prefix=$HOME/Build_WRF/LIBRARIES/libpng
make -j4
make install
#----------------------------------------------------------
#Download and install JasPer library
cd $HOME/Build_WRF/src
wget -c https://www.ece.uvic.ca/~frodo/jasper/software/jasper-2.0.10.tar.gz
tar -xvzf jasper-2.0.10.tar.gz
cmake -G "Unix Makefiles" -H$HOME/Build_WRF/LIBRARIES/src/jasper-2.0.10 -B$HOME/Build_WRF/LIBRARIES/src/jasper-2.0.10-build -DCMAKE_INSTALL_PREFIX=$HOME/Build_WRF/LIBRARIES/jasper
cd jasper-2.0.10/
make install

# vim ~/.profile
# export PATH=$HOME/Build_WRF/LIBRARIES/jasper/bin:$PATH
# export LD_LIBRARY_PATH=$HOME/Build_WRF/LIBRARIES/jasper/lib:$LD_LIBRARY_PATH

#----------------------------------------------------------
#Download and install ncl library

cd $HOME/Build_WRF/src
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
sh ./Miniconda3-latest-Linux-x86_64.sh

#source ~/.bashrc
#conda create -n ncl_stable -c conda-forge ncl
#source activate ncl_stable
# Create variable in file .profile.
# vim ~/.bashrc
# source activate ncl_stable
#-----------------------------------------------------------------------------------
#----------  Install WRF 4.4  ----------# 
ulimit -s unlimited
export MALLOC_CHECK_=0
export EM_CORE=1
export NMM_CORE=0
export WRF_CHEM=1
export WRF_KPP=1
export YACC='/usr/bin/yacc -d'
export FLEX=/usr/bin/flex
export FLEX_LIB_DIR=/usr/lib/x86_64-linux-gnu
export KPP_HOME=/home/ubuntu/Build_WRF/WRFV4.4/chem/KPP/kpp/kpp-2.1 $ export WRF_SRC_ROOT_DIR=/home/ubuntu/Build_WRF/WRFV4.4
export PATH=$KPP_HOME/bin:$PATH
export SED=/usr/bin/sed
export WRFIO_NCD_LARGE_FILE_SUPPORT=1

# Change to directory.

cd $HOME/Build_WRF
wget -c https://github.com/wrf-model/WRF/releases/download/v4.4/v4.4.tar.gz -O wrf-4.4.tar.gz 
tar -xvzf wrf-4.4.tar.gz
cd WRFV4.4/chem/KPP/kpp/kpp-2.1/src
/usr/bin/flex scan.l
cd $HOME/Build_WRF/WRFV4.4

vim configure
echo "change from --if [ "$USENETCDFPAR" == "1" ] ; then -- to --f [ "$USENETCDFPAR" = "1" ] ; then--" 
# Run configure wrf
./configure # 34, 1 for gfortran and distributed memory
# Complie kpp
./compile 2>&1 | tee compile_kpp.log
# Complie em_real mode
./compile em_real 2>&1 | tee compile_wrf.log

echo "list: ndown.exe, real.exe, tc.exe and wrf.exe"
ls -lah main/*.exe
#-----------------------------------------------------------------------------------
#----------  WPSV4.4  ----------# 
cd $HOME/Build_WRF
ln -sf WRFV4.4 WRF
wget -c https://github.com/wrf-model/WPS/archive/refs/tags/v4.4.tar.gz -O wps-4.4.tar.gz
tar -xvzf wps-4.4.tar.gz
cd WPS-4.4

export JASPERLIB=$HOME/Build_WRF/LIBRARIES/jasper/lib
export JASPERINC=$HOME/Build_WRF/LIBRARIES/jasper/include


./configure # 3, (Linux x86-64) gfortran (dmpar) for gfortran and distributed memory
echo "edit configure.wps // read PDF tutorial"
vim configure.wps
#COMPRESSION_LIBS = -L$DIR/jasper/lib -ljasper - lpng -lz
#COMPRESSION_INC = -I$DIR/jasper/include
# DM_FC   = mpif90
# WRF_LIB = -L$(WRF_DIR)/external/io_grib1 -lio_grib1 \
#           -L$(WRF_DIR)/external/io_grib_share -lio_grib_share \ 
#           -L$(WRF_DIR)/external/io_int -lwrfio_int \ 
#           -L$(WRF_DIR)/external/io_netcdf -lwrfio_nf \ 
#           -L$(NETCDF)/lib -lnetcdff -lnetcdf -lgomp

# Compilie WPS

./compile 2>&1 | tee compile_wps.log
echo "list: geogrid.exe, metgrid.exe and ungrib.exe"
ls -lah *.exe
 
# If you see geogrid.exe metgrid.exe and ungrib.exe then correct. 
# Else check Error in compile_wps.log file.
