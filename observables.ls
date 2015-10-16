{each, map, pairs-to-obj} = require \prelude-ls
require! \redis
Rx = require \rx
{Tail} = require \tail

# from-redis-connections :: [RedisConnection] -> Observable
export from-redis-connections = (redis-connections) ->
    observer <- Rx.Observable.create
    redis-connections |> each ({connection-string, channels}?) ->
        
        # parse the redis connection string redis://host:port
        [, host, port]? = /redis:\/\/(.*?):(.*?)\/(\d+)?/g.exec connection-string
        
        redis-client = redis.create-client port, host, {}
            ..once \connect, ->
                
                channels |> map ({channel-name}) ->
                    redis-client.subscribe channel-name

                # hash :: Map ChannelName, EventName
                hash = channels 
                    |> map ({channel-name, event-name}?) -> [channel-name, event-name ? channel-name]
                    |> pairs-to-obj

                redis-client.on \message, (channel, message) -> observer.on-next event-name: hash[channel], payload: message

            ..once \error, (err) -> console.log "redis connection error: #{err}"

# from-file-streams :: [FileStream] -> Observable
export from-file-streams = (file-streams) ->
    observer <- Rx.Observable.create
    file-streams |> map ({event-name, file-name}?) ->
        new Tail file-name .on \line, (line) -> 
            observer.on-next {event-name, payload: line}