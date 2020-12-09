FROM nginx:1.17

COPY launch.sh .
COPY default.conf.template /tmp
COPY proxy.conf /etc/nginx/conf.d

CMD /launch.sh
