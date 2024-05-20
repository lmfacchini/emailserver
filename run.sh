#!/bin/bash

service postfix stop 
service dovecot stop

[ "${DEBUG}" == "yes" ] && set -x

function add_config_value() {
 local key=${1}
 local value=${2}
 postconf -e "${key} = ${value}"
}


# Converte a string em pares, substituindo ';' por newline e ':' por espaço
pairs=$(echo "$AUTH" | tr ';' '\n' | tr ':' ' ')

# Lê os pares e adiciona ao array
while read -r USER PASS; do
  adduser $USER
  echo "$USER:$PASS" | chpasswd
done <<< "$pairs"




echo "127.0.0.1    ${SERVER_HOSTNAME}" >> "/etc/hosts"

# Set needed config options


add_config_value "smtpd_recipient_restrictions" "permit_mynetworks,reject_unauth_destination"

# add_config_value "home_mailbox" "Maildir/"
add_config_value "smtp_tls_security_level" "may"
add_config_value "smtpd_tls_security_level" "may"
add_config_value "smtp_tls_note_starttls_offer" "yes"
add_config_value "smtpd_tls_key_file" "/etc/ssl/private/server.key"
add_config_value "smtpd_tls_cert_file" "/etc/ssl/certs/server.crt"
add_config_value "smtpd_tls_loglevel" "1"
add_config_value "smtpd_tls_received_header" "yes"
add_config_value "smtpd_tls_CAfile" "/etc/ssl/certs/cacert.pem"
add_config_value "relayhost" ""
add_config_value "inet_interfaces" "all"
add_config_value "alias_maps" "hash:/etc/aliases"
add_config_value "alias_database" "hash:/etc/aliases"

if [ -n "${SMTP_PORT}" ]; then
    add_config_value "smtpd_port" "$SMTP_PORT"
fi

if [ -n "${POP3_PORT}" ]; then
    echo "port = $POP3_PORT" >> /etc/dovecot/dovecot.conf
fi



add_config_value "maillog_file" "/dev/stdout"
add_config_value "myhostname" ${SERVER_HOSTNAME}
add_config_value "mydomain"  ${SERVER_HOSTNAME}
add_config_value "mydestination" "${SERVER_HOSTNAME}, localhost.${SERVER_HOSTNAME}, localhost"
add_config_value "myorigin" '$mydomain'
add_config_value "mynetworks" "0.0.0.0/0"
echo 'nameserver 8.8.8.8' >> /var/spool/postfix/etc/resolv.conf
echo 'nameserver 8.8.8.8' >> /etc/resolv.conf 

(exec /usr/sbin/postfix -c /etc/postfix start-fg &) && (/usr/sbin/dovecot -F &) >> /var/log/mail.log 2>&1
tail -f /var/log/mail.log

