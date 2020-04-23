FROM nginx:1.17-alpine

RUN apk add --no-cache bash apache2-utils ca-certificates

COPY entrypoint.sh /
COPY nginx.conf /
RUN chmod +x /entrypoint.sh

ENV PROXY_AUTH_MESSAGE Please login:

ENTRYPOINT ["/entrypoint.sh"]
