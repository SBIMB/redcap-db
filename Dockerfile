ubuntu:18.04

# Install packages
ENV DEBIAN_FRONTEND noninteractive

# Set DB 'admin' user password to REDCAP
ENV MYSQL_PASS redcap

# Install packages
RUN apt-get update && \
  apt-get -y git \
  mysql-server \
  nano \

# Set LOG Directories
RUN mkdir /var/log/export && chgrp adm /var/log/export

# Add image configuration and scripts
ADD start-mysqld.sh /start-mysqld.sh
#ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Add custom directives to the my.cnf file locally
ADD my.cnf /etc/mysql/conf.d/my.cnf

# Configure supervisord to manage processes (otherwise a docker instance can only run 1 process)
#ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
#ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
#ADD supervisord-cron.conf /etc/supervisor/conf.d/supervisord-cron.conf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL utils
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh

# Add mappable volumes
VOLUME ["/etc/mysql", "/var/lib/mysql", "/var/log/export" ]

EXPOSE 3306
CMD ["/run.sh"]
