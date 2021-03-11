import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

import 'ast_node.dart';
import 'models/test_file.dart';

class TestParser {

  List<TestFile> parseFolder(String path) => _dirContents(Directory(path));

  TestFile parseSingleFile(String path) {
    var file = File(path);
    return parse(file.readAsStringSync())
      ..path = file.path;
  }

  TestFile parse(String fileContent) {
    var result = parseString(content: fileContent, path: '', throwIfDiagnostics: false);
    var rootUnit = result.unit.root;
    var testFile = TestFile(path: '', tests: []);
    _parseNode(rootUnit, testFile);
    return testFile;
  }
  
  _parseNode(AstNode? rootUnit, TestFile testFile, {TestMethod? testMethod}) {
    if(rootUnit == null) {
      return;
    }
    for(final node in rootUnit.childEntities) {
      if(node is MethodInvocation) {
        if(node.isTest) {
          var testMethod = TestMethod.fromNode(node);
          testFile.tests.add(testMethod);
          _parseNode(node, testFile, testMethod: testMethod);
        } else if (node.isExpectation && testMethod != null) {
          testMethod.assertions.add(AssertionCall.fromNode(node));
        }
      } else if(node is AstNode) {
        _parseNode(node, testFile, testMethod: testMethod);
      }
    }
  }

  List<TestFile> _dirContents(Directory dir) {
    if(!dir.existsSync()) {
      throw "Directory not exists";
    }
    var contents = dir.listSync(recursive: true);
    List<TestFile> results = [];
    for (var fileOrDir in contents) {
      if (fileOrDir is File) {
        results.add(
          parse(fileOrDir.readAsStringSync())
            ..path = fileOrDir.path
        );
      }
    }
    return results;
  }

}
