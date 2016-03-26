
# Respo Client

Client side DOM manager for Respo.

![](assets/respo.png)

## Usage

[![Respo Client](https://img.shields.io/clojars/v/mvc-works/respo-client.svg)](https://clojars.org/mvc-works/respo-client)

```clojure
[mvc-works/respo-client "0.1.7"]
```

```clojure
(respo-client.controller.client/initialize-instance mount-point deliver-event)
(respo-client.controller.client/activate-instance virtual-element mount-point deliver-event)
(respo-client.controller.client/patch-instance changes mount-point deliver-event)
(respo-client.controller.client/release-instance mount-point)
```

### Develop

Reload on file change:

```bash
boot dev
```

Just bundle code:

```bash
boot gen-static
```

Build and minimize:

```bash
boot build-app
```

## License

MIT
