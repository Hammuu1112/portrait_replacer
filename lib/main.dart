import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portrait_replacer/data/repositories/path_repository.dart';
import 'package:portrait_replacer/data/repositories/version_repository.dart';
import 'package:portrait_replacer/data/services/version_check_service.dart';
import 'package:provider/provider.dart';
import 'package:portrait_replacer/data/services/path_service.dart';
import 'package:portrait_replacer/ui/starting/widgets/starting_screen.dart';
import 'package:window_manager/window_manager.dart';
import 'package:worker_manager/worker_manager.dart';

Future<void> main() async {
  workerManager.log = kDebugMode;
  await workerManager.init();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(1280, 720),
    minimumSize: Size(960, 540),
    center: true,
    titleBarStyle: TitleBarStyle.hidden,
    title: "Portrait Replacer",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setResizable(false);
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
        Locale('de', 'DE'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
        Locale('ja', 'JP'),
        Locale('pt', 'BR'),
        Locale('ru', 'RU'),
        Locale('tr', 'TR'),
        Locale('zh', 'CN'),
        Locale('zh', 'TW'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => PathService()),
        Provider(create: (context) => VersionCheckService()),
        Provider(create: (context) => PathRepository(service: context.read())),
        Provider(
          create: (context) => VersionRepository(service: context.read()),
        ),
      ],
      child: MaterialApp(
        title: 'Portrait Replacer',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.dark,
          ),
          appBarTheme: AppBarTheme(actionsPadding: EdgeInsets.only(right: 12)),
          sliderTheme: SliderThemeData(year2023: false),
          progressIndicatorTheme: ProgressIndicatorThemeData(year2023: false),
          bottomSheetTheme: BottomSheetThemeData(
            constraints: BoxConstraints(maxWidth: 1280),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: StartingScreen(),
      ),
    );
  }
}
