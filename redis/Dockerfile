FROM redis

#####################################
# Set Timezone
#####################################

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' > /etc/timezone

VOLUME /data

COPY redis.conf /etc/redis.conf

CMD [ "redis-server", "/etc/redis.conf" ]

EXPOSE 6379