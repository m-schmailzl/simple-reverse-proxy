FROM nginx:1.21-alpine
LABEL maintainer="maximilian@schmailzl.net"

RUN apk add --no-cache bash apache2-utils ca-certificates

COPY entrypoint.sh /
COPY nginx.conf /
RUN chmod +x /entrypoint.sh

ENV PROXY_AUTH_MESSAGE="Please login:" PROXY_SSL_VERIFY="on"

ENTRYPOINT ["/entrypoint.sh"]
