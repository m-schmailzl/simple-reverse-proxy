FROM nginx:stable-alpine AS module-build

WORKDIR /tmp
RUN apk add --no-cache bash tar curl gnupg ca-certificates git gcc g++ pcre pcre-dev zlib zlib-dev make && \
    export nginx_version=$(nginx -v 2>&1 | awk '{split($0, a); print a[3]}' | awk '{split($0, a, "/"); print a[2]}') && \
    git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module.git && \
    curl https://nginx.org/download/nginx-$nginx_version.tar.gz -o nginx.tar.gz && \
    echo https://nginx.org/download/nginx-$nginx_version.tar.gz && \
    tar -xzvf nginx.tar.gz && \
    cd nginx-$nginx_version && ./configure --with-compat --with-ld-opt='-lpcre' --add-dynamic-module=../ngx_http_substitutions_filter_module && make modules && \
    cp /tmp/nginx-$nginx_version/objs/ngx_http_subs_filter_module.so /tmp/ngx_http_subs_filter_module.so

FROM nginx:stable-alpine
LABEL maintainer="maximilian@schmailzl.net"

RUN apk add --no-cache bash apache2-utils ca-certificates pcre

COPY --from=module-build /tmp/ngx_http_subs_filter_module.so /etc/nginx/modules/
COPY entrypoint.sh /
COPY nginx.conf /
RUN chmod +x /entrypoint.sh

ENV PROXY_AUTH_MESSAGE="Please login:" PROXY_SSL_VERIFY="on" LOCATION="/" ADDITIONAL_CONFIG=""

ENTRYPOINT ["/entrypoint.sh"]
