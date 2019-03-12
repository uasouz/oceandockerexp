FROM nginx:alpine

#Instalando php e dependencias
RUN apk add wget curl php7 php7-fpm php7-opcache php7-phar php7-json php7-iconv

RUN apk add php7-mysqli

#COPY source dest

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer 

CMD ["nginx","-g","daemon off;"]