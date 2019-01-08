import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_firebase_catbox/main.dart';

void main() {
  testWidgets('app should load cats', (WidgetTester tester) async {
    await tester.pumpWidget(CatBoxApp());

    expect(find.text('Cats'), findsOneWidget);
    expect(find.text('Dogs'), findsNothing);
  });
}
