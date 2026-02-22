function myweather
    set API_URL "https://api.data.gov.my/weather/forecast"
    set LOC_ID_FILE ~/.config/myweather/loc_id
    set LOC_ID (cat $LOC_ID_FILE)
    if test -z $LOC_ID
        echo "Set location ID at $LOC_ID_FILE, do the following to get locations"
        echo "  curl -s -L '$API_URL' | jq '[.[].location | {\"key\": .location_id, \"value\": .location_name}] | from_entries'"
        return 1
    end

    set CACHE_PATH ~/.cache/myweather
    mkdir -p $CACHE_PATH
    set CACHE_FILE "$CACHE_PATH/cached.json"
    if not test -e $CACHE_FILE || test (math (date -d 0 +%s) - (path mtime $CACHE_FILE)) -ge 0
        curl -s -L "$API_URL?contains=$LOC_ID@location__location_id" >$CACHE_FILE
    end
    jq -r '.[] | [.date, .morning_forecast, .afternoon_forecast, .night_forecast, .min_temp, .max_temp] | @csv' $CACHE_FILE | sed 's/Tiada hujan/☀️/g' | sed 's/Hujan/🌧️/g' | sed 's/Ribut petir/⛈️/g' | sed 's/"//g' | sed 's/,/ /g'
end
