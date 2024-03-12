import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'core/utils/storage_utils.dart';
import 'l10n/support_locale.dart';
import 'presentation/common/core/services/text_to_speech_service.dart';
import 'presentation/common/core/utils/color_utils.dart';
import 'presentation/common/core/utils/ui_utils.dart';
import 'presentation/home/screens/home_screen.dart';
import 'presentation/login/screens/login_screen.dart';
import 'presentation/my_activities/screens/activity_list_screen.dart';
import 'presentation/new_activity/screens/sum_up_screen.dart';
import 'presentation/registration/screens/registration_screen.dart';

/// Global navigator key to access the navigator from anywhere in the app.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    const ProviderScope(child: MyApp()),
  );

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
}

/// Provider for the MyAppViewModel.
final myAppProvider = Provider((ref) {
  return MyAppViewModel(ref);
});

/// ViewModel for the main app.
class MyAppViewModel {
  final Ref ref;

  MyAppViewModel(this.ref);

  /// Initializes the app, e.g., initializes services.
  void init() {
    ref.read(textToSpeechService).init();
  }

  /// Retrieves the JWT token from storage.
  Future<String?> getJwt() async {
    return StorageUtils.getJwt();
  }

  /// Retrieves the localized configuration based on the current locale.
  Future<AppLocalizations> getLocalizedConf() async {
    final lang = ui.window.locale.languageCode;
    final country = ui.window.locale.countryCode;
    return await AppLocalizations.delegate.load(Locale(lang, country));
  }
}

/// The main app widget.
class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  /// Builds the MaterialApp with the provided home widget.
  MaterialApp buildMaterialApp(Widget home) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/register': (context) => RegistrationScreen(),
        '/login': (context) => LoginScreen(),
        '/sumup': (context) => const SumUpScreen(),
        '/activity_list': (context) => ActivityListScreen()
      },
      navigatorKey: navigatorKey,
      title: 'Run Flutter Run',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ColorUtils.main,
          selectionColor: ColorUtils.main,
          selectionHandleColor: ColorUtils.main,
        ),
        primaryColor: ColorUtils.main,
        splashColor: ColorUtils.blueGreyDarker,
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: ColorUtils.transparent),
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
          return buildMaterialApp(Center(child: UIUtils.loader));
        } else if (snapshot.hasData && snapshot.data != null) {
          return buildMaterialApp(const HomeScreen());
        } else {
          return buildMaterialApp(LoginScreen());
        }
      },
    );
  }
}
