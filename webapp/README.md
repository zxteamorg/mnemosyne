## Setup for Development

1. Install [Dart 2.10+](https://dart.dev/get-dart)
1. Create a local copy of this repo (use the "Clone or download" button above).
1. Get CLI tools `pub global activate webdev`
1. Get the dependencies: `pub get`
1. Launch a development server: `pub run build_runner serve --hostname 127.0.0.1 --config devel`
1. In a browser, open [http://127.0.0.1:8080](http://127.0.0.1:8080)

---

https://angulardart.dev/guide
https://dart-lang.github.io/angular_components/


### Hints
#### Building the application 

See:
* [FAQ](https://github.com/dart-lang/build/blob/7002c666513db0fa29756b6ed39c048732b04297/docs/faq.md#how-can-i-build-with-multiple-configurations)
* [Web compilers](https://github.com/dart-lang/build/tree/7002c666513db0fa29756b6ed39c048732b04297/build_web_compilers)

* Build configuration is located inside `build.yaml`
* Build DEVELOPMENT vesion
```bash
webdev build --build-web-compilers --no-release
```
* Build RELEASE version
```bash
webdev build --no-build-web-compilers --release
  OR
webdev build --no-build-web-compilers --release -- '--define=build_web_compilers:entrypoint=dart2js_args=["-O3","-DAPI_ORIGIN=http://127.0.0.1:5000"]'

webdev serve -- '--define=build_web_compilers:ddc=environment={"SOME_VAR":"changed"}'webdev serve -- '--define=build_web_compilers:ddc=environment={"SOME_VAR":"changed"}'
```
* Replace base href and main.devel.dart.js for usage as part of Dashboard Service
```bash
sed -i.bak '
s~main.devel.dart.js~main.dart.js~g
' build/index.html
```
