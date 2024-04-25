FROM zeek/zeek:latest

WORKDIR /usr/local/zeek/etc

RUN sed -i 's/LogDir = \/usr\/local\/zeek\/logs/LogDir = \/shared-vol/' zeekctl.cfg
RUN sed -i 's/SpoolDir = \/usr\/local\/zeek\/spool/SpoolDir = \/shared-vol/' zeekctl.cfg
# RUN zeekctl deploy

#WORKDIR /shared-vol
# CMD ["zeek", "-i", "eth0"]

ENTRYPOINT ["tail", "-f", "/dev/null"]