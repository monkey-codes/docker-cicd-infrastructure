FROM httpd:2.4
#FROM webdevops/apache
ADD ./httpd.conf /usr/local/apache2/conf/
ADD ./httpd-vhosts.conf /usr/local/apache2/conf/extra/
ADD ./static/ /app/
#RUN a2enmod proxy && \
#  a2enmod proxy_http
