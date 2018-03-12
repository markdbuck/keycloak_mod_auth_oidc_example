FROM centos:centos7
 
# CentOS Linux release 7.0.1406 (Core)

RUN rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
RUN rpm -ihv http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm

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

ADD 000-default.conf /etc/httpd/conf.d/
# RUN /usr/sbin/httpd 

RUN sed -i 's/Listen :80/Listen 0.0.0.0:80/' /etc/httpd/conf/httpd.conf

RUN sed -i 's/Listen 443 https/Listen 8443 https/' /etc/httpd/conf.d/ssl.conf

RUN sed -i 's/User apache/User default/' /etc/httpd/conf/httpd.conf

RUN sed -i 's/Group apache/Group root/' /etc/httpd/conf/httpd.conf

RUN chmod -R 770 /etc/httpd && chown -R :root /run/httpd && chmod -R 770 /run/httpd && chmod -R 770 /var/log/httpd

USER 1000

# CMD /usr/sbin/httpd

CMD tail -f /dev/null
