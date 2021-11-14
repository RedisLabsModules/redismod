[![CircleCI](https://circleci.com/gh/RedisLabsModules/redismod/tree/master.svg?style=svg)](https://circleci.com/gh/RedisLabsModules/redismod/tree/master)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/redislabs/redismod.svg)](https://hub.docker.com/r/redislabs/redismod/builds/)

# redismod - a Docker image with select Redis Labs modules

This simple container image bundles together the latest stable releases of [Redis](https://redis.io) and select Redis modules from [Redis Labs](https://redislabs.com).

# Quickstart

```text
$ docker pull redislabs/redismod
Using default tag: latest
...
$ docker run -p 6379:6379 redislabs/redismod
1:C 24 Apr 2019 21:46:40.382 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
...
1:M 24 Apr 2019 21:46:40.474 * Module 'ai' loaded from /usr/lib/redis/modules/redisai.so
1:M 24 Apr 2019 21:46:40.474 * <ft> RediSearch version 1.4.7 (Git=)
1:M 24 Apr 2019 21:46:40.474 * <ft> concurrency: ON, gc: ON, prefix min length: 2, prefix max expansions: 200, query timeout (ms): 500, timeout policy: return, cursor read size: 1000, cursor max idle (ms): 300000, max doctable size: 1000000, search pool size: 20, index pool size: 8, 
1:M 24 Apr 2019 21:46:40.475 * <ft> Initialized thread pool!
1:M 24 Apr 2019 21:46:40.475 * Module 'ft' loaded from /usr/lib/redis/modules/redisearch.so
1:M 24 Apr 2019 21:46:40.476 * <graph> Thread pool created, using 8 threads.
1:M 24 Apr 2019 21:46:40.476 * Module 'graph' loaded from /usr/lib/redis/modules/redisgraph.so
loaded default MAX_SAMPLE_PER_CHUNK policy: 360 
1:M 24 Apr 2019 21:46:40.476 * Module 'timeseries' loaded from /usr/lib/redis/modules/redistimeseries.so
1:M 24 Apr 2019 21:46:40.476 # <ReJSON> JSON data type for Redis v1.0.4 [encver 0]
1:M 24 Apr 2019 21:46:40.476 * Module 'ReJSON' loaded from /usr/lib/redis/modules/rejson.so
1:M 24 Apr 2019 21:46:40.476 * Module 'bf' loaded from /usr/lib/redis/modules/rebloom.so
1:M 24 Apr 2019 21:46:40.477 * <rg> RedisGears version 0.2.1, git_sha=fb97ad757eb7238259de47035bdd582735b5c81b
1:M 24 Apr 2019 21:46:40.477 * <rg> PythonHomeDir:/usr/lib/redis/modules/deps/cpython/
1:M 24 Apr 2019 21:46:40.477 * <rg> MaxExecutions:1000
1:M 24 Apr 2019 21:46:40.477 * <rg> RedisAI api loaded successfully.
1:M 24 Apr 2019 21:46:40.477 # <rg> RediSearch api loaded successfully.
1:M 24 Apr 2019 21:46:40.521 * Module 'rg' loaded from /usr/lib/redis/modules/redisgears.so
1:M 24 Apr 2019 21:46:40.521 * Ready to accept connections
```

## Modules included in the container

* [RediSearch](https://oss.redislabs.com/redisearch/): a full-featured search engine
* [RedisGraph](https://oss.redislabs.com/redisgraph/): a graph database
* [RedisTimeSeries](https://oss.redislabs.com/redistimeseries/): a timeseries database
* [RedisAI](https://oss.redislabs.com/redisai/): a tensor and deep learning model server
* [RedisJSON](https://oss.redislabs.com/redisjson/): a native JSON data type
* [RedisBloom](https://oss.redislabs.com/redisbloom/): native Bloom and Cuckoo Filter data types
* [RedisGears](https://oss.redislabs.com/redisgears/): a dynamic execution framework

## Building and Running

Start by invoking `make help`:

```
make build    # Build container
  FRESH=1|0     # always fetch images from Dockerhub
  OFFICIAL=1    # create redislabs/redismod image
make edge     # Like: make build EDGE=1
make preview  # Like: make build PREVIEW=1
make latest   # Like: make build LATEST=1

make run      # Run selected container
make up       # Build and start docker-compose containers
  VERBOSE=1     # Show output from containers (no daemon mode)
make down     # Stop docker-compose containers
make clean    # Remove docker-compose containers

make publish  # Push redislabs/redismod images (requires OFFICIAL=1)

make test     # Test with redis-py

Version selectors:
EDGE=1        # redismod:edge (latest commit on master)
PREVIEW=1     # redismod:preview (latest commit latest integration branch)
LATEST=1      # redismod:latest (last released version)
```

There are three version selectors:

* **EDGE**: the "latest and greatest" version from the master branch of each module,
* **PREVIEW**: the latest commit of the latest integration branch,
* **LATEST**: the latest stable version.

The simplest way of creating a redismod container of your choice is:

```
make EDGE=1 up
```

which results in:

```
Creating network "redismod_default" with the default driver
Creating redismod_redismod-edge_1 ... done
```

You can now connect with `redis-cli` and examine available modules:

```
# redis-cli
myhost:6379> module list
1) 1) "name"
   2) "timeseries"
   3) "ver"
   4) (integer) 999999
2) 1) "name"
   2) "search"
   3) "ver"
   4) (integer) 999999
3) 1) "name"
   2) "graph"
   3) "ver"
   4) (integer) 999999
4) 1) "name"
   2) "ai"
   3) "ver"
   4) (integer) 999999
5) 1) "name"
   2) "ReJSON"
   3) "ver"
   4) (integer) 999999
6) 1) "name"
   2) "rg"
   3) "ver"
   4) (integer) 999999
7) 1) "name"
   2) "bf"
   3) "ver"
   4) (integer) 999999
```

The following will bring the container down:

```
# make EDGE=1 down
Stopping redismod_redismod-edge_1 ... done
Removing redismod_redismod-edge_1 ... done
Removing network redismod_default
```

## Configuring the Redis server

This image is based on an image similar to the [official image of Redis from Docker](https://hub.docker.com/_/redis/). By default, the container starts with Redis' default configuration and all included modules loaded.

You can, of course, override the defaults. This can be done either by providing additional command line arguments to the `docker` command, or by providing your own [Redis configuration file](http://download.redis.io/redis-stable/redis.conf).

### Running the container with command line arguments

You can provide Redis with configuration directives directly from the `docker` command. For example, the following will start the container, mount the host's `/home/user/data` volume to the container's `/data`, load the Rebloom module, and configure Redis' working directory to `/data` so that the data will actually be persisted there.

```text
$ docker run \
  -p 6379:6379 \
  -v /home/user/data:/data \
  redislabs/redismod \
  --loadmodule /usr/lib/redis/modules/rebloom.so \
  --dir /data
```

### Running the container with a configuration file

Assuming that you have put together a configration file such as the following, and have stored it at `/home/user/redis.conf`:

```text
requirepass foobared
dir /data
loadmodule /usr/lib/redis/modules/rebloom.so
```

And then execute something along these lines:

```text
$ docker run \
  -p 6379:6379 \
  -v /home/user/data:/data \
  -v /home/user/redis.conf:/usr/local/etc/redis/redis.conf \
  redislabs/redismod \
  /usr/local/etc/redis/redis.conf
```

Your dockerized Redis server will start and will be listening at the default Redis port (6379) of the host. In addition, the Redis server will require password authentication ("foobared"), will store the data to the container's `/data` (that is the host's volume `/home/user/data`), and will have loaded only the Rebloom module.

## License

This Docker image is licensed under the 3-Clause BSD License.

Redis is distributed under the 3-Clause BSD License. The Redis trademark and logos are owned by Redis Labs Ltd, please read the Redis trademark guidelines (https://redis.io/topics/trademark) for our policy about the use of the Redis trademarks and logo.

The copyright of the Redis modules in this container belongs to Redis Labs, and the modules are distributed under the Redis Source Available License.

