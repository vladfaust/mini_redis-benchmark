require "benchmark"
require "mini_redis"
require "redis"
require "time_format"

mini_redis = MiniRedis.new(uri: URI.parse(ENV["REDIS_URL"]))
redis = Redis.new(url: ENV["REDIS_URL"])

foo_slice = "foo".to_slice
bar_slice = "bar".to_slice

ops = 1_000_000
repeat = 30

puts "Begin benchmarking..."

elapsed = repeat.times.reduce(Array(Time::Span).new) do |ary|
  ary << Time.measure do
    mini_redis.pipeline do |pipe|
      ops.times do
        pipe.send("SET foo bar")
      end
    end
  end
end

puts "MiniRedis (inline: t):\tTotal:\t#{TimeFormat.auto(elapsed.sum)}\t#{(ops * repeat / 1_000_000).round(3)}M ops\tAverage:\t#{TimeFormat.auto(elapsed.sum / repeat)}\t#{(ops.to_f / (elapsed.sum.total_seconds / repeat) / 1_000_000).round(3)}M ops/s"

elapsed = repeat.times.reduce(Array(Time::Span).new) do |ary|
  ary << Time.measure do
    mini_redis.pipeline do |pipe|
      ops.times do
        pipe.send("SET", foo_slice, bar_slice)
      end
    end
  end
end

puts "MiniRedis (inline: f):\tTotal:\t#{TimeFormat.auto(elapsed.sum)}\t#{(ops * repeat / 1_000_000).round(3)}M ops\tAverage:\t#{TimeFormat.auto(elapsed.sum / repeat)}\t#{(ops.to_f / (elapsed.sum.total_seconds / repeat) / 1_000_000).round(3)}M ops/s"

elapsed = repeat.times.reduce(Array(Time::Span).new) do |ary|
  ary << Time.measure do
    redis.pipelined do |pipe|
      ops.times do
        pipe.set(foo_slice, bar_slice)
      end
    end
  end
end

puts "Redis                :\tTotal:\t#{TimeFormat.auto(elapsed.sum)}\t#{(ops * repeat / 1_000_000).round(3)}M ops\tAverage:\t#{TimeFormat.auto(elapsed.sum / repeat)}\t#{(ops.to_f / (elapsed.sum.total_seconds / repeat) / 1_000_000).round(3)}M ops/s"
