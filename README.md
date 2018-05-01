# redismod - a Docker image with select Redis Labs modules

This simple container image bundles together the latest stable releases of [Redis](https://redis.io) and select Redis modules from [Redis Labs](https://redislabs.com).

# Quickstart

```bash
$ docker pull redislabs/redismod
Using default tag: latest
...
$ docker run -p 6379:6379 redismod
1:C 01 May 06:37:09.666 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
...
```

## Modules included in the container

* [RediSearch](http://redisearch.io): a full-featured search engine
* [ReJSON](http://rejson.io): a native JSON data type
* [Rebloom](http://rebloom.io): native Bloom and Cuckoo Filter data types

## License

This Docker image is licensed under the 3-Clause BSD License.
The copyright of the Redis project belongs to Salvatore Sanfilippo, and the project is distributed under the 3-Clause BSD License.
The copyright of the Redis modules in this container belongs to Redis Labs, and the modules are distributed under the GNU Affero General Public License v3.0 (AGPLv3).

