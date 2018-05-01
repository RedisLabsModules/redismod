FROM redislabs/redisearch:latest as redisearch
FROM redislabs/rejson:latest as rejson
FROM redislabs/rebloom:latest as rebloom

FROM redis:latest as redis
ENV LIBDIR /usr/lib/redis/modules
WORKDIR /data
RUN set -ex;\
    mkdir -p ${LIBDIR};
COPY --from=redisearch ${LIBDIR}/redisearch.so ${LIBDIR}
COPY --from=rejson ${LIBDIR}/rejson.so ${LIBDIR}
COPY --from=rebloom /var/lib/redis/modules/rebloom.so ${LIBDIR}

CMD ["redis-server", \
    "--loadmodule", "/usr/lib/redis/modules/redisearch.so", \
    "--loadmodule", "/usr/lib/redis/modules/rejson.so", \
    "--loadmodule", "/usr/lib/redis/modules/rebloom.so"]
