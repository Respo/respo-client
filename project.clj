(defproject mvc-works/respo-client "0.1.0"
  :description "Responsive DOM library"
  :url "https://github.com/mvc-works/respo-client"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [org.clojure/clojurescript "1.7.228"]
                 [hiccup "1.0.5"]
                 [binaryage/devtools "0.5.2"]
                 [org.clojure/core.async "0.2.374"]]
  :plugins [[cirru/lein-sepal "0.0.17"]
            [mvc-works/lein-html-entry "0.0.2"]
            [lein-cljsbuild "1.1.2"]
            [lein-figwheel "0.5.0-6"]]
  :cirru-sepal {:paths ["cirru-src" "cirru-template"]}
  :html-entry {:file "template/html.clj" :output "resources/public/index.html"}
  :clean-targets ^{:protect false} [:target-path "resources/public/cljs"]
  :main ^:skip-aot respo-client.core
  :target-path "target/%s"
  :cljsbuild {:builds {:web-dev {:source-paths ["src"]
                                 :figwheel {:websocket-host "repo"
                                            :on-jsload "respo-client.core/fig-reload"}
                                 :compiler {:main respo-client.core
                                            :asset-path "cljs/out"
                                            :output-to  "resources/public/cljs/main.js"
                                            :output-dir "resources/public/cljs/out"
                                            :verbose true}}
                       :web-prod {:source-paths ["src"]
                              :compiler {:output-to "resources/public/cljs/main.js"
                                         :optimizations :advanced
                                         :pretty-print false}}}}
  :figwheel {:css-dirs ["resources/public/css"]
             :server-port 3450
             :load-warninged-code false}
  :profiles {:uberjar {:aot :all}}
  :parallel-build true)
