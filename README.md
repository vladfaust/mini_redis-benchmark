# MiniRedis benchmarks

A collection of benchmarks comparing <https://github.com/vladfaust/mini_redis> and <https://github.com/stefanwille/crystal-redis>.

## Usage

```sh
> shards update && shards install
> env REDIS_URL=<your redis URL> crystal src/pipeline.cr --release
> env REDIS_URL=<your redis URL> crystal src/send.cr --release
```
