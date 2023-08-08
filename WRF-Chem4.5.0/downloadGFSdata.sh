#!/bin/sh

#----------------------------------------------------------
# download folder
cd "$WRFCHEM_HOME/DATA" || exit

# download date
year='2023'
month='08'
day='08' 
hour='00'

# clear previos download
rm -rf gfs.t${hour}z*
#----------------------------------------------------------
# Download hourly forescast data for the next 2 days

fHour=0
while [ $fHour -le 24 ]
do
    [ $fHour -lt 10 ] && k='00' || k='0'
    wget -c https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.${year}${month}${day}/${hour}/atmos/gfs.t${hour}z.pgrb2.0p25.f${k}${fHour}
    fHours=$(($fHour + 1))
done
echo "Out of the loop !!!"
#----------------------------------------------------------
