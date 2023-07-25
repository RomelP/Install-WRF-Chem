#!/bin/sh

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
cd $HOME/Build_WRF/src
wget -c http://www.mpich.org/static/downloads/4.0.2/mpich-4.0.2.tar.gz
wget -c https://www.zlib.net/zlib-1.2.12.tar.gz
wget -c https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.2/src/hdf5-1.12.2.tar.gz
wget -c https://curl.se/download/curl-8.1.2.tar.gz
wget -c https://downloads.unidata.ucar.edu/netcdf-c/4.9.2/netcdf-c-4.9.2.tar.gz
wget -c https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.3.tar.gz
wget -c https://jaist.dl.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.gz 
wget -c https://www.ece.uvic.ca/~frodo/jasper/software/jasper-2.0.10.tar.gz
#-----------------------------------------------------------------------------------
# zlib
cd $HOME/Build_WRF/src
tar  -xvzf zlib-1.2.12.tar.gz
cd zlib-1.2.12/
./configure --prefix=$DIR/zlib
make -j4
make install
#----------------------------------------
# Curl
cd $HOME/Build_WRF/src
tar  -xvzf curl-8.1.2.tar.gz
cd curl-8.1.2
./configure --prefix=$DIR/curl --with-zlib=$DIR/zlib --without-ssl
make -j4
make install
#----------------------------------------
# hdf5 library for netcdf4 functionality
cd $HOME/Build_WRF/src
tar -xvzf  hdf5-1.12.2.tar.gz
cd hdf5-1.12.2
./configure --prefix=$DIR/hdf5 --with-zlib=$DIR/zlib --enable-fortran --enable-fortran2003 --enable-cxx --with-default-api-version=v18
make -j4
make install
#---------------------------------------- 	
# NETCDF C Library
cd $HOME/Build_WRF/src
tar -xzvf netcdf-c-4.9.2.tar.gz
cd netcdf-c-4.9.2/
./configure --prefix=$DIR/netcdf --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-dap
make -j4
make install
#----------------------------------------
# NetCDF fortran library
cd $HOME/Build_WRF/src
tar -xzvf netcdf-fortran-4.5.3.tar.gz
cd netcdf-fortran-4.5.3
./configure --prefix=$DIR/netcdf
make -j4
make install
#----------------------------------------
# MPICH
cd $HOME/Build_WRF/src
tar -zxvf mpich-4.0.2.tar.gz
cd  mpich-4.0.2/
./configure --prefix=$DIR/mpich
make -j4
make install
#----------------------------------------
# LIBPNG
cd $HOME/Build_WRF/src
tar -xvzf libpng-1.6.37.tar.gz
cd libpng-1.6.37
./configure --prefix=$DIR/libpng
make -j4
make install
#----------------------------------------
# JasPer
cd $HOME/Build_WRF/src
tar -xvzf jasper-2.0.10.tar.gz
cmake -G "Unix Makefiles" -H/$DIR/src/jasper-2.0.10 -B/$DIR/src/jasper-2.0.10-build -DCMAKE_INSTALL_PREFIX=/$DIR/jasper
cd jasper-2.0.10/
make install
#----------  Install WRF 4.4  ----------# 
cd $HOME/Build_WRF
wget -c https://github.com/wrf-model/WRF/releases/download/v4.4/v4.4.tar.gz -O wrf-4.4.tar.gz 
tar -xvzf wrf-4.4.tar.gz
cd  WRFV4.4
vim configure
echo "change from --if [ "$USENETCDFPAR" == "1" ] ; then -- to --f [ "$USENETCDFPAR" = "1" ] ; then--" 
# Run configure wrf
./configure # 34, 1 for gfortran and distributed memory
# Complie kpp
./compile 2>&1 | tee compile_kpp.log
# Complie em_real mode
./compile em_real 2>&1 | tee compile_wrf.log
echo "list: ndown.exe, real.exe, tc.exe , wrf.exe"
#----------  WPSV4.4  ----------# 
cd $HOME/Build_WRF
ln -sf WRFV4.4 WRF
wget -c https://github.com/wrf-model/WPS/archive/refs/tags/v4.4.tar.gz -O wps-4.4.tar.gz
tar -xvzf wps-4.4.tar.gz
cd WPS-4.4
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

#./compile 2>&1 | tee compile_wps.log
#ls -lah *.exe
 
