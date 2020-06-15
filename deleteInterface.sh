for i in $(seq -w 16 150); do
    echo "vwlan$i"
    sudo iw  vwlan$i del
done
