# docker-nginx-certbot-letsencrypt

Enable HTTPS on your server with Nginx, Docker & Certbot (from LetsEncrypt!)

## Prerequisites

1. You should already own the domain you're wanting to secure, and have the 
   appropriate `A` or `CNAME` records pointing to your servers IP address.
   
2. You should have SSH access to the server on which you're trying to generate a
   security certificate, and be logged in.
   
3. You should have `docker-compose` installed and working properly on your 
   server.


# Using this project:

The files in this project are broken into groups, which configure and 
launch an HTTP or HTTPS server in variouos configuration.

The first three Steps below will launch an Nginx server with port 80 (HTTP) 
configured to respond to certbot's challenge request, and allow you to generate 
a certificate in either production or staging mode.

The third step will launch an Nginx server with port 443 (HTTPS) configured using
the new certificate, and programmed to reroute insecure traffic from port 80 to 
port 443.

There is a Makefile to run the appropriate `docker-compose` commands.  The 
available commands can be discovered by simply running `make` from your command 
line.


### Step 1: Create environment variables

Copy the `env.example` file to `.env` and replace the values with your server's 
domain and email address.

Required variables:
* `LETSENCRYPT_DOMAIN` the domain name (_i.e._ `example.com`)
* `LETSENCRYPT_EMAIL` the administrator email (_i.e._ `username@example.com`)

Optional variables:
* `APPLICATION_PORT` the port of your web application _if_ running locally.


### Step2: Sanity check your server and domain configuration

Run the following command to build and launch the HTTP server.

```shell
make http
```

Access your server's URL in a browser, you should expect to see a simple webpage
with the name of this project letting you know the server is functioning 
properly. If this screen does not appear you've got some debugging to do.

If successful, press `Ctrl-C` to stop the server and proceed.


### Step 3:  Generate a certificate

LetsEncrypt has [rate limits](https://letsencrypt.org/docs/rate-limits/) in 
place for production (real) certificates, so it's a good idea to test 
this step with a staging certificate first.

#### Staging

Run the following command to launch the Certbot container and request a 
_staging_ certificate.

```shell
make staging_cert
```

#### Production

If you're feeling lucky (or you've previously completed this step with a staging 
certificate) and are ready to generate a _real_ certificate, run the following
command to launch the Certbot container and request a _production_ certificate.  

```shell
make production_cert
```

If this completes successfully, Certbot will have written a `certbot` folder in 
your system containing the certificate files.

Note:  These files contain _**secret keys**_ which should not leave your server,
so don't go pasting them into an email/slack for anyone to see.


### Step 4: Verify the certificate

If **Step 3** completes successfully you are ready to re-build your Nginx 
container and launch the HTTPS configuration to verify the certificate. The 
server from the previous step is likely still running, so execute the following 
commands to stop, rebuild, and re-deploy the Nginx server.

```shell
make https
```

Visit your domain again. You should be re-directed to the HTTPS domain. 

If you've generated a staging token, your browser should now raise a warning 
that your site is not secure. THIS IS GOOD! It means that the server is 
successfully consuming your certificate. You should repeat **Step 3** and 
request a production certificate.

If you've generated a production token, you should see the same HTML page as 
before, but your browser should now indicate that your site is secure.  
Congratulations, you've got a working SSL certificate for your domain!


### Step 5: What's next?

Stop the server with:
```shell
make down
```

Your working directory now contains a folder named `certbot` with the 
certificate files. These files can by copied into your configuration as-needed,
_or_, if your application is running on the same machine, continue with this 
project to run a secured nginx proxy to the local application.

```shell
make https_app
```

Reload the website and (if the local application is running properly) you should
see your application served securely through this proxy.


### Example Usage:

[Install this project on an AWS EC2 instance](aws_ec2/README.md)


### TODO:

* Provide further documentation and examples for refreshing the certificate 
  before it expires.
* When using this to proxy to a local application, share the static folder so
  nginx can serve those directly.


## Acknowledgements

This project co-ordinates the activity of several free and open-source projects,
namely [Nginx](https://nginx.org/en/), [Docker](https://www.docker.com/), 
[LetsEncrypt](https://letsencrypt.org/), and [Certbot](https://certbot.eff.org/)
. Thanks to all who develop these projects for their invaluable services.

This project is a learning exercise for me in my own technical journey, and I 
found these resources extremely valuable while developing this project:

* [HTTPS using Nginx and Let's encrypt in Docker](
https://mindsers.blog/post/https-using-nginx-certbot-docker/)

* [NGINX server with SSL certificates with Let’s Encrypt in Docker](
https://medium.com/@agusnavce/nginx-server-with-ssl-certificates-with-lets-encrypt-in-docker-670caefc2e31)

* [Replacing only specific variables with envsubst](
https://unix.stackexchange.com/questions/294378/replacing-only-specific-variables-with-envsubst/294400#294400)
