import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/main.dart';

void main() {
  testWidgets('Cubox home screen renders core actions', (tester) async {
    await tester.pumpWidget(const CuboxApp());

    expect(find.text('Cubox'), findsWidgets);
    expect(
      find.text('Learn and practice 3x3 PLL algorithms'),
      findsOneWidget,
    );
    expect(find.text('PLL Algorithms'), findsOneWidget);
    expect(find.text('Practice Mode'), findsOneWidget);
  });
}
