import 'package:emmet/src/models/test_file.dart';

import 'html_templates.dart';

class HtmlGenerator {
  
  Future<List<String>> process(List<TestFile> files) async 
    => files
      .map((file) => HtmlTestFileTemplate(testFile: file).generateFile())
      .toList();

}