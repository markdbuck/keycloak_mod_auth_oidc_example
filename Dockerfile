# FROM registry.access.redhat.com/rhscl/php-71-rhel7:1-12
FROM centos:6.9

USER root

RUN rpm -ivh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

RUN yum install -y httpd mod_ssl

RUN yum install -y curl jansson

RUN curl -s -L -o ~/hiredis-0.12.1-1.sdl6.x86_64.rpm http://springdale.math.ias.edu/data/puias/unsupported/6/x86_64/hiredis-0.12.1-1.sdl6.x86_64.rpm
RUN yum localinstall -y ~/hiredis-0.12.1-1.sdl6.x86_64.rpm

RUN curl -s -L -o ~/cjose-0.5.1-1.el6.x86_64.rpm https://github.com/zmartzone/mod_auth_openidc/releases/download/v2.3.0/cjose-0.5.1-1.el6.x86_64.rpm
RUN yum localinstall -y ~/cjose-0.5.1-1.el6.x86_64.rpm

# Download mod_auth_openidc
RUN curl -s -L -o ~/mod_auth_openidc-2.3.3-1.el6.x86_64.rpm https://github.com/zmartzone/mod_auth_openidc/releases/download/v2.3.3/mod_auth_openidc-2.3.3-1.el6.x86_64.rpm
RUN yum localinstall -y ~/mod_auth_openidc-2.3.3-1.el6.x86_64.rpm

# Enable apache module mod_auth_openidc
# RUN a2enmod auth_openidc

# COPY ./html /var/www/html

# CMD apache2ctl -DFOREGROUND

# EXPOSE 8080

# COPY ./000-default.conf /etc/apache2/sites-enabled/000-default.conf

# COPY ./ports.conf /etc/apache2/ports.conf

USER 1000

CMD tail -f /dev/null

