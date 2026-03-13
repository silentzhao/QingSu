import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:light_food_demo/app.dart';

void main() {
  testWidgets('demo renders onboarding and enters main shell', (tester) async {
    await tester.pumpWidget(const LightFoodDemoApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('轻植日常'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('进入轻植日常'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('进入轻植日常'), findsOneWidget);

    await tester.tap(find.text('进入轻植日常'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('首页'), findsOneWidget);
    expect(find.text('推荐'), findsOneWidget);
    expect(find.text('灵感'), findsOneWidget);
    expect(find.text('购物袋'), findsOneWidget);
    expect(find.text('我的'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
  });
}
