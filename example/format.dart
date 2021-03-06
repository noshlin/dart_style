import 'package:dart_style/dart_style.dart';

import 'package:dart_style/src/debug.dart';

void main(List<String> args) {
  // Enable debugging so you can see some of the formatter's internal state.
  // Normal users do not do this.
  debugFormatter = true;
  useAnsiColors = true;

  formatStmt("sendPort.send({'type': 'error', 'error': 'oops'});");
  formatUnit("class Foo{}");
}

void formatStmt(String source, [int pageWidth = 40]) {
  runFormatter(source, pageWidth, isCompilationUnit: false);
}

void formatUnit(String source, [int pageWidth = 40]) {
  runFormatter(source, pageWidth, isCompilationUnit: true);
}

void runFormatter(String source, int pageWidth, {bool isCompilationUnit}) {
  try {
    var formatter = new DartFormatter(pageWidth: pageWidth);

    var result;
    if (isCompilationUnit) {
      result = formatter.format(source);
    } else {
      result = formatter.formatStatement(source);
    }

    if (useAnsiColors) {
      result = result.replaceAll(" ", "\u001b[1;30m·\u001b[0m");
    }

    drawRuler("before", pageWidth);
    print(source);
    drawRuler("after", pageWidth);
    print(result);
  } on FormatterException catch (error) {
    print(error.message());
  }
}

void drawRuler(String label, int width) {
  var padding = " " * (width - label.length - 1);
  print("$label:$padding|");
}
