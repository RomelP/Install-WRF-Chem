#!/bin/bash

#----------------------------------------------------------
# download folder
cd "$WRFCHEM_HOME/DATA" || exit
#----------------------------------------------------------
# download date
echo "Start day !!! "
read -p "year: " year   #year='2023'
read -p "month: " month #month='10'
read -p "day: " day     #day='09' 
#read -p "hour: " hour   #hour='00'
#----------------------------------------------------------
StartDay=$(( ${day#0} ))
EndDay=$(( ${day#0} +4 ))
#----------------------------------------------------------
echo "EndDay:" $year$month$EndDay
#----------------------------------------------------------
cycle=(00 06 12 18 00)
for (( i=$StartDay; i<=$EndDay; i++ ))
do
  if [[ $i -lt 10 ]]
  then 
      mkdir ${year}${month}0${i}R
      cd "$WRFCHEM_HOME/DATA/${year}${month}0${i}R" || exit
      # clear previos download
      rm -rf gfs.t*
      #----------------------------------------------------------
      # Download hourly forescast data for the next 5 days
      for j in {0..4}
      do
        if [[ $j -le 3 ]]
        then
            wget -c https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.${year}${month}0${i}/${cycle[j]}/atmos/gfs.t${cycle[j]}z.pgrb2.0p25.f000
        elif [[ $j -gt 3 ]]
        then
            if [[ $i -lt 9 ]]
            then          
                wget -c https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.${year}${month}0$((i+1))/${cycle[j]}/atmos/gfs.t${cycle[j]}z.pgrb2.0p25.f000 -O gfs.t24z.pgrb2.0p25.f000
            elif [[ $i -ge 9 ]]
            then
                wget -c https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.${year}${month}$((i+1))/${cycle[j]}/atmos/gfs.t${cycle[j]}z.pgrb2.0p25.f000 -O gfs.t24z.pgrb2.0p25.f000
            fi
        fi
      done  
      cd ..
  elif [[ $i -ge 10 ]]
  then
      #----------------------------------------------------------
      mkdir ${year}${month}${i}R
      cd "$WRFCHEM_HOME/DATA/${year}${month}${i}R" || exit
      # clear previos download
      rm -rf gfs.t*
      #----------------------------------------------------------
      # Download hourly forescast data for the next 5 days
      for j in {0..4}
      do
        if [[ $j -le 3 ]]
        then   
            wget -c https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.${year}${month}${i}/${cycle[j]}/atmos/gfs.t${cycle[j]}z.pgrb2.0p25.f000
        elif [[ $j -gt 3 ]]
        then
            wget -c https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.${year}${month}$((i+1))/${cycle[j]}/atmos/gfs.t${cycle[j]}z.pgrb2.0p25.f000 -O gfs.t24z.pgrb2.0p25.f000
        fi
      done  
      cd ..
  fi
done 
echo "Out of the loop !!!"
#----------------------------------------------------------
