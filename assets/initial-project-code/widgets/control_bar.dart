import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_states/audio_app_state.dart';
import 'package:flutter_application_1/widgets/info_text.dart';
import 'package:flutter_application_1/widgets/playback_control.dart';
import 'package:flutter_application_1/widgets/settings_control.dart';
import 'package:flutter_application_1/widgets/volume_control.dart';

class ControlBar extends StatelessWidget {
  final AudioAppState _audioState;
  const ControlBar(this._audioState, {super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return FractionallySizedBox(
      widthFactor: 5.0/6,
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InfoText(),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4,
              children: [
                Text("0:00"),
                Expanded(
                  child: LinearProgressIndicator(
                    value: null,
                    backgroundColor: colors.onSurface.withAlpha(127),
                    color: colors.onSurface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Text("10:00"),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              VolumeControl(_audioState),
              Spacer(),
              PlaybackControl(_audioState),
              Spacer(),
              SettingsControl(),
            ],
          ),
        ],
      ),
    );
  }
}
