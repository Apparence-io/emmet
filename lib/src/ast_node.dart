import 'package:analyzer/dart/ast/ast.dart';

import 'models/test_file.dart';

extension MethodExt on MethodInvocation {

  List<String> get arguments 
    => argumentList.arguments.whereType<SimpleStringLiteral>()
          .map((e) => e.stringValue)
          .toList();

  bool get isWidgetTest => methodName.name == "testWidgets";

  bool get isDartTest => methodName.name == "test";

  bool get isExpectation => methodName.name == "expect";

  bool get isGroup => methodName.name == "group";

  bool get isTest => isWidgetTest || isDartTest;

  TestType get testType {
    if(isWidgetTest) {
      return TestType.WIDGET;
    } else if (isDartTest) {
      return TestType.DART;
    }
    throw "NOT A TEST";
  }
}