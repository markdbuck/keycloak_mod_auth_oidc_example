# FROM centos:centos7
FROM centos/php-71-centos7
USER root
 
RUN rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
RUN rpm -ihv http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm

RUN yum update -y

ENV CJOSE_VERSION 0.5.1
ENV CJOSE_PKG cjose-${CJOSE_VERSION}-1.el7.centos.x86_64.rpm
RUN curl -s -L -o ~/${CJOSE_PKG} https://mod-auth-openidc.org/download/${CJOSE_PKG}
RUN ${CMD_PREFIX} yum localinstall -y ~/${CJOSE_PKG}

RUN yum install -y hiredis

ENV MOD_AUTH_OPENIDC_VERSION 2.3.4rc2
ENV MOD_AUTH_OPENIDC_PKG mod_auth_openidc-${MOD_AUTH_OPENIDC_VERSION}-1.el7.centos.x86_64.rpm
RUN curl -s -L -o ~/${MOD_AUTH_OPENIDC_PKG} https://mod-auth-openidc.org/download/${MOD_AUTH_OPENIDC_PKG}
# RUN ${CMD_PREFIX} yum localinstall -y ~/${MOD_AUTH_OPENIDC_PKG}
# RUN rpm command so can skip dependencies
RUN rpm -ivh --nodeps ~/${MOD_AUTH_OPENIDC_PKG}

RUN cp -p /usr/lib64/httpd/modules/mod_auth_openidc.so /opt/rh/httpd24/root/etc/httpd/modules/

# RUN yum install -y mod_ssl

# ADD 000-default.conf /etc/httpd/conf.d/
RUN chmod -R g+rw /opt/app-root/src

USER 1000

