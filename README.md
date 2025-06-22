# homepage_bunkerweb_widget
gethomepage widget for the bunkerweb web application firewall

![brave_6gXEwL8w7c](https://github.com/user-attachments/assets/a8289f55-7a70-4cea-a4a7-a47e8f61ff99)

displays total number of requests, number of requests that have been blocked, number of current bans, and the dominant origin country (for blocked requests).

# setup

- clone repo
- `chmod +x stats_json.sh`
- edit WorkingDirectory & ExecStart in `bunkerweb_homepage.service`
- move .service & .timer to `/etc/systemd/system`
- enable systemd .service and .timer
- verify `bunkerweb_stats.json` is generated in `/var/www/json`

## add new `bunkerweb_stats.conf` config via bunkerweb ui
```
server {
    listen 127.0.0.1:19732;  # Only listen on localhost interface
    server_name bunkerweb_stats;
    
    root /var/www/json;  # Directory containing your JSON file
    
    location = /bunkerweb_stats.json {
        default_type application/json;
        add_header Access-Control-Allow-Origin *;
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        try_files /bunkerweb_stats.json =404;
    }

    # Block all other requests
    location / {
        return 404;
    }

    # Disable logging
    access_log off;
    error_log /dev/null;
}
```

## add to homepage `services.yaml`
```
- BunkerWeb:
      icon: bunkerweb.png
      description: 'Web Application Firewall'
      widget:
        type: customapi
        url: http://127.0.0.1:19732/bunkerweb_stats.json
        refreshInterval: 15000
        mappings:
          - field: total
            label: "Total"
            format: number
          - field: blocked
            label: "Blocked"
            format: number
          - field: bans
            label: "Bans"
            format: number
          - field: dom_origin
            label: "Dom Origin"
            format: text
```
