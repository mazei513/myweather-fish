function myweather
    set LOC_ID_PATH ~/.config/myweather/loc_id
    set LOC_ID (cat ~/.config/myweather/loc_id)
    if test -z $LOC_ID
        echo "Set location ID at $LOC_ID_PATH, do the following to get locations"
        echo "  curl --location 'https://api.data.gov.my/weather/forecast' --silent | jq '[.[].location | {\"key\": .location_id, \"value\": .location_name}] | from_entries'"
        return 1
    end

    mkdir -p ~/.cache/myweather
    set CACHE_PATH ~/.cache/myweather/cached.json
    if not test -e $CACHE_PATH || test (math (date -d 0 +%s) - (path mtime $CACHE_PATH)) -ge 0
        curl --location "https://api.data.gov.my/weather/forecast?contains=$LOC_ID@location__location_id" >$CACHE_PATH
    end
    jq -r '.[] | [.date, .morning_forecast, .afternoon_forecast, .night_forecast, .min_temp, .max_temp] | @csv' $CACHE_PATH | sed 's/Tiada hujan/☀️/g' | sed 's/Hujan/🌧️/g' | sed 's/Ribut petir/⛈️/g' | sed 's/"//g' | sed 's/,/ /g'
end
