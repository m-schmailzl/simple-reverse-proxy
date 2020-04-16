FROM nginx:1.17-alpine

RUN apk add --no-cache bash apache2-utils ca-certificates

COPY entrypoint.sh /
COPY nginx.conf /
RUN chmod +x /entrypoint.sh

ENV PROXY_AUTH_MESSAGE Please login:
ENV PROXY_AUTH_FILE /etc/nginx/.htpasswd

ENTRYPOINT ["/entrypoint.sh"]
