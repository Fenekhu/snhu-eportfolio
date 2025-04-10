import 'dart:developer';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/globals.dart';
import 'package:flutter_application_1/stream_endpoint.dart';
import 'package:just_audio/just_audio.dart';

class AudioAppState extends ChangeNotifier {
  late AudioSession audioSession;
  final audioPlayer = AudioPlayer(
    userAgent: 'myminiplayer/0.1 (Windows)',
  );

  Duration? _pausePos;
  final Stopwatch _pauseWatch = Stopwatch();

  late StreamEndpoint _endpoint;
  StreamEndpoint get endpoint => _endpoint;
  set endpoint(StreamEndpoint value) {
    if (_endpoint == value) return;
    _endpoint = value;
    _pausePos = null;
    _pauseWatch.stop();
    _pauseWatch.reset();
    _updateAudioSource();
    sharedPrefs.setString("endpointName", _endpoint.name);
    notifyListeners();
  }

  double _volume = 1.0;
  double get volume => _volume;
  set volume(double value) {
    _volume = value;
    audioPlayer.setVolume(value);
    notifyListeners();
  }

  AudioAppState() {
    _init();
  }

  void _init() async {
    audioSession = await AudioSession.instance;
    audioSession.configure(const AudioSessionConfiguration.music());

    audioPlayer.playbackEventStream.listen((event) {},
      onError: (Object e, StackTrace trace) {
        log("Stream error", error: e);
      },
    );

    String? endpointName = sharedPrefs.getString("endpointName");
    _endpoint = StreamEndpoint.list.firstWhere(
      (endpoint) => endpointName == endpoint.name,
      orElse: () => StreamEndpoint.list[1],
    );

    _updateAudioSource();

    volume = sharedPrefs.getDouble("volume") ?? 1.0;
  }

  @override
  void dispose() async {
    await audioSession.setActive(false);
    await audioPlayer.dispose();
    super.dispose();
  }

  void _updateAudioSource() async {
    try {
      await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(endpoint.url)));
    } on PlayerException catch (e) {
      log("Error setting audio source: $endpoint", error: e);
    }
  }

  Future<void> play() async {
    if (_pausePos != null) {
      await audioPlayer.seek(_pausePos! + _pauseWatch.elapsed);
      _pausePos = null;
      _pauseWatch.stop();
    }
    await audioSession.setActive(true);
    audioPlayer.play();
    notifyListeners();
  }

  void pause() async {
    await audioPlayer.pause();
    _pausePos = audioPlayer.position;
    _pauseWatch.reset();
    _pauseWatch.start();
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    await audioSession.setActive(false);
    _pausePos = null;
    _pauseWatch.reset();
  }

  void pauseOrStop() {
    bool cachingPause = sharedPrefs.getBool("cachingPause") ?? true;
    cachingPause? pause() : stop();
    notifyListeners();
  }
}
