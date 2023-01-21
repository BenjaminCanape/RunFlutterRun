import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_run_run/presentation/activity_list/screen/activity_list_screen.dart';
import 'package:run_run_run/presentation/common/textToSpeech/text_to_speech.dart';
import 'package:run_run_run/presentation/home/screen/home_screen.dart';
import 'package:run_run_run/presentation/sum_up/screen/sum_up_screen.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

final myAppProvider = Provider.autoDispose((ref) {
  return MyAppViewModel(ref);
});

class MyAppViewModel {
  late Ref ref;

  MyAppViewModel(this.ref) {
    ref.read(textToSpeechService).init();
  }
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(myAppProvider);

    return MaterialApp(
        initialRoute: '/',
        routes: {
          '/sumup': (context) => const SumUpScreen(),
          '/activity_list': (context) => const ActivityListScreen()
        },
        title: 'Run Flutter Run',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: Colors.transparent),
        ),
        home: const HomeScreen());
  }
}
