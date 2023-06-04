import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'l10n/support_locale.dart';
import 'presentation/activity_list/screen/activity_list_screen.dart';
import 'presentation/common/textToSpeech/text_to_speech.dart';
import 'presentation/home/screen/home_screen.dart';
import 'presentation/sum_up/screen/sum_up_screen.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
}

final myAppProvider = Provider((ref) {
  return MyAppViewModel(ref);
});

class MyAppViewModel {
  late Ref ref;

  MyAppViewModel(this.ref);

  void init() {
    ref.read(textToSpeechService).init();
  }

  Future<AppLocalizations> getl10nConf() async {
    var lang = ui.window.locale.languageCode.split('_').first;
    var country = ui.window.locale.languageCode.split('_').last;
    return await AppLocalizations.delegate.load(Locale(lang, country));
  }
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(myAppProvider);
    provider.init();

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
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L10n.support,
        home: const HomeScreen());
  }
}
