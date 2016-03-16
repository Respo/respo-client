
ns respo-client.renderer.patcher $ :require
  [] clojure.string :as string
  [] cljs.reader :refer $ [] read-string
  [] respo-client.util.format :refer $ [] dashed->camel event->prop
  [] respo-client.renderer.make-dom :refer $ [] make-element style->string
  [] respo-client.util.information :refer $ [] no-bubble-events

defn find-target (root coord)
  if
    = coord $ []
    , root
    let
      (index $ first coord)
        follows $ subvec coord 1
        child $ aget (.-children root)
          , index

      recur child follows

defn replace-prop (target op)
  let
    (prop-name $ dashed->camel $ name $ key op)
      prop-value $ val op
    if
      not= (aget target prop-name)
        , prop-value
      aset target prop-name prop-value

defn add-prop (target op)
  let
    (prop-name $ dashed->camel $ name $ key op)
      prop-value $ val op
    if (= prop-name |style)
      aset target prop-name $ style->string prop-value
      aset target prop-name prop-value

defn rm-prop (target op)
  aset target
    dashed->camel $ name op
    , nil

defn add-style (target op)
  let
    (style-name $ dashed->camel $ name $ key op)
      style-value $ val op
    aset (.-style target)
      , style-name style-value

defn rm-style (target op)
  let
    (style-name $ dashed->camel $ name op)
    aset (.-style target)
      , style-name nil

defn replace-style (target op)
  let
    (style-name $ dashed->camel $ name $ key op)
      style-value $ val op
    aset (.-style target)
      , style-name style-value

defn is-no-bubble? (event-name)
  some? $ some
    fn (x)
      = x event-name
    , no-bubble-events

defn add-event (target event-name no-bubble-collection)
  let
    (event-prop $ event->prop event-name)
      existing-events $ read-string $ -> target (.-dataset)
        .-events
      new-events-list $ pr-str $ conj existing-events event-name
      maybe-listener $ get no-bubble-collection event-name

    if (some? maybe-listener)
      aset target event-prop maybe-listener
    set!
      -> target (.-dataset)
        .-events
      , new-events-list

defn rm-event (target event-name)
  let
    (event-prop $ event->prop event-name)
      existing-events $ read-string $ -> target (.-dataset)
        .-events
      new-events-list $ pr-str $ ->> existing-events
        filter $ fn (x)
          not= x event-name
        into $ []

    if (is-no-bubble? event-name)
      aset target event-prop nil
    set!
      -> target (.-dataset)
        .-events
      , new-events-list

defn add-element (target op no-bubble-collection)
  let
    (new-element $ make-element op no-bubble-collection)
      parent-element $ .-parentElement target
      next-element $ .-nextElementSibling target
    if (some? next-element)
      .insertBefore next-element new-element
      .appendChild parent-element new-element

defn rm-element (target op)
  .remove target

defn replace-element (target op no-bubble-collection)
  let
    (new-element $ make-element op no-bubble-collection)
    .insertBefore target new-element
    .remove target

defn append-element (target op no-bubble-collection)
  let
    (new-element $ make-element op no-bubble-collection)
    .appendChild target new-element

defn apply-dom-changes (changes mount-point no-bubble-collection)
  let
    (root $ .-firstChild mount-point)
    doall $ ->> changes $ map $ fn (op)
      let
        (op-type $ first op)
          coord $ get op 1
          op-data $ get op 2
          target $ find-target root coord
        -- .log js/console op-type target op-data
        case op-type
          :replace-prop $ replace-prop target op-data
          :add-prop $ add-prop target op-data
          :rm-prop $ rm-prop target op-data
          :add-style $ add-style target op-data
          :replace-style $ replace-style target op-data
          :rm-style $ rm-style target op-data
          :add-event $ add-event target op-data no-bubble-collection
          :rm-event $ rm-event target op-data
          :add $ add-element target op-data no-bubble-collection
          :rm $ rm-element target op-data
          :replace $ replace-element target op-data no-bubble-collection
          :append $ append-element target op-data no-bubble-collection
          .error js/console "|not implemented:" op-type
