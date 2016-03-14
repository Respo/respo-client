
ns respo-client.core
  :require-macros $ [] cljs.core.async.macros :refer $ [] go
  :require
    [] devtools.core :as devtools
    [] respo-client.controller.client :refer $ [] initialize-instance activate-instance patch-instance release-instance
    [] respo-client.util.time :refer $ [] io-get-time
    [] respo-client.util.websocket :refer $ [] send-chan receive-chan
    [] cljs.core.async :as a :refer $ [] >! <! chan timeout

defn deliver-event (coord event-name simple-event)
  go
    >! send-chan $ [] coord event-name simple-event
    .info js/console |send: coord event-name simple-event

defn mount-demo ()
  let
    (app-root $ .querySelector js/document |#app)
    initialize-instance app-root deliver-event

defn -main ()
  devtools/enable-feature! :sanity-hints :dirac
  devtools/install!
  enable-console-print!
  .log js/console "|App is running..."
  mount-demo
  go $ loop ([])
    let
      (command $ <! receive-chan)
        cmd-type $ first command
        cmd-data $ last command
        app-root $ .querySelector js/document |#app
      .log js/console command
      case cmd-type
        :sync $ do
          activate-instance cmd-data app-root deliver-event
          recur
        :patch $ do
          patch-instance cmd-data app-root deliver-event
          recur
        do (println "|no matched command")
          recur

set! js/window.onload -main

defn fig-reload ()
  .clear js/console
  let
    (app-root $ .querySelector js/document |#app)
    .info js/console |Reloaded!
