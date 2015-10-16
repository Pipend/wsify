require! \assert
{create-write-stream, close-sync, unlink-sync} = require \fs
{from-file-streams, from-redis-connections}? = require \../observables
require! \redis

describe "wsify", ->

    specify "must braodcast data from redis channels", (done) ->

        observable = from-redis-connections do 
            [
                connection-string: \redis://localhost:6379/
                channels: 
                    * channel-name: \test 
                    ...
            ]

        observable.subscribe ({event-name, payload}) ->
            assert event-name == \test
            assert payload == \hello
            done!

        redis-client = redis.create-client!
            ..once \connect, ->
                <- set-timeout _, 200
                redis-client.publish \test, \hello

    specify "must broadcast data from file streams", (done) ->

        write-stream = create-write-stream "#{__dirname}/fixture.txt"
            ..once \open, ->
                
                from-file-streams [{event-name: \test, file-name: "#{__dirname}/fixture.txt"}] .subscribe ({event-name, payload}) ->
                    write-stream.end!
                    assert event-name == \test
                    assert payload == \hello
                    done!

                write-stream.write 'hello\n'
