
ns respo-client.renderer.make-dom $ :require
  [] clojure.string :as string
  [] respo-client.util.format :refer $ [] dashed->camel

defn style->string (styles)
  string/join | $ ->> styles $ map $ fn (entry)
    let
      (k $ first entry)
        v $ last entry
      str (name k)
        , |: v |;

defn make-element (virtual-element no-bubble-collection)
  let
    (tag-name $ name $ :name virtual-element)
      props $ :props virtual-element
      children $ :children virtual-element
      element $ .createElement js/document tag-name
      child-elements $ ->> children $ map $ fn (entry)
        let
          (item $ last entry)
          if (string? item)
            .createTextNode js/document item
            make-element item no-bubble-collection

      event-keys $ into ([])
        keys $ :events virtual-element

    set!
      ->> element (.-dataset)
        .-coord
      pr-str $ :coord virtual-element

    set!
      ->> element (.-dataset)
        .-events
      pr-str event-keys

    doall $ ->> props
      filter $ fn (entry)
        let
          (k $ name $ key entry)
          =
            re-find (re-pattern |^on-.+)
              , k
            , nil

      map $ fn (entry)
        let
          (k $ dashed->camel $ name $ first entry)
            v $ last entry
          .setAttribute element k $ if (= k |style)
            style->string v
            , v
          aset element k $ if (= k |style)
            style->string v
            , v

    doall $ ->> (:events virtual-element)
      map $ fn (entry)
        .log js/console "|Looking into event:" entry
        let
          (event-name $ key entry)
            name-in-string $ string/replace (name event-name)
              , |- |
            maybe-listener $ get no-bubble-collection event-name

          if (some? maybe-listener)
            aset element name-in-string maybe-listener

    doall $ ->> child-elements $ map $ fn (child-element)
      .appendChild element child-element
    , element
