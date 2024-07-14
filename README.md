# Run remote Chromium browser inside docker and access it from local browser

## Set Up

### Prerequirment
 * [Install docker-compose](https://docs.docker.com/compose/install/#install-compose).



### Run without domain setup
Comment out all nginx and certbot service inside "docker-compose.yaml" file
Or replace the content of "docker-compose.yaml" file with this: 
```yaml
services:
  chromium:
    build: .
    container_name: chromium
    restart: unless-stopped
    security_opt:
      - seccomp:unconfined #optional
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - CHROME_CLI=https://www.google.com/ #optional
    volumes:
      - ./data/chromium/config:/config
    ports:
      - 3000:3000
    shm_size: "1gb"
```

Now run the container using docker compose
```bash
sudo docker compose up
```

Now visit the URL "localhost:3000"

### Run with domain setup
1. Add a A record on your domain pointing to your server IP address
2. Clone this repository
3. Modify configuration:
- Add domains and email addresses to init-letsencrypt.sh
- Replace all occurrences of "chromium.akashdeep.pro" with primary domain (the first one you added to init-letsencrypt.sh) in data/nginx/app.conf

4. Generate lets-encriypt ssl certificate by running:

        sudo bash ./init-letsencrypt.sh
5. Now run the container using docker compose
        
        sudo docker compose up

Now visit https://yourdomain.com


#### All application settings are passed via environment variables for chromium container:

| Variable | Description |
| :----: | --- |
| CUSTOM_USER | HTTP Basic auth username, abc is default. |
| PASSWORD | HTTP Basic auth password, abc is default. If unset there will be no auth |
| TITLE | The page title displayed on the web browser, default "Chromium". |
| CHROME_CLI | The URL that will be opened by default when launching chromium. |
| LC_ALL | Set the Language for the container to run as IE `fr_FR.UTF-8` `ar_AE.UTF-8` |
| NO_DECOR | If set the application will run without window borders for use as a PWA. (Decor can be enabled and disabled with Ctrl+Shift+d) |
| NO_FULL | Do not autmatically fullscreen applications when using openbox. |


 

