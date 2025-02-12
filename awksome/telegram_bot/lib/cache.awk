@namespace "cache"
@load "redis"

BEGIN {
  redis_conn = awk::redis_connect()
  if (redis_conn == -1) {
    l::error("Not using redis for caching: " ERRNO)
  }
}

function get(redis_key) {
  if (redis_conn == -1) return ""
  return awk::redis_get(redis_conn, redis_key)
}

function set(redis_key, redis_value) {
  if (redis_conn == -1) return
  awk::redis_set(redis_conn, redis_key, redis_value)
}
