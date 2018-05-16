#!/usr/bin/sh
# retrieves and saves robots.txt from list of sites if file exists 
task(){
    url="$1"
    hostname=$(echo "$url" | sed -e 's|^[^/]*//||' -e 's|/.*$||')
    outputfile="resource/robots.txt/$hostname.txt"

    out=$(curl -s --max-redirs 0 -w "\n%{http_code}" $url"robots.txt")
    http_status="${out##*$'\n'}"
    http_content="${out%$'\n'*}"
    #echo "$http_status":"$http_content" 
    if [[ "$http_status" == "200" ]]; then
        echo "$http_content" > $outputfile
    fi 
}

export -f task
rm -f resource/robots.txt/*
parallel -j5 --verbose task {} ::: $(cat sites/sites.sarawak.gov.my.txt)
