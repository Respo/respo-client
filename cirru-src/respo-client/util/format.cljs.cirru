
ns respo.util.format $ :require $ [] clojure.string :as string

defn dashed->camel
  (x)
    dashed->camel | x false
  (acc piece promoted?)
    if (= piece |)
      , acc
      let
        (cursor $ get piece 0)
          piece-followed $ subs piece 1
        if (= cursor |-)
          recur acc piece-followed true
          recur
            str acc $ if promoted? (string/upper-case cursor)
              , cursor
            , piece-followed false

defn prop->attr (x)
  case x (|class-name |class)
    , x

defn event->string (x)
  subs (name x)
    , 3

defn event->edn (event)
  -- .log js/console "|simplify event:" event
  let
    (simple-event $ case (.-type event) (|click $ {} :type :click) (|keydown $ {} :type :keydown :key-code $ .-keyCode event) (|input $ {} :type :input :value $ .-value $ .-target event) ({} :type (.-type event) (, :msg "|not recognized event")))

    -- .log js/console "|simplify result:" simple-event
    , simple-event
