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

  factory TestMethod.widget({String name}) => TestMethod(
    name: name,
    type: TestType.WIDGET
  );

  factory TestMethod.dart({String name}) => TestMethod(
    name: name,
    type: TestType.DART
  );
}

class AssertionCall {
  String reason;
  String expectedExpr;
  String actualExpr;
  
  AssertionCall({this.reason, this.expectedExpr, this.actualExpr});
}

enum TestType {
  DART,
  WIDGET
}