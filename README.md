[![Build Status](https://travis-ci.org/Pipend/wsify.svg)](https://travis-ci.org/Pipend/wsify)
[![Coverage Status](https://coveralls.io/repos/Pipend/wsify/badge.svg?branch=master&service=github)](https://coveralls.io/github/Pipend/wsify?branch=master)

# wsify
A node.js project that converts streams to web sockets

# Setup

* `npm install`
* `npm run configure` this clones `config.sample.ls` to `config.ls`, update the config with streams you want to web-socketify
* `gulp` starts the web-socket server

# Supported Streams

* Redis channels - to convert a redis channel to websocket, add it to the list of `redis-connections` in `./config.ls`, for example :

```
redis-channels:
    * connection-string: \redis://localhost:6379/
      channels:
        * channel-name: \your-channel-name
          event-name: \name-of-the-websocket-event
        ...
```

Note: by default wsify will use the channel name as the websocket event name, you can override this via the `event-name` property

* File streams - `wsify` uses the `line` event from `tail` to convert a file-stream to a websocket, you can set it up by adding the file name to the `file-streams` collection in `./config.ls` :
```
file-streams: 
    * event-name: \server
      file-name: \./server.ls
    ...
```
unlike a `redis-connection` object you must specify the `event-name` to be emiited. 