import "package:angular/angular.dart" show ClassProvider, ExceptionHandler, GenerateInjector, InjectorFactory, runApp;
import "package:angular_router/angular_router.dart" show routerProvidersHash;
import "package:http/http.dart" show Client;
import "package:http/browser_client.dart" show BrowserClient;

import "package:zxteamorg_mnemosyne/mnemo_service.dart" show MnemoService;
import "package:zxteamorg_mnemosyne/src.devel/mnemo_service_stub.dart" show MnemoServiceStub;

import "package:zxteamorg_mnemosyne/application_component.template.dart" as ng;

import "main.devel.template.dart" as self;

@GenerateInjector([
  ClassProvider(MnemoService, useClass: MnemoServiceStub),
  ClassProvider(Client, useClass: BrowserClient),
  routerProvidersHash
])
final InjectorFactory injector = self.injector$Injector;

void main() {
  ExceptionHandler.debugAsyncStackTraces();
  runApp(ng.ApplicationComponentNgFactory, createInjector: injector);
}