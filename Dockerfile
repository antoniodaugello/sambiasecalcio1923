# Utilizza una vecchia versione di Ubuntu
FROM ubuntu:14.04

# Disabilita il prompt interattivo di apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Aggiorna i pacchetti e installa dipendenze di base
RUN apt-get update && apt-get install -y \
    software-properties-common wget curl \
    apache2 libapache2-mod-php5 \
    php5 php5-mysql php5-gd php5-mcrypt php5-curl php5-cli \
    php5-xmlrpc && \
    apt-get clean

# Abilita il modulo rewrite e configura Apache
RUN a2enmod rewrite && \
    service apache2 restart

# Rimuovi la pagina di default (index.html)
RUN rm /var/www/html/index.html
	
# Copia il file di configurazione personalizzato di Apache
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# Copia la cartella www (contenente Joomla) nella directory di Apache
COPY ./www /var/www/html

# Copia il file php.ini personalizzato nella directory di configurazione di PHP
COPY ./php.ini /etc/php5/apache2/php.ini

# Configura la directory di lavoro
WORKDIR /var/www/html

# Esponi la porta 80
EXPOSE 80

# Comando di avvio per Apache
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
