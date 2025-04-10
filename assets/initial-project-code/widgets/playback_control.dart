import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_states/audio_app_state.dart';
import 'package:just_audio/just_audio.dart';

class PlaybackControl extends StatefulWidget {
  final AudioAppState _audioState;
  const PlaybackControl(this._audioState, {super.key});

  @override
  State<PlaybackControl> createState() => _PlaybackControlState();
}

class _PlaybackControlState extends State<PlaybackControl> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: StreamBuilder<PlayerState>(
        stream: widget._audioState.audioPlayer.playerStateStream,
        builder: (BuildContext _, AsyncSnapshot<PlayerState> snapshot) {
          final PlayerState? playerState = snapshot.data;
          final ProcessingState? processingState = playerState?.processingState;
          final bool? playing = playerState?.playing;
          final IconButton playButton = IconButton(
            icon: const Icon(Icons.play_arrow),
            iconSize: 32,
            padding: const EdgeInsets.all(0),
            onPressed: widget._audioState.play,
            );
          if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
            return CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onSurface,
              strokeAlign: CircularProgressIndicator.strokeAlignInside,
            );
          } else if (playing != true) {
            return playButton; 
          } else if (processingState != ProcessingState.completed) {
            return IconButton(
              icon: const Icon(Icons.stop),
              iconSize: 32,
              padding: const EdgeInsets.all(0),
              onPressed: widget._audioState.pauseOrStop,
            );
          } else {
            log("Unexpected player state: processingState: ${processingState?.name}, playing: $playing");
            return playButton;
          }
        }
      ),
    );
  }
}