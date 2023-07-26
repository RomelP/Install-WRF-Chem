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
cd $WRFCHEM_HOME
mkdir Downloads
mkdir Libs
mkdir Libs/grib2
mkdir Libs/NETCDF
mkdir Libs/MPICH
#----------------------------------------------------------------------
## Downloading Libraries
cd $WRFCHEM_HOME/Downloads
wget -c https://www.zlib.net/zlib-1.2.13.tar.gz 
wget -c https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.13/hdf5-1.13.2/src/hdf5-1.13.2.tar.gz
wget -c https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz -O netcdf-c-4.9.0.tar.gz
wget -c https://downloads.unidata.ucar.edu/netcdf-fortran/4.6.0/netcdf-fortran-4.6.0.tar.gz
wget -c  http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-1.900.1.zip
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
# Curl
cd $WRFCHEM_HOME/Downloads
tar  -xvzf curl-8.1.2.tar.gz
cd curl-8.1.2
./configure --prefix=$DIR/curl --with-zlib=$DIR/zlib --without-ssl
make -j4
make install
#----------------------------------------------------------
# hdf5 library for netcdf4 functionality
cd $WRFCHEM_HOME/Downloads
tar -xvzf  hdf5-1.13.2.tar.gz
cd hdf5-1.13.2
./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran
make 
make install
#---------------------------------------------------------- 	
# NETCDF C Library
cd $WRFCHEM_HOME/Downloads
tar -xzvf netcdf-c-4.9.0.tar.gz
cd netcdf-c-4.9.0/
./configure --prefix=$DIR/NETCDF --disable-dap
make 
make install
#----------------------------------------------------------
# NetCDF fortran library
cd $WRFCHEM_HOME/Downloads
tar -xvzf netcdf-fortran-4.6.0.tar.gz
cd netcdf-fortran-4.6.0
./configure --prefix=$DIR/NETCDF --disable-shared
make
make install
#----------------------------------------------------------
# MPICH
cd $WRFCHEM_HOME/Downloads
tar -zxvf mpich-4.0.3.tar.gz
cd  mpich-4.0.3/
./configure --prefix=$DIR/MPICH --with-device=ch3 FFLAGS=-fallow-argument-mismatch FCFLAGS=-fallow-argument-mismatch
make 
make install
#----------------------------------------------------------
# LIBPNG
cd $WRFCHEM_HOME/Downloads
tar -xvzf libpng-1.6.39.tar.gz
cd libpng-1.6.39
./configure --prefix=$DIR/grib2
make 
make install
#----------------------------------------------------------
# JasPer
cd $WRFCHEM_HOME/Downloads
unzip jasper-1.900.1.zip
autoreconf -i
./configure --prefix=$DIR/grib2
make
make install
#----------------------------------------------------------
#------------------- Install WRF 4.5  --------------------# 
cd $WRFCHEM_HOME/Downloads

wget -c https://github.com/wrf-model/WRF/releases/download/v4.5/v4.5.tar.gz -O wrf-4.5.tar.gz
tar -xzvf wrf-4.5.tar.gz -C $WRFCHEM_HOME
cd $WRFCHEM_HOME/WRFV4.5

cd chem/KPP
sed -i -e 's/="-O"/="-O0"/' configure_kpp
cd -
sed -i -e 's/if [ "$USENETCDFPAR" == "1" ] ; then/if [ "$USENETCDFPAR" = "1" ] ; then/' configure

./configure # 34, 1 for gfortran and distributed memory
# Complie kpp
./compile 2>&1 | tee compile_kpp.log
# Complie em_real mode
./compile em_real 2>&1 | tee compile_wrf.log
# Compile the WRF-Chem external emissions conversion code
./compile emi_conv 2>1 | tee emission_compile.log

# WPSV4.5
cd $WRFCHEM_HOME/Downloads
wget -c https://github.com/wrf-model/WPS/archive/refs/tags/v4.5.tar.gz -O wps-4.5.tar.gz
tar -xzvf wps-4.5.tar.gz -C $WRFCHEM_HOME
cd $WRFCHEM_HOME/WPS-4.5
./configure # 3, (Linux x86-64) gfortran (dmpar) for gfortran and distributed memory
./compile

 
