#!/bin/bash

#----------------------------------------------------------
# download folder
cd "$WRFCHEM_HOME/DATA" || exit
#----------------------------------------------------------
# download date
echo "date today!!! "
read -p "year: " year   #year='2023'
read -p "month: " month #month='10'
read -p "day: " day     #day='09' 
read -p "hour: " hour   #hour='00'
#----------------------------------------------------------
StartDay=$(( ${day#0} ))
EndDay=$(( ${day#0} +2 ))
echo "EndDay:" $year$month$EndDay
#----------------------------------------------------------
for (( i=$StartDay; i<=$EndDay; i++ ))
do
  if [[ $i -lt 10 ]]
  then 
      mkdir ${year}${month}0${i}
      cd "$HOME/Build_WRF/DATA/${year}${month}0${i}" || exit
      # clear previos download
      rm -rf gfs.t${hour}z*
      #----------------------------------------------------------
      # Download hourly forescast data for the next 5 days
      for (( j = 0 ; j<=2; j++ ))
      do 
        [ $j -lt 10 ] && k='00' || k='0'  
        wget -c https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.${year}${month}0${i}/${hour}/atmos/gfs.t${hour}z.pgrb2.0p25.f${k}${j}
      done  
      cd ..
  elif [[ $i -ge 10 ]]
  then
      #----------------------------------------------------------
      mkdir ${year}${month}${i}
      cd "$HOME/Build_WRF/DATA/${year}${month}${i}" || exit
      # clear previos download
      rm -rf gfs.t${hour}z*
      #----------------------------------------------------------
      # Download hourly forescast data for the next 5 days
      for (( j=0; j<=2; j++ ))
      do 
        [ $j -lt 10 ] && k='00' || k='0'  
        wget -c https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.${year}${month}${i}/${hour}/atmos/gfs.t${hour}z.pgrb2.0p25.f${k}${j}
      done  
      cd ..
  fi
done 
echo "Out of the loop !!!"
#----------------------------------------------------------
