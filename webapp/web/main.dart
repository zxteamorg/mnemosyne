import "package:angular/angular.dart" show ClassProvider, ExceptionHandler, GenerateInjector, InjectorFactory, runApp;
import "package:angular_router/angular_router.dart" show routerProviders;
import "package:http/http.dart" show Client;
import "package:http/browser_client.dart" show BrowserClient;

import "package:zxteamorg_mnemosyne/mnemo_service.dart" show MnemoService;
import "package:zxteamorg_mnemosyne/src/mnemo_service_api.dart" show MnemoServiceApi;

import "package:zxteamorg_mnemosyne/application_component.template.dart" as ng;

import "main.template.dart" as self;

@GenerateInjector([
  ClassProvider(MnemoService, useClass: MnemoServiceApi),
  ClassProvider(Client, useClass: BrowserClient),
  routerProviders,
])
final InjectorFactory injector = self.injector$Injector;

void main() {
  ExceptionHandler.debugAsyncStackTraces();
  runApp(ng.ApplicationComponentNgFactory, createInjector: injector);
}
