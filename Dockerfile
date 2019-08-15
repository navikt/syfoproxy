FROM nginx

COPY launch.sh .
COPY default.conf.template /tmp
COPY proxy.conf /etc/nginx/conf.d

CMD /launch.sh
