import 'package:flutter_test/flutter_test.dart';
import 'package:light_food_demo/main.dart';

void main() {
  testWidgets('demo renders home branding and navigation', (tester) async {
    await tester.pumpWidget(const LightFoodDemoApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('轻植日常'), findsWidgets);
    expect(find.text('今天吃点轻松的'), findsNothing);
    expect(find.text('首页'), findsOneWidget);
    expect(find.text('推荐'), findsOneWidget);
    expect(find.text('灵感'), findsOneWidget);
    expect(find.text('预约'), findsOneWidget);
  });
}
