db = Rails.env.test? ? 1 : 0
redis_url = ENV['REDISCLOUD_URL'] || "#{ENV['REDIS_URL']}/#{db}"
redis = Redis.new url: redis_url
redis.flushdb if Rails.env.test?
Typhoeus::Config.cache = Typhoeus::Cache::Redis.new(redis)
