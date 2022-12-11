import 'package:flutter_tts/flutter_tts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final textToSpeechService = Provider.autoDispose((ref) {
  return TextToSpeech();
});

class TextToSpeech {
  FlutterTts flutterTts = FlutterTts();

  Future init() async {
    await flutterTts.setLanguage("fr-FR");
  }

  Future sayGoodLuck() async {
    await flutterTts.speak("C'est parti, bon courage");
  }

  Future sayPause() async {
    await flutterTts.speak("L'activité est en pause");
  }

  Future sayResume() async {
    await flutterTts.speak("Reprise de l'activité");
  }

  Future sayCongrats() async {
    await flutterTts.speak("Fin de l'activité. Félicitations");
  }

  Future say(String text) async {
    await flutterTts.speak(text);
  }
}
