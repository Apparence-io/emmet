import 'package:emmet/src/models/test_file.dart';

class HtmlTestFileTemplate {

  TestFile testFile;

  HtmlTestFileTemplate({
    this.testFile
  });

  String generateFile() 
    => 
    '''
      $head
      $body
    ''';

  String get head => '''
    <!doctype html>
    <html lang="en">
    <head>
      <!-- Required meta tags -->
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  
      <!-- Bootstrap CSS -->
      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">

      <title>${testFile.path}</title>
    </head>
  ''';

  String get footer => '';

  String get body => '''
    <body>
      <div class="container">
        <h1 class="mt-5 mb-4">${testFile.path}</h1>
        ${genTable()}
      </div>
      $footer
      <!-- Optional JavaScript -->
      <!-- jQuery first, then Popper.js, then Bootstrap JS -->
      <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
      <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
      <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
    </body>
    </html>
  ''';

  String genTable() => Table(
    children: [
      TableHead(
        children: [
          TableHeaderLine(child: 'Test description'),
          TableHeaderLine(child: 'Assertions'),
        ] 
      ),
      TableBody(
        children: (testFile != null && testFile.tests != null)
          ? testFile.tests.map((test) => TableRow( 
            children: [
              TableCell(child: test.name ?? ''),
              TableCell(child: '${test.assertions.length}')
            ]
          )).toList()
          : []
      )
    ]).generate();
}


class HtmlIndexFileTemplate {

  final String projectName;
  final List<TestFile> testFiles;

  HtmlIndexFileTemplate({
    this.projectName,
    this.testFiles
  });

  String generateFile() 
    => 
    '''
      $_head
      $_body
    ''';

  String get _head => '''
    <!doctype html>
    <html lang="en">
    <head>
      <!-- Required meta tags -->
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  
      <!-- Bootstrap CSS -->
      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">

      <title>$projectName</title>
    </head>
  ''';

  String get _body => '''
    <body>
      <div class="container">
        <h1 class="mt-5 mb-4">$projectName documentation from tests</h1>
        ${_genIndexList()}
      </div>
      <!-- Optional JavaScript -->
      <!-- jQuery first, then Popper.js, then Bootstrap JS -->
      <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
      <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
      <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
    </body>
    </html>
  ''';

  _genIndexList() => ListGroup(
    children: testFiles.map((element) => ListGroupItem(
        children: [
          Link(
            child: ListGroupItemText(child: element.path), 
            link: "./${element.path.split("/").last}.html" // TODO refactor this
          ),
          ListGroupItemTag(child: '${element.tests.length}')
        ]
      )).toList()
  ).generate();
}

abstract class HtmlElement {
  final String tagStart;
  final String tagEnd;
  final String content;

  HtmlElement({this.tagStart, this.tagEnd, this.content});

  String generate() => 
    '''
    $tagStart
      $content
    $tagEnd
    ''';
}

class HtmlSingleElement extends HtmlElement {
  
  HtmlSingleElement({String tagStart, String tagEnd, HtmlElement child}): super(
    tagStart: tagStart,
    tagEnd: tagEnd,
    content: child.generate()
  );
}

class HtmlMultElements extends HtmlElement {
  
  HtmlMultElements({String tagStart, String tagEnd, List<HtmlElement> children}): super(
    tagStart: tagStart,
    tagEnd: tagEnd,
    content: children != null 
      ? children
        .map<String>((elements) => elements.generate())
        .fold('', (value, element) => '$value $element')
      : ''
  );
}

class Table extends HtmlMultElements {
  Table({List<HtmlElement> children}): super(
    tagStart: '''<table class="table table-hover mt-4">''',
    tagEnd: '''</table>''',
    children: children
  );
}

class TableHead extends HtmlMultElements {
  TableHead({List<HtmlElement> children}): super(
    tagStart: '''<thead>''',
    tagEnd: '''</thead>''',
    children: children
  );
}

class TableHeaderLine extends HtmlElement {
  TableHeaderLine({String child}): super(
    tagStart: '''<th scope="col">''',
    tagEnd: '''</th>''',
    content: child
  );
}

class TableBody extends HtmlMultElements {
  TableBody({List<HtmlElement> children}): super(
    tagStart: '''<tbody>''',
    tagEnd: '''</tbody>''',
    children: children
  );
}

class TableRow extends HtmlMultElements {
  TableRow({List<HtmlElement> children}): super(
    tagStart: '''<tr>''',
    tagEnd: '''</tr>''',
    children: children
  );
}

class TableCell extends HtmlElement {
  TableCell({String child}): super(
    tagStart: '''<td>''',
    tagEnd: '''</td>''',
    content: child
  );
}

class ListGroup extends HtmlMultElements {
  ListGroup({List<HtmlElement> children}): super(
    tagStart: '''<ul class="list-group">''',
    tagEnd: '''</ul>''',
    children: children
  );
}

class ListGroupItem extends HtmlMultElements {
  ListGroupItem({List<HtmlElement> children}): super(
    tagStart: '''<li class="list-group-item d-flex justify-content-between align-items-center">''',
    tagEnd: '''</li>''',
    children: children
  );
}

class ListGroupItemText extends HtmlElement {
  ListGroupItemText({String child}): super(
    tagStart: '''<span>''',
    tagEnd: '''</span>''',
    content: child
  );
}

class ListGroupItemTag extends HtmlElement {
  ListGroupItemTag({String child}): super(
    tagStart: '''<span class="badge badge-primary badge-pill">''',
    tagEnd: '''</span>''',
    content: child
  );
}

class Link extends HtmlSingleElement {
  Link({HtmlElement child, String link}): super(
    tagStart: '''<a href="$link">''',
    tagEnd: '''</a>''',
    child: child
  );
}