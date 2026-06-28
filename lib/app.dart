import 'package:flutter/material.dart';

import 'features/risk_places/data/risk_place_store.dart';
import 'features/risk_places/state/risk_place_state.dart';
import 'pages/app_entry.dart';
import 'services/notification_service.dart';
import 'services/voice_prompt_service.dart';

class HailiaoMeApp extends StatefulWidget {
  const HailiaoMeApp({
    super.key,
    this.riskPlaceStore,
  });

  final RiskPlaceStore? riskPlaceStore;

  @override
  State<HailiaoMeApp> createState() => _HailiaoMeAppState();
}

class _HailiaoMeAppState extends State<HailiaoMeApp> {
  late final NotificationService _notificationService = NotificationService();
  late final VoicePromptService _voicePromptService = VoicePromptService();
  late final RiskPlaceState _riskPlaceState = RiskPlaceState(
    store: widget.riskPlaceStore ?? const SharedPrefsRiskPlaceStore(),
    onTriggered: (place) async {
      await _notificationService.requestPermissions();
      await _notificationService.showRiskPlaceReminder(place);
      await _voicePromptService.speakRiskPlaceReminder(place);
    },
  );

  @override
  void dispose() {
    _riskPlaceState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiskPlaceStateScope(
      notifier: _riskPlaceState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '还了么',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1769FF),
            brightness: Brightness.light,
            surface: const Color(0xFFF7FAFF),
          ),
          scaffoldBackgroundColor: const Color(0xFFF7FAFF),
        ),
        home: const AppEntry(),
      ),
    );
  }
}
