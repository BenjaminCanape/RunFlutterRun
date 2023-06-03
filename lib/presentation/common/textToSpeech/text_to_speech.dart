import 'package:flutter_tts/flutter_tts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final textToSpeechService = Provider.autoDispose((ref) {
  return TextToSpeech();
});

class TextToSpeech {
  FlutterTts flutterTts = FlutterTts();
  var translate;

  Future init(context) async {
    translate = AppLocalizations.of(context);
    await flutterTts.setLanguage("fr-FR");
  }

  Future sayGoodLuck() async {
    await flutterTts.speak(translate.good_luck);
  }

  Future sayActivitySumUp() async {
    await flutterTts.speak(translate.activity_sumup);
  }

  Future sayPause() async {
    await flutterTts.speak(translate.pause_activiy);
  }

  Future sayResume() async {
    await flutterTts.speak(translate.resume_activity);
  }

  Future sayCongrats() async {
    await flutterTts.speak(translate.congrats);
  }

  Future say(String text) async {
    await flutterTts.speak(text);
  }
}
