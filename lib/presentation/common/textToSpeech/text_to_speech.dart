import 'package:flutter_tts/flutter_tts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final textToSpeechService = Provider.autoDispose((ref) {
  return TextToSpeech();
});

class TextToSpeech {
  FlutterTts flutterTts = FlutterTts();

  Future sayGoodLuck() async {
    await flutterTts.setLanguage("fr-FR");
    await flutterTts.speak("C'est parti, bon courage");
  }

  Future say(String text) async {
    await flutterTts.speak(text);
  }
}
