require! \./config
{each} = require \prelude-ls
{from-file-streams, from-redis-connections} = require \./observables

web-socket = (require \socket.io) config.socket-io-port
console.log "broadcasting on port: #{config.socket-io-port}"

[
    from-file-streams config?.file-streams ? []
    from-redis-connections config?.redis-connections ? []
] |> each (.subscribe ({event-name, payload}) -> web-socket.emit event-name, payload)