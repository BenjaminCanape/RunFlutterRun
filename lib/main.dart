import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/presentation/home/screen/home_screen.dart';
import 'package:run_flutter_run/presentation/login/screen/login_screen.dart';
import 'package:run_flutter_run/presentation/registration/screen/registration_screen.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'core/jwt_storage.dart';
import 'l10n/support_locale.dart';
import 'presentation/activity_list/screen/activity_list_screen.dart';
import 'presentation/common/textToSpeech/text_to_speech.dart';
import 'presentation/sum_up/screen/sum_up_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
  final Ref ref;

  MyAppViewModel(this.ref);

  void init() {
    ref.read(textToSpeechService).init();
  }

  Future<String?> getJwt() async {
    return JwtUtils.getJwt();
  }

  Future<AppLocalizations> getLocalizedConf() async {
    final lang = ui.window.locale.languageCode;
    final country = ui.window.locale.countryCode;
    return await AppLocalizations.delegate.load(Locale(lang, country));
  }
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key});

  MaterialApp buildMaterialApp(Widget home) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/register': (context) => const RegistrationScreen(),
        '/login': (context) => const LoginScreen(),
        '/sumup': (context) => const SumUpScreen(),
        '/activity_list': (context) => const ActivityListScreen()
      },
      navigatorKey: navigatorKey,
      title: 'Run Flutter Run',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.teal.shade800,
          selectionColor: Colors.teal.shade800,
          selectionHandleColor: Colors.teal.shade800,
        ),
        primaryColor: Colors.teal.shade800,
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.transparent),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.support,
      home: home,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(myAppProvider);

    provider.init();

    return FutureBuilder<String?>(
      future: provider.getJwt(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data != null) {
          return buildMaterialApp(const HomeScreen());
        } else {
          return buildMaterialApp(const LoginScreen());
        }
      },
    );
  }
}
