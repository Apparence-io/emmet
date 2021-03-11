import 'package:emmet/src/models/test_file.dart';

import 'html_templates.dart';

class HtmlGenerator {
  
  Future<List<String>> process(List<TestFile> files) async 
    => files
      .map((file) => HtmlTestFileTemplate(testFile: file).generateFile())
      .toList();

  Future<String> processSingle(TestFile file) async 
    => HtmlTestFileTemplate(testFile: file).generateFile();

  Future<String> createIndex(String projectName, List<TestFile> files) async 
    => HtmlIndexFileTemplate(
      projectName: projectName, 
      testFiles: files
    ).generateFile();
}