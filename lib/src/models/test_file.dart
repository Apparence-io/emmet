import 'package:analyzer/dart/ast/ast.dart';
import '../ast_node.dart';

class TestFile {
  String path;
  List<TestMethod> tests;

  TestFile({this.path, this.tests});
}

class TestMethod {
  String name;
  TestType type;
  List<AssertionCall> assertions = [];

  TestMethod({this.name, this.type, this.assertions});

  factory TestMethod.fromNode(MethodInvocation node) 
    => TestMethod(
      name: node.arguments.isNotEmpty ? node.arguments.first : 'Undefined',
      type: node.testType,
      assertions: []
    );
}

class AssertionCall {
  String reason;
  String expectedExpr;
  String actualExpr;

  AssertionCall({this.reason, this.expectedExpr, this.actualExpr});

  factory AssertionCall.fromNode(MethodInvocation node) 
    => AssertionCall(
      expectedExpr: node.argumentList.arguments.first.toString(),
      actualExpr: node.argumentList.arguments[1].toString()
    );
}

enum TestType {
  DART,
  WIDGET
}