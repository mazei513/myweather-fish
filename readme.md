# myweather.fish

Will get a 7-day weather forecast from data.gov.my API and prints it out. As per their
[documentation](https://developer.data.gov.my/realtime-api/weather), the data only updates once a
day. This function will try to reuse the current day's response.

```
# Columns are date, morning, afternoon, night, min temp, max temp
> myweather
2026-02-28 ☀️ ☀️ ☀️ 23 33
2026-02-27 🌧️ ⛈️ ☀️ 23 33
2026-02-26 ☀️ ☀️ ☀️ 23 33
2026-02-25 ☀️ ⛈️ ☀️ 23 33
2026-02-24 ☀️ ⛈️ ⛈️ 23 33
2026-02-23 ☀️ ☀️ 🌧️ 23 33
2026-02-22 ☀️ ⛈️ 🌧️ 23 33
```

It's an 18 line function, modify it to suit your needs, e.g. add `sort` on the output to have it
be ascending.

## Installation

Apart from GNU tools, `curl` and `jq` is required.

It's a single file, copy/download it and place it in `~/.config/fish/functions/myweather.fish`.

```fish
# install deps with package manager
sudo apt install curl jq # Debian/Ubuntu
sudo dnf install curl jq # Fedora/RHEL
sudo pacman -S curl jq # Arch
yay -S curl jq # Arch with yay

# download script
curl https://raw.githubusercontent.com/mazei513/myweather-fish/refs/heads/main/myweather.fish > ~/.config/fish/functions/myweather.fish
```

## Setting up location ID

The location ID needs to be set in `~/.config/myweather/loc_id`. To get a list of location IDs, run
the following:

```fish
curl -s -L 'https://api.data.gov.my/weather/forecast' | \
  jq '[.[].location | {"key": .location_id, "value": .location_name}] | from_entries'
```

Then store the location ID into `~/.config/myweather/loc_id`.

```fish
# for example with St009 (WP Kuala Lumpur)
mkdir -p ~/.config/myweather
echo St009 > ~/.config/myweather/loc_id
```
