# Launch a secure web server on an AWS EC2 instance 

This tutorial explains how to configure a bare-bones AWS EC2 instance and 
launch a secure web server using `docker-nginx-certbot-letsencrypt`.

## Prerequisites
* A domain on a domain name provider, with access to update DNS records.
* An AWS account with access to create/update resources.

## Configure and launch a new instance 
![ami](https://user-images.githubusercontent.com/2528364/146795933-59838d8b-1390-4b4d-9d48-eb8687b63ebc.png)

From the AWS console, launch a new instance using the Amazon Linux 2 AMI. The 
version at the time of this writing is `5.1.0`.

In the security groups, make sure the inbound rules include `HTTP` and `HTTPS`
or web traffic will not reach the new server.
![security-group](https://user-images.githubusercontent.com/2528364/146796376-4f457356-6b0a-48c2-9e5c-cccbc7e61bee.png)


## Update the DNS records for your domain.

The **Instance Summary** screen for your instance will provide the Public IP 
Address of your instance.
![instance_details](https://user-images.githubusercontent.com/2528364/146796049-72824d72-569f-41ef-a4b3-b69c2662bb1f.png)

Log in to the DNS provider for your domain and generate the appropriate **A** 
records to route your domain to the new server. The screen should look something
like this:
![dns](https://user-images.githubusercontent.com/2528364/146795984-55f43649-1c15-42d9-9c6a-c5e737c29712.png)

## Configure the server

The **Connect** tab from the instance will detail ways to log in to your server. 
Connect through either the `EC2 Instance Connect` portal or by following the 
`SSH Client` instructions.

You should arrive at a prompt that looks something like this:

```shell
Last login: Fri Dec 17 20:56:02 2021 from 00.01.2.345

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
31 package(s) needed for security, out of 65 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-987-65-43-210 ~]$
```

#### Update the server

```shell
[ec2-user@ip-987-65-43-210 ~]$ sudo yum update
```

#### Install git and docker

```shell
[ec2-user@ip-987-65-43-210 ~]$ sudo yum install git docker
```

Verify that git and docker were successfully installed

```shell
[ec2-user@ip-987-65-43-210 ~]$ git --version
git version 2.32.0

[ec2-user@ip-987-65-43-210 ~]$ docker --version
Docker version 20.10.7, build f0df350
```

#### Install docker-compose
Docker-compose can be installed from a package on GitHub. these instructions 
install version `2.2.2` of docker-compose built for linux x86_64 systems. Verify
that your system is compatable with the following command:

```shell
[ec2-user@ip-987-65-43-210 ~]$ uname -s -m
Linux x86_64
```

If your system does not match the above, make sure to update the following url 
to download the correct version

```shell
[ec2-user@ip-987-65-43-210 ~]$ sudo curl -L https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
[ec2-user@ip-987-65-43-210 ~]$ sudo chmod +x /usr/local/bin/docker-compose

[ec2-user@ip-987-65-43-210 ~]$ docker-compose version
Docker Compose version v2.2.2
```

#### Update docker permissions and reboot
We want `ec2-user` to be able to run docker without being `root` so we need to 
update a couple of configurations and reboot.

```shell
[ec2-user@ip-987-65-43-210 ~]$ sudo chkconfig docker on
[ec2-user@ip-987-65-43-210 ~]$ sudo usermod -aG docker $USER
[ec2-user@ip-987-65-43-210 ~]$ sudo reboot

[~ ]
```

## Install and run docker-nginx-certbot-letsencrypt
Once the reboot is complete, log back into your server and use git to download 
the docker-nginx-certbot-letsencrypt project

```shell

[ec2-user@ip-987-65-43-210 ~]$ git clone https://github.com/smmcbride/docker-nginx-certbot-letsencrypt.git

Cloning into 'docker-nginx-certbot-letsencrypt'...
remote: Enumerating objects: 68, done.
remote: Counting objects: 100% (68/68), done.
remote: Compressing objects: 100% (47/47), done.
remote: Total 68 (delta 34), reused 51 (delta 17), pack-reused 0
Receiving objects: 100% (68/68), 12.26 KiB | 4.09 MiB/s, done.
Resolving deltas: 100% (34/34), done.

[ec2-user@ip-987-65-43-210 ~]$ cd docker-nginx-certbot-letsencrypt/
```

Generate the required `.env` file. Replace the example values with your real 
domain and email address.

```shell
[ec2-user@ip-987-65-43-210 docker-nginx-certbot-letsencrypt]$ echo LETSENCRYPT_DOMAIN=example.com >>.env
[ec2-user@ip-987-65-43-210 docker-nginx-certbot-letsencrypt]$ echo LETSENCRYPT_EMAIL=name@example.com >>.env
```

Run the HTTP server and verify you can see the URL in the browser

```shell

[ec2-user@ip-987-65-43-210 docker-nginx-certbot-letsencrypt]$ make http
```

![screen1](https://user-images.githubusercontent.com/2528364/146796147-25f6cff7-7df7-4399-a570-92dca62715d2.png)

Generate a staging certificate, load the HTTPS server and verify the
certificate is being properly implemented. The browser should produce a warning 
that the site is not secure. This is what we want.

```shell
[ec2-user@ip-987-65-43-210 docker-nginx-certbot-letsencrypt]$ make staging_cert
[ec2-user@ip-987-65-43-210 docker-nginx-certbot-letsencrypt]$ make https
```

![screen2](https://user-images.githubusercontent.com/2528364/146796294-a614af7c-37b0-42b6-a056-f33b6a03ba2f.png)

Stop the existing server, create a production certificate, and restart.  If all 
goes well reload the browser and vereify you have a secure web page, with the 
_lock_ icon next to the domain name in the browser.

```shell
[ec2-user@ip-987-65-43-210 docker-nginx-certbot-letsencrypt]$ make production_cert
[ec2-user@ip-987-65-43-210 docker-nginx-certbot-letsencrypt]$ make https
```

![screen3](https://user-images.githubusercontent.com/2528364/146796352-6e709ee2-213e-419f-b380-a65e5b8e4bb0.png)


## Connect to a local application
At this point we have a secured server running and can configure it to point to 
our local application.  For this example we will use 
[docker-react](https://github.com/smmcbride/docker-react), which will build and 
launch a React app through yarn on port 3000:

```shell
[ec2-user@ip-987-65-43-210 docker-nginx-certbot-letsencrypt]$ cd
[ec2-user@ip-987-65-43-210 ~]$ git clone https://github.com/smmcbride/docker-react.git
[ec2-user@ip-987-65-43-210 ~]$ cd docker-react/
[ec2-user@ip-987-65-43-210 docker-react]$ make up
```

Return to the `nginx` project, configure the port and re-launch nginx:

```shell
[ec2-user@ip-987-65-43-210 docker-react]$ cd
[ec2-user@ip-987-65-43-210 ~]$ cd docker-nginx-certbot-letsencrypt/
[ec2-user@ip-987-65-43-210 docker-nginx-certbot-letsencrypt]$ echo APPLICATION_PORT=3000 >>.env
```

Launch a secure `nginx` proxy pointed to the local application's port:
```shell
make https_app
```



