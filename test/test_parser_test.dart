import 'package:emmet/src/models/test_file.dart';
import 'package:emmet/src/test_parser.dart';
import 'package:test/test.dart';

void main() {

  TestParser parser = TestParser();

  test('''
    A test file containing 3 test is parsed,
    => returns a TestFile containing 3 tests
  ''', () {
    var testFileString = '''
      void main() {
        testWidgets('on settings press  => button is disabled',
        (WidgetTester tester) async {
          await beforeEach(tester);
          expect(find.byType(EditorUpdateHelperPage), findsOneWidget);
          var textMode = find.byKey(ValueKey('editableActionBarSettingsButton'));
          await tester.tap(textMode);
          await tester.pumpAndSettle();
        });

        testWidgets('on settings pressed two times',
        (WidgetTester tester) async {
          await beforeEach(tester);
          expect(find.byType(EditorUpdateHelperPage), findsOneWidget);
          expect(find.byType(EditorUpdateHelperPage), findsOneWidget);
          var textMode = find.byKey(ValueKey('editableActionBarSettingsButton'));
          await tester.tap(textMode);
          await tester.pumpAndSettle();
        });

        test('a dart side test',
        () async {
          await beforeEach(tester);
          expect(find.byType(EditorUpdateHelperPage), findsOneWidget);
          expect(find.byType(EditorUpdateHelperPage), findsOneWidget);
          expect(find.byType(EditorUpdateHelperPage), findsOneWidget);
          var textMode = find.byKey(ValueKey('editableActionBarSettingsButton'));
          await tester.tap(textMode);
          await tester.pumpAndSettle();
        });
      }
    ''';
    var res = parser.parse(testFileString);
    expect(res.tests.length, 3);
    // check first test 
    expect(res.tests.first.name, equals('on settings press  => button is disabled'));
    expect(TestType.WIDGET, res.tests.first.type);
    expect('find.byType(EditorUpdateHelperPage)', res.tests[0].assertions.first.expectedExpr);
    expect('findsOneWidget', res.tests[0].assertions.first.actualExpr);
    expect(1, res.tests.first.assertions.length);
    // check second test 
    expect(res.tests[1].name, equals('on settings pressed two times'));
    expect(TestType.WIDGET, res.tests[1].type);
    expect(2, res.tests[1].assertions.length);
    // check third test 
    expect(res.tests[2].name, equals('a dart side test'));
    expect(TestType.DART, res.tests[2].type);
    expect(3, res.tests[2].assertions.length);
  });

  test('''
      A test file containing test in a group is parsed,
      => returns a TestFile with 3 tests
    ''', () {
    var testFileString = r'''
      void main() {
        group('[EditorHelperService] - save simpleHelper', () {
          setUp(() => reset(httpClientMock));

          test('page = "route", version = "1.0.1", helper not exists => page exists, version exists, helper saved', () async {
            await _testCreateHelper(args, expectedHelperResult, () => editorHelperService.saveSimpleHelper(args));
          });

          test('page = "route", version min and max = "1.0.1", helper not exists => page is created, version is created, new helper saved', () async {
            await _testCreateHelperWithVersionAndPage(args, expectedHelperResult, () => editorHelperService.saveSimpleHelper(args));
          });

          test('page = "route", version = "1.0.1", helper exists => page exists, version exists, helper updated', () async {
            await _testUpdateHelper(args, expectedHelperResult, () => editorHelperService.saveSimpleHelper(args));
          });
        });
      }
    ''';
    var res = parser.parse(testFileString);
    expect(res.tests.length, equals(3));
  });
}
