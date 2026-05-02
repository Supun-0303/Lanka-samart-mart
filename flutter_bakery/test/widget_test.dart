import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_bakery/main.dart';

void main() {
  testWidgets('Bakery app renders', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BakeryApp());

    expect(find.text('Tasty Bakery and Pastries'), findsOneWidget);
    expect(
      find.text('Order cakes and pastries with one click.'),
      findsOneWidget,
    );
  });
}
