import 'package:flutter/material.dart';

import 'pages/app_entry.dart';
import 'state/app_preferences_store.dart';
import 'state/app_state.dart';

class LightFoodDemoApp extends StatelessWidget {
  const LightFoodDemoApp({
    super.key,
    this.preferencesStore,
  });

  final AppPreferencesStore? preferencesStore;

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: AppState(
        preferencesStore:
            preferencesStore ?? const SharedPrefsAppPreferencesStore(),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '轻植日常',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF789B56),
            brightness: Brightness.light,
            surface: const Color(0xFFF6F1E8),
          ),
          scaffoldBackgroundColor: const Color(0xFFF6F1E8),
        ),
        home: const AppEntry(),
      ),
    );
  }
}
