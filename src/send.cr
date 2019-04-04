require "benchmark"
require "mini_redis"
require "redis"

mini_redis = MiniRedis.new(uri: URI.parse(ENV["REDIS_URL"]))
redis = Redis.new(url: ENV["REDIS_URL"])
foo_slice = "foo".to_slice

puts "Begin benchmarking..."

Benchmark.ips do |x|
  x.report("mini_redis inline") do
    mini_redis.send("GET foo")
  end

  x.report("mini_redis marshalled") do
    mini_redis.send("GET", foo_slice)
  end

  x.report("redis marshalled") do
    redis.get(foo_slice)
  end
end
