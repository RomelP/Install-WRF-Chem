#!/bin/bash

source ~/.bashrc
sudo apt update
sudo apt upgrade

# Install preferred software
sudo apt install -y tcsh git libcurl4-openssl-dev
sudo apt install libtool automake autoconf make m4 default-jre default-jdk csh ksh git ncview ncl-ncarg build-essential unzip mlocate byacc flex
# Install compiler
sudo apt install -y make gcc cpp gfortran openmpi-bin libopenmpi-dev g++
#----------------------------------------------------------------------
mkdir $HOME/Models
mkdir $HOME/Models/WRF-Chem
#--------------------------
export WRFCHEM_HOME=$HOME/Models/WRF-Chem
#--------------------------
cd $WRFCHEM_HOME
mkdir Downloads
mkdir Libs
mkdir Libs/grib2
mkdir Libs/NETCDF
mkdir Libs/MPICH
#--------------------------
export DIR=$WRFCHEM_HOME/Libs
export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran
#----------------------------------------------------------------------
## Downloading Libraries
cd $WRFCHEM_HOME/Downloads
wget -c https://www.zlib.net/zlib-1.2.13.tar.gz 
wget -c https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.13/hdf5-1.13.2/src/hdf5-1.13.2.tar.gz
wget -c https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz -O netcdf-c-4.9.0.tar.gz
wget -c https://downloads.unidata.ucar.edu/netcdf-fortran/4.6.0/netcdf-fortran-4.6.0.tar.gz
wget -c http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-1.900.1.zip
wget -c https://sourceforge.net/projects/libpng/files/libpng16/1.6.39/libpng-1.6.39.tar.gz
wget -c http://www.mpich.org/static/downloads/4.0.3/mpich-4.0.3.tar.gz
#----------------------------------------------------------------------
# zlib
cd $WRFCHEM_HOME/Downloads
tar  -xvzf zlib-1.2.13.tar.gz
cd zlib-1.2.13/
./configure --prefix=$DIR/grib2
make
make install
#----------------------------------------------------------
# hdf5 library for netcdf4 functionality
cd $WRFCHEM_HOME/Downloads
tar -xvzf  hdf5-1.13.2.tar.gz
cd hdf5-1.13.2
./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran
make 
make install
export HDF5=$DIR/grib2
export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
#----------------------------------------------------------
# NETCDF C Library
cd $WRFCHEM_HOME/Downloads
tar -xzvf netcdf-c-4.9.0.tar.gz
cd netcdf-c-4.9.0/
export CPPFLAGS=-I$DIR/grib2/include
export LDFLAGS=-L$DIR/grib2/lib
./configure --prefix=$DIR/NETCDF --disable-dap
make
make install
export PATH=$DIR/NETCDF/bin:$PATH
export NETCDF=$DIR/NETCDF
#----------------------------------------------------------
# NetCDF fortran library
cd $WRFCHEM_HOME/Downloads
tar -xvzf netcdf-fortran-4.6.0.tar.gz
cd netcdf-fortran-4.6.0
export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
export CPPFLAGS=-I$DIR/NETCDF/include
export LDFLAGS=-L$DIR/NETCDF/lib
./configure --prefix=$DIR/NETCDF --disable-shared
make
make install
#----------------------------------------------------------
# JASPER
cd $WRFCHEM_HOME/Downloads
unzip jasper-1.900.1.zip
cd jasper-1.900.1
autoreconf -i
./configure --prefix=$DIR/grib2
make
make install
export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include

#----------------------------------------------------------
# LIBPNG
cd $WRFCHEM_HOME/Downloads
tar -xvzf libpng-1.6.39.tar.gz
cd libpng-1.6.39
export LDFLAGS=-L$DIR/grib2/lib
export CPPFLAGS=-I$DIR/grib2/include
./configure --prefix=$DIR/grib2
make 
make install
#----------------------------------------------------------
# MPICH
cd $WRFCHEM_HOME/Downloads
tar -zxvf mpich-4.0.3.tar.gz
cd mpich-4.0.3
./configure --prefix=$DIR/MPICH --with-device=ch3 FFLAGS=-fallow-argument-mismatch FCFLAGS=-fallow-argument-mismatch
make
make install
export PATH=$DIR/MPICH/bin:$PATH

#----------------------------------------------------------------------
#------------------- Install WRF 4.5  --------------------# 
cd $WRFCHEM_HOME/Downloads

wget -c https://github.com/wrf-model/WRF/releases/download/v4.5/v4.5.tar.gz -O wrf-4.5.tar.gz
tar -xzvf wrf-4.5.tar.gz -C $WRFCHEM_HOME
cd $WRFCHEM_HOME/WRFV4.5
#-------------------
ulimit -s unlimited
export WRF_EM_CORE=1
export WRF_NMM_CORE=0  
export WRF_CHEM=1
export WRF_KPP=1 
export YACC='/usr/bin/yacc -d' 
export FLEX=/usr/bin/flex
export FLEX_LIB_DIR=/usr/lib/x86_64-linux-gnu/ 
export KPP_HOME=$WRFCHEM_HOME/WRFV4.5/chem/KPP/kpp/kpp-2.1
export WRF_SRC_ROOT_DIR=$WRFCHEM_HOME/WRFV4.5
export PATH=$KPP_HOME/bin:$PATH
export SED=/usr/bin/sed
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
#-------------------
cd chem/KPP
sed -i -e 's/="-O"/="-O0"/' configure_kpp
cd -

sed -i -e 's/if [ "$USENETCDFPAR" == "1" ] ; then/if [ "$USENETCDFPAR" = "1" ] ; then/' configure
./configure # 34, 1 for gfortran and distributed memory
# Compile WRF-Chem
./compile em_real 2>&1 | tee wrfchem_compile.log
export WRF_DIR=$WRFCHEM_HOME/WRFV4.5

# Compile the WRF-Chem external emissions conversion code
./compile emi_conv 2>1 | tee emission_compile.log

#----------------------------------------------------------------------
#------------------- Install WPSV4.5  --------------------# 
 
cd $WRFCHEM_HOME/Downloads
wget -c https://github.com/wrf-model/WPS/archive/refs/tags/v4.5.tar.gz -O wps-4.5.tar.gz
tar -xzvf wps-4.5.tar.gz -C $WRFCHEM_HOME
cd $WRFCHEM_HOME/WPS-4.5

export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include

./configure # 3, (Linux x86-64) gfortran (dmpar) for gfortran and distributed memory
./compile

export PATH=$DIR/bin:$PATH
export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH

 # Set the color variable
green='\033[0;32m'
# Clear the color after that
clear='\033[0m'
echo "${green}*Successfully installed !!! WRF-Chem 4.5*${clear}"

#----------------------------------------------------------------------
