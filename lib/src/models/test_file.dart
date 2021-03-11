import 'package:analyzer/dart/ast/ast.dart';
import 'package:json_serializable/builder.dart';
import 'package:json_annotation/json_annotation.dart';
import '../ast_node.dart';

part 'test_file.g.dart';

@JsonSerializable()
class TestFile {
  String path;
  List<TestMethod> tests;

  TestFile({required this.path, required this.tests});

  factory TestFile.fromJson(Map<String, dynamic> json) => _$TestFileFromJson(json); 

  Map<String, dynamic> toJson() => _$TestFileToJson(this);    
}

@JsonSerializable()
class TestMethod {
  String? name;
  TestType type;
  List<AssertionCall> assertions = [];

  TestMethod({required this.name, required this.type, required this.assertions});

  factory TestMethod.fromNode(MethodInvocation node) 
    => TestMethod(
      name: node.arguments.first.stringValue,
      type: node.testType,
      assertions: []
    ); 
  
  factory TestMethod.fromJson(Map<String, dynamic> json) => _$TestMethodFromJson(json);

  Map<String, dynamic> toJson() => _$TestMethodToJson(this);  

}

@JsonSerializable()
class AssertionCall {
  String? reason;
  String expectedExpr;
  String actualExpr;

  AssertionCall({this.reason, required this.expectedExpr, required this.actualExpr});

  factory AssertionCall.fromNode(MethodInvocation node) 
    => AssertionCall(
      expectedExpr: node.argumentList.arguments.first.toString(),
      actualExpr: node.argumentList.arguments[1].toString()
    );

  factory AssertionCall.fromJson(Map<String, dynamic> json) => _$AssertionCallFromJson(json); 

  Map<String, dynamic> toJson() => _$AssertionCallToJson(this);    
}

enum TestType {
  DART,
  WIDGET
}