FROM centos:7

# RUN
RUN yum -y update
RUN yum -y install epel-release
RUN yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum install httpd php72 php72-php php72-php-mysqlnd php72-php-gd php72-php-xml php72-php-mbstring php72-php-pecl-apcu php72-php-intl -y
RUN yum -y install python36
RUN unlink /usr/bin/python
RUN ln -s /usr/bin/python36 /usr/bin/python
RUN systemctl enable httpd
RUN curl -fsL https://releases.wikimedia.org/mediawiki/1.32/mediawiki-1.32.1.tar.gz  | tar xfz - -C /var/www
RUN ln -s /var/www/mediawiki-1.32.1/ /var/www/wiki
RUN chown -R apache:apache /var/www/mediawiki-1.32.1
RUN sed -i 's/DocumentRoot \"\/var\/www\/html\"/DocumentRoot \"\/var\/www\"/' /etc/httpd/conf/httpd.conf
RUN sed -i 's/Require all granted/Require all granted\n    DirectoryIndex index.html index.html.var index.php/' /etc/httpd/conf/httpd.conf
RUN sed -i '/<Directory \"\/var\/www\">/N;s/\n/ /' /etc/httpd/conf/httpd.conf
RUN sed -i 's/<Directory \"\/var\/www\">     AllowOverride None/<Directory \"\/var\/www\">\n    AllowOverride ALL/' /etc/httpd/conf/httpd.conf
RUN sed -i '$ a LoadModule rewrite_module modules/mod_rewrite.so' /etc/httpd/conf/httpd.conf
RUN echo $'RewriteEngine on \n\
RewriteBase /wiki/ \n\
RewriteCond %{REQUEST_FILENAME} !-f \n\
RewriteCond %{REQUEST_FILENAME} !-d \n\
RewriteRule ^(.+)$ index.php/$1' > /var/www/wiki/.htaccess