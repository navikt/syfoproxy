FROM nginx

COPY launch.sh .
COPY default.conf.template /tmp

CMD /launch.sh