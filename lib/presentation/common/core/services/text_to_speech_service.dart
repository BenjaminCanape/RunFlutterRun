import 'dart:ui' as ui;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../main.dart';

/// A provider for the text-to-speech service.
final textToSpeechService = Provider((ref) {
  return TextToSpeechService(ref);
});

/// A service for text-to-speech functionality.
class TextToSpeechService {
  late dynamic ref;
  late AppLocalizations translate;
  FlutterTts flutterTts = FlutterTts();

  TextToSpeechService(this.ref);

  /// Initializes the text-to-speech service.
  Future<void> init() async {
    var lang = ui.window.locale.languageCode;
    await flutterTts.setLanguage(lang);
    translate = await ref.read(myAppProvider).getLocalizedConf();
  }

  /// Says "Good luck" using text-to-speech.
  Future<void> sayGoodLuck() async {
    await flutterTts.speak(translate.good_luck);
  }

  /// Says the activity sum-up using text-to-speech.
  Future<void> sayActivitySumUp() async {
    await flutterTts.speak(translate.activity_sumup);
  }

  /// Says "Pause" using text-to-speech.
  Future<void> sayPause() async {
    await flutterTts.speak(translate.pause_activity);
  }

  /// Says "Resume" using text-to-speech.
  Future<void> sayResume() async {
    await flutterTts.speak(translate.resume_activity);
  }

  /// Says the given text using text-to-speech.
  Future<void> say(String text) async {
    await flutterTts.speak(text);
  }
}
