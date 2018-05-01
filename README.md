# redismod - a Docker image with select Redis Labs modules

This simple container image bundles together the latest stable releases of [Redis](https://redis.io) and select Redis modules from [Redis Labs](https://redislabs.com).

# Quickstart

```text
$ docker pull redislabs/redismod
Using default tag: latest
...
$ docker run -p 6379:6379 redislabs/redismod
1:C 01 May 06:37:09.042 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
...
1:M 01 May 06:37:09.666 * Module 'ft' loaded from /usr/lib/redis/modules/redisearch.so
1:M 01 May 06:37:09.666 * Module 'ReJSON' loaded from /usr/lib/redis/modules/rejson.so
1:M 01 May 06:37:09.666 * Module 'bf' loaded from /usr/lib/redis/modules/rebloom.so
1:M 01 May 06:37:09.666 * Ready to accept connections
```

## Modules included in the container

* [RediSearch](http://redisearch.io): a full-featured search engine
* [ReJSON](http://rejson.io): a native JSON data type
* [Rebloom](http://rebloom.io): native Bloom and Cuckoo Filter data types

## Configuring the Redis server

This image is based on the [official image of Redis from Docker](https://hub.docker.com/_/redis/). By default, the container starts with Redis' default configuration and all included modules loaded.

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

The copyright of the Redis project belongs to Salvatore Sanfilippo, and the project is distributed under the 3-Clause BSD License.

The copyright of the Redis modules in this container belongs to Redis Labs, and the modules are distributed under the GNU Affero General Public License v3.0 (AGPLv3).

