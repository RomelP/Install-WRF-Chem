# Emplear los siguientes comando para editar ambiente UNIX:


#________________________________________________
#para abrir el archivo a editar:

#sudo vim ~/.bashrc
#________________________________________________
#Incluir al final las siguientes lineas:

(...)

# Compilers
export DIR=/home/Build_WRF/LIBRARIES
export CC=gcc
export CXX=g++
export FC=gfortran
# hdf5
export PATH=$DIR/hdf5/bin:$PATH
export LD_LIBRARY_PATH=$DIR/hdf5/lib:$LD_LIBRARY_PATH
# NETCDF C
export CFLAGS=-fPIC 
export CPPFLAGS=-I/$DIR/hdf5/include 
export CPPFLAGS=-I/$DIR/curl/include 
# NetCDF fortran
export CPPFLAGS=-I/$DIR/netcdf/include
export LDFLAGS=-L/$DIR/netcdf/lib 
export FCFLAGS=-m64

export PATH=$DIR/netcdf/bin:$PATH
export NETCDF=$DIR/netcdf
export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH
# MPICH
export PATH=$DIR/mpich/bin:$PATH
export FFLAGS=-fallow-argument-mismatch 
export FCFLAGS=-fallow-argument-mismatch 
# libpng
export CPPFLAGS=-I/$DIR/netcdf/include 
export LDFLAGS=-L$DIR/netcdf/lib
export FCFLAGS='-m64'
# JasPer
export PATH=$DIR/jasper/bin:$PATH
export LD_LIBRARY_PATH=$DIR/jasper/lib:$LD_LIBRARY_PATH

# WRF v4.4
export WRF_DIR=$HOME/Build_WRF/WRFV4.4
export MALLOC_CHECK_=0
export EM_CORE=1
export NMM_CORE=0
export WRF_CHEM=1
export WRF_KPP=1
export YACC='/usr/bin/yacc -d'
export FLEX=/usr/bin/flex
export FLEX_LIB_DIR=/usr/lib/x86_64-linux-gnu
export KPP_HOME=/home/Build_WRF/WRFV4.4/chem/KPP/kpp/kpp-2.1 
export WRF_SRC_ROOT_DIR=/home/Build_WRF/WRFV4.4
export PATH=$KPP_HOME/bin:$PATH
export SED=/usr/bin/sed
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
# WPS-4.4
export JASPERLIB=/home/Build_WRF/LIBRARIES/jasper/lib 
export JASPERINC=/home/Build_WRF/LIBRARIES/jasper/include
#________________________________________________________
# Aplicar los cambios al sistema con le siguiente comando:
# source ~/.bashrc
