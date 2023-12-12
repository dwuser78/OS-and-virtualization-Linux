FROM ubuntu/nginx

RUN apt update && apt install php8.2-fpm -y
RUN mkdir /var/www_dir

COPY nginx_files/nginx.conf /etc/nginx/nginx.conf
COPY nginx_files/default.conf /etc/nginx/conf.d/default.conf
COPY nginx_files/www/test.php /var/www_dir/test.php

RUN chown www-data:www-data -R /var/www_dir

EXPOSE 80

CMD service php8.2-fpm start && nginx -g "daemon off;"
