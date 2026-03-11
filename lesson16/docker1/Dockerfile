FROM alpine:latest

RUN apk update && apk add nginx

RUN mkdir -p /opt/www

RUN echo "<h1>Hello world!</h1>" > /opt/www/index.html

RUN mkdir -p /run/nginx

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
