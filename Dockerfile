FROM registry.access.redhat.com/rhscl/php-71-rhel7:1-12

USER root

RUN yum repos --enable rhel-7-server-extras-rpms

RUN yum install -y epel-release mod_ssl jansson hiredis

# Download mod_auth_openidc
RUN wget --quiet --output-document=/tmp/oidc.deb https://github.com/pingidentity/mod_auth_openidc/releases/download/v1.8.8/libapache2-mod-auth-openidc_1.8.8-1_amd64.deb ; dpkg -i /tmp/oidc.deb ; apt-get install -fy && dpkg -i /tmp/oidc.deb

# Enable apache module mod_auth_openidc
RUN a2enmod auth_openidc

COPY ./html /var/www/html

CMD apache2ctl -DFOREGROUND
# CMD apache2ctl start && tail -f /dev/null

EXPOSE 8080

COPY ./000-default.conf /etc/apache2/sites-enabled/000-default.conf

COPY ./ports.conf /etc/apache2/ports.conf
