FROM nginx

LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"

#####################################
# Set Timezone
#####################################

COPY nginx.conf /etc/nginx/nginx.conf

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' > /etc/timezone

EXPOSE 80 443