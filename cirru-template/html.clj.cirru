
require $ quote $ [] hiccup.core :refer $ [] html

defn render (data)
  html $ [] :html
    [] :head ([] :title "|Respo Client")
      [] :link $ {} (:type |text/css)
        :href |css/style.css
        :rel |stylesheet
      [] :link $ {} (:type |image/png)
        :rel |icon
        :href |images/respo.png
      [] :style nil "|body * {box-sizing: border-box; scroll-behavior: smooth;}"

    [] :body ({} :style "|margin: 0;")
      [] :div#app
      [] :div#app2
      [] :script $ {} $ :src |cljs/main.js
