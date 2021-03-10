import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

import 'ast_node.dart';
import 'models/test_file.dart';

class TestParser {

  List<TestFile> parseFolder(String path) {
    throw "not implemented";
  }

  TestFile parseSingleFile(String path) {
    throw "not implemented";
  }

  TestFile parse(String fileContent) {
    var result = parseString(content: fileContent, path: '', throwIfDiagnostics: false);
    var rootUnit = result.unit.root;
    var testFile = TestFile(path: '', tests: []);
    _parseNode(rootUnit, testFile);
    return testFile;
  }
  
  _parseNode(AstNode rootUnit, TestFile testFile, {TestMethod testMethod}) {
    if(rootUnit == null) {
      return;
    }
    for(final node in rootUnit.childEntities) {
      if(node is MethodInvocation) {
        if(node.isTest) {
          var testMethod = TestMethod(
            name: node.arguments.first.stringValue,
            type: node.testType,
            assertions: []
          );
          testFile.tests.add(testMethod);
          _parseNode(node, testFile, testMethod: testMethod);
        } else if (node.isExpectation && testMethod != null) {
          testMethod.assertions.add(AssertionCall(
            expectedExpr: node.argumentList.arguments.first.toString(),
            actualExpr: node.argumentList.arguments[1].toString()
          ));
        }
      } else if(node is AstNode) {
        _parseNode(node, testFile, testMethod: testMethod);
      }
    }
  }

  List<TestFile> dirContents(Directory dir) {
    var contents = dir.listSync(recursive: true);
    List<TestFile> results = [];
    for (var fileOrDir in contents) {
      if (fileOrDir is File) {
        results.add(TestFile(path: fileOrDir.path));
      }
    }
    return results;
  }
}
