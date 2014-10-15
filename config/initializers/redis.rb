redis_url = ENV["REDISCLOUD_URL"] || "redis://127.0.0.1:6379/0/carebearium"

Carebearium::Application.config.cache_store = :redis_store, redis_url
Carebearium::Application.config.session_store :redis_store, redis_server: redis_url

Carebearium::Application.config.action_dispatch.rack_cache = {
  metastore:   redis_url,
  entitystore: redis_url
}
