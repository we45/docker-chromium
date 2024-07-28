# Run remote Chromium browser inside docker and access it from local browser

## Set Up

### Prerequirment
 * [Install docker-compose](https://docs.docker.com/compose/install/#install-compose).



### Run without nginx setup

```bash
sudo docker compose -f docker-compose-standalone.yaml up
```

Now visit the URL "https://localhost:8443"

### Run with domain setup with nginx
1. Add a A record on your domain pointing to your server IP address
2. Clone this repository
3. Modify configuration:
- Add domains and email addresses to init-letsencrypt.sh
- Replace all occurrences of "chromium.akashdeep.pro" with primary domain (the first one you added to init-letsencrypt.sh) in data/nginx/app.conf
- Change staging variable (`staging=1`) to 0 for production otherwise keep 1 if you're testing your setup to avoid hitting request limits.


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


 

