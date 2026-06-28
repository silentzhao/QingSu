import 'package:flutter_tts/flutter_tts.dart';

import '../models/risk_place.dart';

class VoicePromptService {
  VoicePromptService({
    FlutterTts? tts,
  }) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;
  bool _configured = false;

  Future<void> speakRiskPlaceReminder(RiskPlace place) async {
    if (!_configured) {
      await _tts.setLanguage('zh-CN');
      await _tts.setSpeechRate(0.48);
      await _tts.setVolume(1);
      _configured = true;
    }
    await _tts.stop();
    await _tts.speak(place.reminderText);
  }
}
