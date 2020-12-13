@TestOn("browser")

import "package:zxteamorg_mnemosyne/application_component.dart" show ApplicationComponent;
import "package:zxteamorg_mnemosyne/app_component.template.dart"
    as ng;
import "package:angular_test/angular_test.dart" show NgTestBed, NgTestFixture, disposeAnyRunningTest;
import "package:test/test.dart" show TestOn, expect, setUp, tearDown, test;

void main() {
  final testBed =
      NgTestBed.forComponent<ApplicationComponent>(ng.ApplicationComponentNgFactory);
  NgTestFixture<ApplicationComponent> fixture;

  setUp(() async {
    fixture = await testBed.create();
  });

  tearDown(disposeAnyRunningTest);

  // test('Default greeting', () {
  //   expect(fixture.text, 'Hello Angular');
  // });

  // test('Greet world', () async {
  //   await fixture.update((c) => c.name = 'World');
  //   expect(fixture.text, 'Hello World');
  // });

  // test('Greet world HTML', () {
  //   final html = fixture.rootElement.innerHtml;
  //   expect(html, '<h1>Hello Angular</h1>');
  // });
}
