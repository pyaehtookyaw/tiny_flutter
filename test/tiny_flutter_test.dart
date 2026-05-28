import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_flutter/tiny_flutter.dart';

void main() {
  testWidgets('TinyMceEditor builds (stub off-web)', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: TinyMceEditor(heightFactor: 0.2)),
      ),
    );
    expect(find.textContaining('Flutter web only'), findsOneWidget);
  });
}
