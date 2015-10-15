{file-streams, redis-connections, socket-io-port} = require \./config
{each, map, pairs-to-obj} = require \prelude-ls
require! \redis
{Tail} = require \tail

web-socket = (require \socket.io) socket-io-port

console.log "web-socket server listening on port: #{socket-io-port}"

# convert redis channels to websocket events
if !!redis-connections
    
    redis-connections |> each ({connection-string, channels}?) ->
        
        # parse the redis connection string redis://host:port
        [, host, port]? = /redis:\/\/(.*?):(.*?)\/(\d+)?/g.exec connection-string
        
        redis-client = redis.create-client port, host, {}
            ..once \connect, ->
                
                channels |> map ({channel-name}) ->
                    redis-client.subscribe channel-name

                hash = channels 
                    |> map ({channel-name, event-name}?) -> [channel-name, event-name ? channel-name]
                    |> pairs-to-obj

                redis-client.on \message, (channel, message) -> web-socket.emit hash[channel], message

            ..once \error, (err) -> console.log "redis connection error: #{err}"

# convert file streams to websocket events
if !!file-streams
    file-streams |> map ({event-name, file-name}?) ->
        new Tail file-name .on \line, (line) -> 
            web-socket.emit event-name, line


