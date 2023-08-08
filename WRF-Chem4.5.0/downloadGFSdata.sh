#!/bin/sh

#----------------------------------------------------------
# download folder
cd "$WRFCHEM_HOME/DATA" || exit
#----------------------------------------------------------
# download date
echo "date today!!! "
read -p "year: " year   #year='2023'
read -p "month: " month #month='08'
read -p "day: " day     #day='08' 
read -p "hour: " hour   #hour='00'
#----------------------------------------------------------
# clear previos download
rm -rf gfs.t${hour}z*
#----------------------------------------------------------
# Download hourly forescast data for the next 2 days
fHour=0
while [ $fHour -le 24 ]
do
  [ $fHour -lt 10 ] && k='00' || k='0'
  wget -c https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.${year}${month}${day}/${hour}/atmos/gfs.t${hour}z.pgrb2.0p25.f${k}${fHour}
  fHours=$(($fHour+1))
done
echo "Out of the loop !!!"
#----------------------------------------------------------
