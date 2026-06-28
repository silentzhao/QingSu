import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hailiao_me_demo/app.dart';
import 'package:hailiao_me_demo/features/risk_places/data/risk_place_store.dart';
import 'package:hailiao_me_demo/features/risk_places/state/risk_place_state.dart';
import 'package:hailiao_me_demo/models/risk_place.dart';

void main() {
  testWidgets('launches into the HailiaoMe guarded map flow', (tester) async {
    await tester.pumpWidget(_testApp());
    await _pumpForEntrance(tester);

    expect(find.text('还了么'), findsOneWidget);
    expect(find.text('添加高风险消费地点'), findsOneWidget);
    expect(find.text('我的提醒地点'), findsOneWidget);
    expect(find.text('首页'), findsOneWidget);
    expect(find.text('记录'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
  });

  testWidgets('add place starts with location selection', (tester) async {
    await tester.pumpWidget(_testApp());
    await _pumpForEntrance(tester);

    await tester.tap(find.byKey(const Key('add-risk-place-button')));
    await _pumpForEntrance(tester);

    expect(find.text('添加地点'), findsOneWidget);
    expect(find.text('搜索商场名或门店'), findsOneWidget);
    expect(find.text('下一步：设置提醒范围'), findsOneWidget);
  });

  test('risk place state persists places and triggers inside radius', () async {
    final store = _MemoryRiskPlaceStore();
    final triggered = <RiskPlace>[];
    final state = RiskPlaceState(
      store: store,
      onTriggered: (place) async => triggered.add(place),
      clock: () => DateTime(2026, 6, 27, 12),
    );
    await Future<void>.delayed(Duration.zero);

    const place = RiskPlace(
      id: 'risk-1',
      name: '星巴克（人民广场店）',
      address: '上海市黄浦区南京东路 123 号',
      latitude: 31.227956,
      longitude: 121.474727,
      radiusMeters: 200,
      reminderText: '先冷静一下，想想这是不是必要消费。',
    );
    await state.upsertPlace(place);

    final matched = await state.evaluatePosition(
      latitude: 31.227956,
      longitude: 121.474727,
    );
    final repeated = await state.evaluatePosition(
      latitude: 31.227956,
      longitude: 121.474727,
    );

    expect(store.savedPlaces, hasLength(1));
    expect(matched, hasLength(1));
    expect(triggered, hasLength(1));
    expect(repeated, isEmpty);
    expect(state.placeById('risk-1')?.lastTriggeredAt, isNotNull);
  });
}

Widget _testApp() {
  return HailiaoMeApp(
    riskPlaceStore: _MemoryRiskPlaceStore(),
  );
}

class _MemoryRiskPlaceStore implements RiskPlaceStore {
  _MemoryRiskPlaceStore([List<RiskPlace> places = const <RiskPlace>[]])
      : savedPlaces = List<RiskPlace>.from(places);

  List<RiskPlace> savedPlaces;

  @override
  Future<List<RiskPlace>> loadRiskPlaces() async {
    return List<RiskPlace>.from(savedPlaces);
  }

  @override
  Future<void> saveRiskPlaces(List<RiskPlace> places) async {
    savedPlaces = List<RiskPlace>.from(places);
  }
}

Future<void> _pumpForEntrance(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 900));
}
