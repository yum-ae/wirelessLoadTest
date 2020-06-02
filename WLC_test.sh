SSID="SiteSurvey2"

for i in $(seq -w 16 216); do
    echo "vwlan$i"
    hex=$(echo "obase=16; $i" | bc)
    echo "aa:bb:cc:dd:ee:"$hex
    sudo iw phy0 interface add vwlan$i type managed addr aa:bb:cc:dd:ee:$hex
done
# After interface activation, it requires about 9 seconds to connect to an AP
sleep 10
for i in $(seq -w 16 216); do
    #error handling try 3 times
    sudo nmcli device wifi connect $SSID ifname vwlan$i &
    echo "exit with "$?
    sleep 2
done
# to delete interface `sudo iw dev vwlan0 del`

# write out csv to be used in JMeter
ip -4 a | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v "127.0.0.1" > ipaddr.csv