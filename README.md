
# Respo Client

Client side DOM manager for Respo.

![](resources/public/images/respo.png)

## Usage

[![Respo Client](https://img.shields.io/clojars/v/mvc-works/respo-client.svg)](https://clojars.org/mvc-works/respo-client)

```clojure
[mvc-works/respo-client "0.1.1"]
```

```clojure
(respo-client.controller.client/initialize-instance mount-point deliver-event)
(respo-client.controller.client/activate-instance virtual-element mount-point deliver-event)
(respo-client.controller.client/patch-instance changes mount-point deliver-event)
(respo-client.controller.client/release-instance mount-point)
```

## License

Copyright © 2016 jiyinyiyong

Distributed under the Eclipse Public License either version 1.0 or (at
your option) any later version.
