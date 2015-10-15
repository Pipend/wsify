module.exports =

    socket-io-port: 4040

    # RedisChannel :: {channel-name :: String, event-name :: String?}
    # RedisConnection :: {connection-string :: String, channels :: [RedisChannel]}
    # redis-connections :: [RedisConnection]
    redis-connections: []
    
    # FileStream :: {file-name :: String, event-name :: String}
    # file-streams :: [FileStream]
    file-streams: []