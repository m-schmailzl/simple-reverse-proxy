#!/bin/bash
# Replaces parts of the nginx.conf with values of environment variables

if [ -z "$PROXY_URL" ]
then
	echo "ERROR: You need to set PROXY_URL."
	exit 1
fi

if [ -z "$PROXY_AUTH_USER" ]
then
	if [ -z "$PROXY_AUTH_FILE" ]
	then
		export PROXY_AUTH_BASIC_LINE=""
		export PROXY_AUTH_BASIC_USER_FILE_LINE=""
	else
		export PROXY_AUTH_BASIC_LINE="auth_basic \"$PROXY_AUTH_MESSAGE\";"
		export PROXY_AUTH_BASIC_USER_FILE_LINE="auth_basic_user_file $PROXY_AUTH_FILE;"
	fi
else
	if [ -z "$PROXY_AUTH_PASSWORD" ]
	then
		echo "ERROR: PROXY_PASSWORD cannot be empty when PROXY_USER is set."
		exit 2
	fi
	
	export PROXY_AUTH_BASIC_LINE="auth_basic \"$PROXY_AUTH_MESSAGE\";"
	export PROXY_AUTH_BASIC_USER_FILE_LINE="auth_basic_user_file $PROXY_AUTH_FILE;"
	
	htpasswd -b -c "$PROXY_AUTH_FILE" "$PROXY_AUTH_USER" "$PROXY_AUTH_PASSWORD"
fi

echo "Generating configuration..."
envsubst < /nginx.conf | sed -e 's/§/$/g' > /etc/nginx/nginx.conf

echo "Starting NGINX..."

nginx -g "daemon off;"