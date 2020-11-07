import "package:angular/angular.dart";
import "package:http/http.dart";

import "package:zxteamorg_mnemosyne/app_component.template.dart"
    as ng;

import "main-mock.template.dart" as self;

import "package:zxteamorg_mnemosyne/mnemo_mock_client.dart" show MnemoMockClient;

@GenerateInjector([
  ClassProvider(Client, useClass: MnemoMockClient),
])
final InjectorFactory injector = self.injector$Injector;

void main() {
  ExceptionHandler.debugAsyncStackTraces();
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
