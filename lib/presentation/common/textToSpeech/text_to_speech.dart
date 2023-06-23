import 'dart:ui' as ui;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../main.dart';

final textToSpeechService = Provider((ref) {
  return TextToSpeech(ref);
});

class TextToSpeech {
  late dynamic ref;
  late AppLocalizations translate;
  FlutterTts flutterTts = FlutterTts();

  TextToSpeech(this.ref);

  Future<void> init() async {
    var lang = ui.window.locale.languageCode;
    await flutterTts.setLanguage(lang);
    translate = await ref.read(myAppProvider).getLocalizedConf();
  }

  Future<void> sayGoodLuck() async {
    await flutterTts.speak(translate.good_luck);
  }

  Future<void> sayActivitySumUp() async {
    await flutterTts.speak(translate.activity_sumup);
  }

  Future<void> sayPause() async {
    await flutterTts.speak(translate.pause_activity);
  }

  Future<void> sayResume() async {
    await flutterTts.speak(translate.resume_activity);
  }

  Future<void> sayCongrats() async {
    await flutterTts.speak(translate.congrats);
  }

  Future<void> say(String text) async {
    await flutterTts.speak(text);
  }
}
