## LetsEncrypt Utility

### Note: *Your machine must be accessible on port 80 from the internet*

Clone this repo onto your server

Create an `.env` file with the following contents, replacing `example.com` with your domain name:

```
LETSENCRYPT_DOMAIN=example.com
```

Verify functionality, run:
```
docker-compose up
```
and visit your IP or domain name in a browser. You should see the Nginx welcome screen.

Helpful resources when generating this project:
* https://medium.com/@agusnavce/nginx-server-with-ssl-certificates-with-lets-encrypt-in-docker-670caefc2e31
* https://unix.stackexchange.com/questions/294378/replacing-only-specific-variables-with-envsubst/294400#294400

