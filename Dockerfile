FROM redislabs/redisearch:latest as redisearch
FROM redislabs/redisgraph:latest as redisgraph
FROM redislabs/redisml:latest as redisml
FROM redislabs/rejson:latest as rejson
FROM redislabs/rebloom:latest as rebloom

FROM redis:latest as redis
ENV LIBDIR /usr/lib/redis/modules
WORKDIR /data
RUN set -ex;\
    mkdir -p ${LIBDIR};
COPY --from=redisearch ${LIBDIR}/redisearch.so ${LIBDIR}
COPY --from=redisgraph ${LIBDIR}/redisgraph.so ${LIBDIR}
COPY --from=redisml ${LIBDIR}/redis-ml.so ${LIBDIR}
COPY --from=rejson ${LIBDIR}/rejson.so ${LIBDIR}
COPY --from=rebloom ${LIBDIR}/rebloom.so ${LIBDIR}

ENTRYPOINT ["redis-server"]
CMD ["--loadmodule", "/usr/lib/redis/modules/redisearch.so", \
    "--loadmodule", "/usr/lib/redis/modules/redisgraph.so", \
    "--loadmodule", "/usr/lib/redis/modules/redis-ml.so", \
    "--loadmodule", "/usr/lib/redis/modules/rejson.so", \
    "--loadmodule", "/usr/lib/redis/modules/rebloom.so"]
