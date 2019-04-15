require "benchmark"
require "mini_redis"
require "redis"

mini_redis = MiniRedis.new(uri: URI.parse(ENV["REDIS_URL"]))
redis = Redis.new(url: ENV["REDIS_URL"])

puts "Begin benchmarking..."

Benchmark.ips do |x|
  x.report("mini_redis") do
    mini_redis.send("GET", "foo")
  end

  x.report("crystal-redis") do
    redis.get("foo")
  end
end
