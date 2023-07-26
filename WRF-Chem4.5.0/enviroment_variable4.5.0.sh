# Emplear los siguientes comando para editar ambiente UNIX:


#________________________________________________
#para abrir el archivo a editar:

#sudo vim ~/.bashrc
#________________________________________________
#Incluir al final las siguientes lineas:

#(...)

export HOME=`cd;pwd`
# Compilers
export WRFCHEM_HOME=$HOME/Models/WRF-Chem
export DIR=$WRFCHEM_HOME/Libs
export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran
# hdf5
export HDF5=$DIR/grib2
export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
# NETCDF C
export CPPFLAGS=-I$DIR/grib2/include
export LDFLAGS=-L$DIR/grib2/lib
#
export PATH=$DIR/NETCDF/bin:$PATH
export NETCDF=$DIR/NETCDF
# NetCDF fortran
export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
export CPPFLAGS=-I$DIR/NETCDF/include
export LDFLAGS=-L$DIR/NETCDF/lib
# MPICH
export PATH=$DIR/mpich/bin:$PATH
# libpng
export LDFLAGS=-L$DIR/grib2/lib
export CPPFLAGS=-I$DIR/grib2/include
# JasPer
export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include
# WRF v4.5
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
export WRF_DIR=$WRFCHEM_HOME/WRFV4.5
# WPS-4.5
export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include
export PATH=$DIR/bin:$PATH
export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH
#________________________________________________________
# Aplicar los cambios al sistema con le siguiente comando:
# source ~/.bashrc
