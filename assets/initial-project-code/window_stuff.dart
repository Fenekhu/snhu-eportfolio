library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/globals.dart';
import 'package:window_manager/window_manager.dart';

class _MyWindowListener with WindowListener {
    @override
  void onWindowResize() {
    if (Platform.isLinux) saveWindowSize();
  }

  @override
  void onWindowResized() => saveWindowSize();

  @override
  void onWindowMove() {
    if (Platform.isLinux) saveWindowPos();
  }

  @override
  void onWindowMoved() => saveWindowPos();
}

const Size defaultWindowSize = Size(288, 416);

double windowWidth = defaultWindowSize.width;
double windowHeight = defaultWindowSize.height;
Size get windowSize => Size(windowWidth, windowHeight);

void setupWindow() {
  windowWidth = sharedPrefs.getDouble("windowWidth") ?? windowWidth;
  windowHeight = sharedPrefs.getDouble("windowHeight") ?? windowHeight;

  WindowOptions windowOptions = WindowOptions(
    size: Size(windowWidth, windowHeight),
    skipTaskbar: false,
  );

  double? windowX = sharedPrefs.getDouble("windowX");
  double? windowY = sharedPrefs.getDouble("windowY");
  
  windowManager.addListener(_MyWindowListener());

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    //await windowManager.setAspectRatio(windowWidth / windowHeight);
    await windowManager.setMaximizable(false);
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    if (windowX != null && windowY != null) await windowManager.setPosition(Offset(windowX, windowY));
    await windowManager.show();
    await windowManager.focus();
  });
}

void saveWindowSize() async {
  Size size = await windowManager.getSize();
  windowWidth = windowSize.width;
  windowHeight = windowSize.height;
  sharedPrefs.setDouble("windowWidth", size.width);
  sharedPrefs.setDouble("windowHeight", size.height);
}

void saveWindowPos() async {
  Offset pos = await windowManager.getPosition();
  sharedPrefs.setDouble("windowX", pos.dx);
  sharedPrefs.setDouble("windowY", pos.dy);
}

void resetWindowSize() async {
  //await windowManager.setAspectRatio(defaultWindowSize.aspectRatio);
  await windowManager.setSize(defaultWindowSize);
  saveWindowSize();
}
