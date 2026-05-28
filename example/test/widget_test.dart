import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('Home shows create and update buttons', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Create article'), findsOneWidget);
    expect(find.text('Update article'), findsOneWidget);
  });
}
