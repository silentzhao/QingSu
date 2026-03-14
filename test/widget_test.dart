import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:light_food_demo/app.dart';
import 'package:light_food_demo/data/demo_data.dart';
import 'package:light_food_demo/models/app_models.dart';
import 'package:light_food_demo/state/app_preferences_store.dart';
import 'package:light_food_demo/state/app_state.dart';

void main() {
  testWidgets('first launch completes onboarding and enters personalized shell',
      (tester) async {
    final store = _MemoryAppPreferencesStore();

    await tester.pumpWidget(LightFoodDemoApp(preferencesStore: store));
    await _pumpForEntrance(tester);

    expect(find.byKey(const Key('onboarding-brand-step')), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding-primary-button')));
    await _pumpForTransition(tester);

    expect(find.byKey(const Key('onboarding-preference-step')), findsOneWidget);

    await _tapOnboardingOption(tester, 'onboarding-option-protein');
    await _tapOnboardingOption(tester, 'onboarding-option-fresh');
    await _tapOnboardingOption(tester, 'onboarding-option-lunch');

    await tester.tap(find.byKey(const Key('onboarding-primary-button')));
    await _pumpForTransition(tester);

    expect(find.byKey(const Key('onboarding-summary-step')), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding-primary-button')));
    await _pumpForEntrance(tester);

    final state = _readAppState(tester);

    expect(store.hasSeenOnboarding, isTrue);
    expect(store.preferenceIds, <String, String>{
      'goal': 'protein',
      'taste': 'fresh',
      'mealtime': 'lunch',
    });
    expect(state.onboardingComplete, isTrue);
    expect(state.onboardingPreferences?.goal.id, 'protein');
    expect(find.byKey(const Key('review-onboarding-button')), findsOneWidget);
  });

  testWidgets('returning user skips onboarding on launch', (tester) async {
    final store = _MemoryAppPreferencesStore(hasSeenOnboarding: true);

    await tester.pumpWidget(LightFoodDemoApp(preferencesStore: store));
    await _pumpForEntrance(tester);

    expect(find.byKey(const Key('onboarding-brand-step')), findsNothing);
    expect(find.byKey(const Key('review-onboarding-button')), findsOneWidget);
  });

  testWidgets('saved preferences are restored for returning users',
      (tester) async {
    final store = _MemoryAppPreferencesStore(
      hasSeenOnboarding: true,
      preferenceIds: const {
        'goal': 'shape',
        'taste': 'sweet',
        'mealtime': 'snack',
      },
    );

    await tester.pumpWidget(LightFoodDemoApp(preferencesStore: store));
    await _pumpForEntrance(tester);

    final state = _readAppState(tester);

    expect(state.onboardingPreferences?.goal.id, 'shape');
    expect(state.onboardingPreferences?.taste.id, 'sweet');
    expect(state.onboardingPreferences?.mealtime.id, 'snack');

    await _tapNavIcon(tester, Icons.shopping_bag_outlined);
    expect(
      find.byKey(const Key('bag-bundle-pricing-bundle-snack-sweet')),
      findsOneWidget,
    );
  });

  test('updating preferences persists saved preferences', () async {
    final store = _MemoryAppPreferencesStore(
      hasSeenOnboarding: true,
      preferenceIds: const {
        'goal': 'protein',
        'taste': 'fresh',
        'mealtime': 'lunch',
      },
    );

    final appState = AppState(preferencesStore: store);
    await Future<void>.delayed(Duration.zero);

    await appState.updatePreferences(
      OnboardingPreferences(
        goal: onboardingGoalOptions[2],
        taste: onboardingTasteOptions[2],
        mealtime: onboardingMealtimeOptions[1],
      ),
    );

    expect(appState.onboardingPreferences?.goal.id, 'shape');
    expect(appState.onboardingPreferences?.taste.id, 'sweet');
    expect(appState.onboardingPreferences?.mealtime.id, 'snack');
    expect(store.preferenceIds['goal'], 'shape');
    expect(store.preferenceIds['taste'], 'sweet');
    expect(store.preferenceIds['mealtime'], 'snack');
  });

  test('advancing an order updates shared order state', () async {
    final store = _MemoryAppPreferencesStore(hasSeenOnboarding: true);
    final appState = AppState(preferencesStore: store);
    await Future<void>.delayed(Duration.zero);

    final initialOrder = appState.orderById('order-0313-noon');

    expect(initialOrder, isNotNull);

    final initialTitle = initialOrder!.currentProgress!.title;
    final initialTimelineLength = initialOrder.timeline.length;

    appState.advanceOrderProgress('order-0313-noon');

    final updatedOrder = appState.orderById('order-0313-noon');

    expect(updatedOrder, isNotNull);
    expect(updatedOrder!.currentProgress!.title, isNot(equals(initialTitle)));
    expect(updatedOrder.timeline.length, initialTimelineLength + 1);
  });

  testWidgets('order detail page can advance to the next progress state',
      (tester) async {
    final store = _MemoryAppPreferencesStore(hasSeenOnboarding: true);

    await tester.pumpWidget(LightFoodDemoApp(preferencesStore: store));
    await _pumpForEntrance(tester);

    await _tapNavIcon(tester, Icons.person_outline);
    await _pumpForEntrance(tester);
    await _tapFinderSafely(
      tester,
      find.byKey(const Key('profile-latest-order-card')),
    );
    await _pumpForEntrance(tester);

    final initialStatus = tester.widget<Text>(
      find.byKey(const Key('order-current-progress-title')),
    );

    await _tapFinderDirectly(
      tester,
      find.byKey(const Key('advance-order-progress-button')),
    );
    await tester.pump(const Duration(milliseconds: 300));

    final updatedStatus = tester.widget<Text>(
      find.byKey(const Key('order-current-progress-title')),
    );

    expect(updatedStatus.data, isNot(equals(initialStatus.data)));
  });

  test('bundle replacement updates pricing explanation in checkout', () async {
    final store = _MemoryAppPreferencesStore(
      hasSeenOnboarding: true,
      preferenceIds: const {
        'goal': 'shape',
        'taste': 'sweet',
        'mealtime': 'snack',
      },
    );

    final appState = AppState(preferencesStore: store);
    await Future<void>.delayed(Duration.zero);
    final bundle = appState.bagBundleRecommendations.firstWhere(
      (candidate) => candidate.id == 'bundle-snack-sweet',
    );
    final coldBrew = menuItems.firstWhere(
      (item) => item.id == 'cold-brew-oat',
    );
    appState.addBundleToBag(bundle.replaceSlotItem('drink', coldBrew));

    final initialExplanation = appState.checkoutBundlePricingExplanation;

    expect(initialExplanation, contains('40'));

    final cocoaBites = menuItems.firstWhere(
      (item) => item.id == 'cocoa-energy-bites',
    );
    appState.replaceAppliedBundleItem(
      slotId: 'snack',
      item: cocoaBites,
    );

    final updatedExplanation = appState.checkoutBundlePricingExplanation;

    expect(updatedExplanation, contains('42'));
    expect(updatedExplanation, isNot(equals(initialExplanation)));
  });

  testWidgets('bag bundle preview updates before adding to bag',
      (tester) async {
    final store = _MemoryAppPreferencesStore(
      hasSeenOnboarding: true,
      preferenceIds: const {
        'goal': 'shape',
        'taste': 'sweet',
        'mealtime': 'snack',
      },
    );

    await tester.pumpWidget(LightFoodDemoApp(preferencesStore: store));
    await _pumpForEntrance(tester);

    await _tapNavIcon(tester, Icons.shopping_bag_outlined);

    final initialPreview = tester.widget<Text>(
      find.byKey(const Key('bag-bundle-pricing-bundle-snack-sweet')),
    );

    expect(initialPreview.data, contains('38'));

    await _tapFinderSafely(
      tester,
      find.byKey(
        const Key('bundle-choice-bundle-snack-sweet-drink-cold-brew-oat'),
      ),
    );
    await _pumpForTransition(tester);

    final updatedPreview = tester.widget<Text>(
      find.byKey(const Key('bag-bundle-pricing-bundle-snack-sweet')),
    );

    expect(updatedPreview.data, contains('40'));
    expect(updatedPreview.data, isNot(equals(initialPreview.data)));
  });
}

class _MemoryAppPreferencesStore implements AppPreferencesStore {
  _MemoryAppPreferencesStore({
    this.hasSeenOnboarding = false,
    Map<String, String>? preferenceIds,
  }) : preferenceIds = preferenceIds == null
            ? <String, String>{}
            : Map<String, String>.from(preferenceIds);

  bool hasSeenOnboarding;
  Map<String, String> preferenceIds;

  @override
  Future<bool> getHasSeenOnboarding() async => hasSeenOnboarding;

  @override
  Future<Map<String, String>?> getOnboardingPreferenceIds() async {
    if (preferenceIds.length != 3) {
      return null;
    }
    return Map<String, String>.from(preferenceIds);
  }

  @override
  Future<void> setHasSeenOnboarding(bool value) async {
    hasSeenOnboarding = value;
  }

  @override
  Future<void> setOnboardingPreferenceIds(Map<String, String> value) async {
    preferenceIds = Map<String, String>.from(value);
  }
}

AppState _readAppState(WidgetTester tester) {
  final context = tester.element(find.byType(MaterialApp));
  return AppStateScope.read(context);
}

Future<void> _pumpForEntrance(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 900));
}

Future<void> _pumpForTransition(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

Future<void> _tapOnboardingOption(
  WidgetTester tester,
  String keyValue,
) async {
  final finder = find.byKey(Key(keyValue));
  final scrollable = find.byType(Scrollable).first;
  await tester.scrollUntilVisible(finder, 220, scrollable: scrollable);
  await tester.pump();
  final rect = tester.getRect(finder);
  await tester.tapAt(Offset(rect.center.dx, rect.top + 20));
  await tester.pump(const Duration(milliseconds: 150));
}

Future<void> _tapNavIcon(
  WidgetTester tester,
  IconData icon,
) async {
  final finder = find.descendant(
    of: find.byType(NavigationBar),
    matching: find.byIcon(icon),
  );
  await _tapFinderDirectly(tester, finder.first);
  await _pumpForTransition(tester);
}

Future<void> _tapFinderDirectly(
  WidgetTester tester,
  Finder finder,
) async {
  await tester.pump();
  final rect = tester.getRect(finder);
  await tester.tapAt(Offset(rect.center.dx, rect.center.dy));
  await tester.pump(const Duration(milliseconds: 150));
}

Future<void> _tapFinderSafely(
  WidgetTester tester,
  Finder finder,
) async {
  await tester.scrollUntilVisible(
    finder,
    180,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pump();
  final rect = tester.getRect(finder);
  await tester.tapAt(Offset(rect.center.dx, rect.top + 20));
  await tester.pump(const Duration(milliseconds: 150));
}
