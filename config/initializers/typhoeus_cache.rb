db = Rails.env.test? ? 1 : 0
redis = Redis.new url: "#{ENV['REDIS_URL']}/#{db}"
redis.flushdb if Rails.env.test?
Typhoeus::Config.cache = Typhoeus::Cache::Redis.new(redis)
