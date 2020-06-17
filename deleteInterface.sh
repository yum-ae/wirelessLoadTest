for i in $(seq -w 16 40); do
    echo "vwlan$i"
    sudo iw  vwlan$i del
done
