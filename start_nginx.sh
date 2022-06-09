#!/bin/ash

set -x

cp /etc/nginx/conf.template/nginx.conf /etc/nginx/nginx.conf

if [[ -z "${APP_TYPE}" ]]; then
  echo "[info] APP_TYPE has not been set. We will use the default config."
else
  echo "[info] This service is [${APP_TYPE}]"
  config_file="/etc/nginx/conf.template/${APP_TYPE}.conf"
  if [[ -f "${config_file}" ]]; then
    cp config_file /etc/nginx/http.d/default.conf
  else
    echo "[info] The config file does NOT exist. We will use the default config."
  fi
fi

/usr/sbin/nginx -g "daemon off;"
