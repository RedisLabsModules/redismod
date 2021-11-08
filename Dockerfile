ARG REDIS_VER=6.2.6
ARG ARCH=x64
ARG OSNICK=bullseye

FROM redislabs/redisai:latest as redisai
FROM redislabs/redisearch:latest as redisearch
FROM redislabs/redisgraph:latest as redisgraph
FROM redislabs/redistimeseries:latest as redistimeseries
FROM redislabs/rejson:latest as rejson
FROM redislabs/rebloom:latest as rebloom
FROM redislabs/redisgears:latest as redisgears
FROM redisfab/redis:${REDIS_VER}-${ARCH}-${OSNICK}

ENV LD_LIBRARY_PATH /usr/lib/redis/modules
ENV REDISGEARS_MODULE_DIR /var/opt/redislabs/lib/modules
ENV REDISGEARS_PY_DIR /var/opt/redislabs/modules/rg
ENV REDISGRAPH_DEPS libgomp1 git

WORKDIR /data
RUN apt-get update -qq
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends ${REDISGRAPH_DEPS};
RUN rm -rf /var/cache/apt

COPY --from=redisai ${LD_LIBRARY_PATH}/redisai.so ${LD_LIBRARY_PATH}/
COPY --from=redisai ${LD_LIBRARY_PATH}/backends ${LD_LIBRARY_PATH}/backends
COPY --from=redisearch ${LD_LIBRARY_PATH}/redisearch.so ${LD_LIBRARY_PATH}/
COPY --from=redisgraph ${LD_LIBRARY_PATH}/redisgraph.so ${LD_LIBRARY_PATH}/
COPY --from=redistimeseries ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/
COPY --from=rejson ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/
COPY --from=rebloom ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/
COPY --from=redisgears --chown=redis:redis ${REDISGEARS_MODULE_DIR}/redisgears.so ${LD_LIBRARY_PATH}/
COPY --from=redisgears --chown=redis:redis ${REDISGEARS_PY_DIR}/ ${REDISGEARS_PY_DIR}/

# ENV PYTHONPATH /usr/lib/redis/modules/deps/cpython/Lib
ENTRYPOINT ["redis-server"]
CMD ["--loadmodule", "/usr/lib/redis/modules/redisai.so", \
    "--loadmodule", "/usr/lib/redis/modules/redisearch.so", \
    "--loadmodule", "/usr/lib/redis/modules/redisgraph.so", \
    "--loadmodule", "/usr/lib/redis/modules/redistimeseries.so", \
    "--loadmodule", "/usr/lib/redis/modules/rejson.so", \
    "--loadmodule", "/usr/lib/redis/modules/redisbloom.so", \
    "--loadmodule", "/usr/lib/redis/modules/redisgears.so", \
    "Plugin", "/var/opt/redislabs/modules/rg/plugin/gears_python.so"]
