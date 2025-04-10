import 'dart:developer';
import 'package:flutter/material.dart';

class LiveInfoAppState extends ChangeNotifier {
  NetworkImage? _albumArtSource;
  NetworkImage? get albumArtSource => _albumArtSource;
  
  void setAlbumArt(String? url) {
    if (url?.isEmpty ?? true) _albumArtSource = null;
    try {
      _albumArtSource = NetworkImage(url!);
    } catch (e) {
      log("Error loading network image", error: e);
      _albumArtSource = null;
    }
    notifyListeners();
  }
}
