
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_states/audio_app_state.dart';
import 'package:flutter_application_1/app_states/image_app_state.dart';
import 'package:flutter_application_1/app_states/settings_app_state.dart';
import 'package:flutter_application_1/globals.dart';
import 'package:flutter_application_1/widgets/window_controls.dart';
import 'package:flutter_application_1/widgets/control_bar.dart';
import 'package:flutter_application_1/window_stuff.dart' as window_stuff;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smtc_windows/smtc_windows.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  await SMTCWindows.initialize();

  sharedPrefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: null,
    )
  );

  window_stuff.setupWindow();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext _) => SettingsAppState()),
        ChangeNotifierProvider(create: (BuildContext _) => AudioAppState()),
        ChangeNotifierProvider(create: (BuildContext _) => LiveInfoAppState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gensokyo Radio Mini Player',
      theme: ThemeData.from(colorScheme: const ColorScheme.light()),
      darkTheme: ThemeData.from(colorScheme: const ColorScheme.dark()),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final AssetImage _placeholderArt = AssetImage("assets/images/gr-logo-placeholder.png");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              DragToMoveArea(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Consumer<LiveInfoAppState>(
                    builder: (BuildContext context, LiveInfoAppState imageState, Widget? child) {
                      return Image(
                        image: imageState.albumArtSource ?? _placeholderArt,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Consumer(
                  builder: (BuildContext context, AudioAppState audioState, Widget? child) {
                    return ControlBar(audioState);
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: WindowControls(),
          ),
        ],
      )
    );
  }
}
