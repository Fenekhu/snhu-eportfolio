import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_states/audio_app_state.dart';
import 'package:flutter_application_1/globals.dart';

class VolumeControl extends StatefulWidget {
  final AudioAppState _audioState;
  const VolumeControl(this._audioState, {super.key});

  @override
  State<StatefulWidget> createState() => _VolumeControlState();
}

class _VolumeControlState extends State<VolumeControl> {
  final MenuController _volumeMenuController = MenuController();

  void _toggleVolumeMenu() {
    _volumeMenuController.isOpen? _volumeMenuController.close() : _volumeMenuController.open();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: MenuAnchor(
        controller: _volumeMenuController,
        clipBehavior: Clip.none,
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Color.lerp(Theme.of(context).colorScheme.surface, Colors.grey, 0.25)),
        ),
        menuChildren: [
          Stack(
            children: [
              Container(
                width: 32,
                padding: const EdgeInsets.all(4),
                child: Text(
                  (widget._audioState.audioPlayer.volume * 100).toStringAsFixed(0),
                  textAlign: TextAlign.right,
                )
              ),
              Container(
                height: 32,
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Slider.adaptive(
                  value: widget._audioState.volume, 
                  onChanged: (double newVol) {
                    setState(() {
                      widget._audioState.volume = newVol;
                    });
                  },
                  onChangeEnd: (double newVol) => sharedPrefs.setDouble("volume", newVol),
                ),
              ),
            ],
          )
        ],
        child: IconButton(
          iconSize: 32,
          padding: const EdgeInsets.all(0),
          icon: const Icon(Icons.volume_up),
          onPressed: _toggleVolumeMenu,
        ),
      ),
    );
  }
}