# Test image. Alpine image alpine:3.21.3

Testing support for builds for several architectures of a docker image.


## not working

. docker compose restart

. the rc-service start | stop | restart 


## tasks

. trap and wait feature.





## install
after git clone:

```bash
cd "docker/buildx_env_lib"
git clone https://version.jaisocx.com:2465/BashPackages/env_miniobjects.git
```



## Groups and Users

Groups and users set in .env

## Passwords
The password for the root user is stored in the ROOT_HASHED_PWD variable.

```
mkpasswd -m sha-512 "plaintext_password"
```





## Build docker image

. drop container if was built

. drop the docker image of the same version

. bash image_build.sh

. docker compose up --build

------
. ctrl c

. docker compose start

. docker compose exec app_via_image bash

. whoami




## Enter dockerized service

```
docker compose exec app_via_image bash
$: whoami
user

docker compose exec -u login app_via_image bash
$: whoami
login
```





