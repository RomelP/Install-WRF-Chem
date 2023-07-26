# Emplear los siguientes comando para editar ambiente UNIX:


#________________________________________________
#para abrir el archivo a editar:

#sudo vim ~/.bashrc # for all users
# vim ~/.profile # for user alone
#________________________________________________
#Incluir al final las siguientes lineas:
#________________________________________________
# Compilers
export HOME=`cd;pwd`
export DIR=$HOME/Build_WRF/LIBRARIES
export CC=gcc
export CXX=g++
export FC=gfortran
#________________________
# hdf5
export PATH=$DIR/hdf5/bin:$PATH
export LD_LIBRARY_PATH=$DIR/hdf5/lib:$LD_LIBRARY_PATH
#________________________
# NETCDF C and NetCDF fortran
export PATH=$DIR/netcdf/bin:$PATH
export NETCDF=$DIR/netcdf
export LD_LIBRARY_PATH=$DIR/netcdf/lib:$LD_LIBRARY_PATH
#________________________
# MPICH
export PATH=$DIR/mpich/bin:$PATH
#________________________
# libpng
#________________________
# JasPer
export PATH=$DIR/jasper/bin:$PATH
export LD_LIBRARY_PATH=$DIR/jasper/lib:$LD_LIBRARY_PATH
#________________________
# WRF v4.4
ulimit -s unlimited
export MALLOC_CHECK_=0
export EM_CORE=1
export NMM_CORE=0
export WRF_CHEM=1
export WRF_KPP=1
export YACC='/usr/bin/yacc -d'
export FLEX=/usr/bin/flex
export FLEX_LIB_DIR=/usr/lib/x86_64-linux-gnu
export KPP_HOME=$HOME/Build_WRF/WRFV4.4/chem/KPP/kpp/kpp-2.1 
export WRF_SRC_ROOT_DIR=$HOME/Build_WRF/WRFV4.4
export PATH=$KPP_HOME/bin:$PATH
export SED=/usr/bin/sed
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
# WPS-4.4
export JASPERLIB=$DIR/jasper/lib 
export JASPERINC=$DIR/jasper/include
#________________________________________________________
# Aplicar los cambios al sistema con le siguiente comando:
# source ~/.bashrc
