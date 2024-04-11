import 'package:core_util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tool_clind_theme/theme.dart';
import 'package:ui/ui.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await ICoreFirebase.initialize();
  await ICoreFirebaseRemoteConfig.initialize();
  await ICoreFirebaseRemoteConfig.fetchAndActivate();
  runApp(const ClindApp());
}

class ClindApp extends StatefulWidget {
  const ClindApp({super.key});

  @override
  State<ClindApp> createState() => _ClindAppState();
}

class _ClindAppState extends State<ClindApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClindTheme(
      themeData: ClindThemeData.dark(),
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        localizationsDelegates: [
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: [
          const Locale('ko'),
        ],
        initialRoute: ClindRoute.root.path,
        onGenerateRoute: (settings) => IClindRoutes.find(settings),
      ),
    );
  }
}
