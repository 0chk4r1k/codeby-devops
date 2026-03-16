FROM debian:11

RUN apt-get update && apt-get install -y nginx

RUN mkdir -p /opt/www

RUN echo "<h1>Hello world!</h1>" > /opt/www/index.html

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]
