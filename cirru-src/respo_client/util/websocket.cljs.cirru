
ns respo-client.util.websocket
  :require-macros $ [] cljs.core.async.macros :refer $ [] go
  :require
    [] cljs.reader :as reader
    [] cljs.core.async :as a :refer $ [] >! <! chan timeout

defonce send-chan $ chan

defonce receive-chan $ chan

def ws $ new js/WebSocket |ws://repo:4005

enable-console-print!

set! (.-onopen ws)
  fn ()
    println "|socket opened"

set! (.-onmessage ws)
  fn (event)
    let
      (changes $ reader/read-string $ .-data event)
      go $ >! receive-chan changes

set! (.-onclose ws)
  fn (event)
    go
      <! $ timeout 30000
      .reload js/location

go $ loop ([])
  .send ws $ pr-str $ <! send-chan
  recur
