FROM alpine:3.15.4

ENV APP_TYPE=steemd

RUN apk --no-cache add \
    nginx \
    gettext \
    fcgiwrap \
    supervisor \
    curl \
    jq

ADD ./conf.template /etc/nginx/conf.template
ADD ./healthcheck /etc/nginx/healthcheck
ADD ./start_nginx.sh /usr/local/bin/start_nginx.sh
ADD ./supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
