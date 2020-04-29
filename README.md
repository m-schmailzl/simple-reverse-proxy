![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/schmailzl/simple-reverse-proxy)
![GitHub issues](https://img.shields.io/github/issues-raw/m-schmailzl/simple-reverse-proxy)
![License](https://img.shields.io/github/license/m-schmailzl/simple-reverse-proxy)
![Docker Image Size (amd64)](https://img.shields.io/docker/image-size/schmailzl/simple-reverse-proxy/amd64)
![Docker Pulls](https://img.shields.io/docker/pulls/schmailzl/simple-reverse-proxy)
![Docker Stars](https://img.shields.io/docker/stars/schmailzl/simple-reverse-proxy)

This Docker container listens on port 80 and allows to proxy any internal or external website.

For example, the container can be used to make a device on the local network available on the internet without exposing it directly.

The container is meant to be used with another reverse proxy which handles encryption (e.g. [jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/)).

# Features

- Allows proxying any website via HTTP and HTTPS

- HTTP Basic authentication as an additional layer of security

- Small and lightweight

- Fully configurable via environment variables

# Usage

You have to set at least `PROXY_URL`.

**Example:** `$ docker run -d -e PROXY_URL=https://example.com schmailzl/simple-reverse-proxy`

## Environment variables

* `PROXY_URL` - The url you want to proxy

#### HTTP authentication

HTTP Basic authentication will be enabled if you set `PROXY_AUTH_USER` and/or `PROXY_AUTH_FILE`.

* `PROXY_AUTH_USER` - The username you have to enter when trying to connect

* `PROXY_AUTH_PASSWORD` - The password you have to enter when trying to connect

* `PROXY_AUTH_MESSAGE` - The message the browser will show when trying to connect (default: "Please login:")

* `PROXY_AUTH_FILE` - If you don't want to set the authentication credentials by environment variables, you can bind your own htpasswd file to the container and set the new path. (default: "/etc/nginx/.htpasswd")

## Docker Compose

The container is meant to be used with another reverse proxy which handles encryption (e.g. [jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/)).

A sample docker-compose.yml could look like this:

```yaml
version: '3'
services:
  proxy:
    image: schmailzl/simple-reverse-proxy
    restart: unless-stopped
    environment:
      VIRTUAL_HOST: mydomain.com
      PROXY_URL: http://192.168.178.1
```
