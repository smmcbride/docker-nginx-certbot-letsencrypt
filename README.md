## LetsEncrypt Utility

### Note: *Your machine must be accessible on port 80 from the internet*

Clone this repo onto your server

Copy `env.example` to `.env` file and replace the values with your server's domain and email address.

Verify functionality, run:
```
docker-compose up
```
and visit your IP or domain name in a browser. You should see the Nginx welcome screen.

Helpful resources when generating this project:
* https://medium.com/@agusnavce/nginx-server-with-ssl-certificates-with-lets-encrypt-in-docker-670caefc2e31
* https://unix.stackexchange.com/questions/294378/replacing-only-specific-variables-with-envsubst/294400#294400
* https://mindsers.blog/post/https-using-nginx-certbot-docker/

