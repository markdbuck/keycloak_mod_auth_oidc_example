FROM centos/httpd-24-centos7
 
# CentOS Linux release 7.0.1406 (Core)

USER root

# RUN rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
# RUN rpm -ihv http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm

# Save the RH httpd directories
RUN mkdir -p /save/etc && cp -rfp /etc/httpd /save/etc
RUN mkdir -p /save/lib64 && cp -rfp /opt/rh/httpd24/root/usr/lib64/httpd /save/lib64/
RUN mkdir -p /save/run && cp -rfp /opt/rh/httpd24/root/var/run/httpd /save/run/
RUN mkdir -p /save/log && cp -rfp /var/log/httpd24 /save/log/

RUN yum remove -y httpd24-httpd-2.4.27-8.el7.x86_64

RUN yum update -y

ENV CJOSE_VERSION 0.5.1
ENV CJOSE_PKG cjose-${CJOSE_VERSION}-1.el7.centos.x86_64.rpm
RUN curl -s -L -o ~/${CJOSE_PKG} https://mod-auth-openidc.org/download/${CJOSE_PKG}
RUN ${CMD_PREFIX} yum localinstall -y ~/${CJOSE_PKG}

ENV MOD_AUTH_OPENIDC_VERSION 2.3.4rc2
ENV MOD_AUTH_OPENIDC_PKG mod_auth_openidc-${MOD_AUTH_OPENIDC_VERSION}-1.el7.centos.x86_64.rpm
RUN curl -s -L -o ~/${MOD_AUTH_OPENIDC_PKG} https://mod-auth-openidc.org/download/${MOD_AUTH_OPENIDC_PKG}
RUN ${CMD_PREFIX} yum localinstall -y ~/${MOD_AUTH_OPENIDC_PKG}

RUN yum install -y mod_ssl

# Restore the RH httpd directories
RUN cp /etc/httpd/conf.modules.d/10-auth_openidc.conf /save/etc/httpd/conf.modules.d/ && rm -rf /etc/httpd && cp -rfp /save/etc/httpd /etc/ && ln -s /etc/httpd /opt/rh/httpd24/root/etc/httpd
RUN cp -rfp /save/lib64/httpd /opt/rh/httpd24/root/usr/lib64
RUN cp -rfp /save/run/httpd /opt/rh/httpd24/root/var/run
RUN cp -rfp /save/log/httpd24 /var/log
RUN rm -rf /save

# ADD 000-default.conf /etc/httpd/conf.d/
# RUN /usr/sbin/httpd && curl -v http://localhost/protected/index.php 2>&1 | grep "Location:" | grep "accounts.google.com/o/oauth2/auth"

# RUN yum install -y httpd mod_ssl

# RUN yum install -y curl jansson

RUN chmod -R 777 /run/httpd

USER 1000

# CMD tail -f /dev/null

