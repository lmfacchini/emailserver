FROM ubuntu:22.04
LABEL Leonardo Marquini Facchini lmfacchini@gmail.com

RUN apt update && \
    apt install -y postfix dovecot-core dovecot-pop3d libsasl2-modules

COPY run.sh /
COPY configs/dovecot/10-auth.conf /etc/dovecot/conf.d/10-auth.conf
COPY configs/dovecot/10-master.conf /etc/dovecot/conf.d/10-master.conf
COPY certs/cakey.pem /etc/ssl/private/
COPY certs/cacert.pem /etc/ssl/certs/
COPY configs/dovecot/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf

COPY certs/server.crt /etc/ssl/certs
COPY certs/server.key /etc/ssl/private
RUN chmod +x /run.sh

EXPOSE 25 110
#ENTRYPOINT ["/run.sh"]
CMD ["/run.sh"]