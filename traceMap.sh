#!/bin/bash
# traceMap.sh
# Zac Henderson

echo "enter your destination (ex: www.gov.za): "
read hostn
mapfile -t trace < <( traceroute $hostn )

for i in "${trace[@]}"
do
        echo $i | grep -oP "([0-9]{1,3}\.){3}[0-9]{1,3}" >> IPlist.txt
done

mapfile -t ips < <( uniq --check-chars=7 < IPlist.txt )

output[0]='IP,CountryCode,CountryName,RegionCode,RegionName,City,ZipCode,TimeZone,Latitude,Longitude,MetroCode'
echo ${output[0]} > $hostn.csv

cnt="${#ips[@]}"
for ((i=2;i<cnt;i++))
do 
	output[i-1]=$(curl "freegeoip.net/csv/"${ips[i]})
done 

for e in "${output[@]}"
do
	echo $e >> $hostn.csv
done

rm IPlist.txt
