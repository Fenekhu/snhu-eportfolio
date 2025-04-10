import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_states/audio_app_state.dart';
import 'package:flutter_application_1/stream_endpoint.dart';
import 'package:flutter_application_1/window_stuff.dart' as window_stuff;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsControl extends StatefulWidget {
  const SettingsControl({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsControlState();
}

class _SettingsControlState extends State<SettingsControl> {
  final MenuController _settingsMenuController = MenuController();

  void _toggleSettingsMenu() {
    _settingsMenuController.isOpen? _settingsMenuController.close() : _settingsMenuController.open();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: MenuAnchor(
        controller: _settingsMenuController,
        clipBehavior: Clip.none,
        menuChildren: [
          // Consumer<SettingsAppState>(
          //   builder: (BuildContext context, SettingsAppState settingsState, Widget? child) {
          //     return MenuItemButton(
          //       onPressed: () => settingsState.cachingPause = !settingsState.cachingPause,
          //       child: CheckableText(
          //         text: "Cache on pause", 
          //         checked: settingsState.cachingPause,
          //       ),
          //     );
          //   },
          // ),
          MenuItemButton(
            onPressed: () async => await launchUrl(Uri.parse("https://www.gensokyoradio.net/")),
            child: Row(
              spacing: 4,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: const Icon(Icons.open_in_new),
                ),
                Text("gensokyoradio.net"),
              ],
            ),
          ),
          DividerWithText("Quality"),
          for (StreamEndpoint ep in StreamEndpoint.list) StreamSourceItem(ep),
          Divider(
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          MenuItemButton(
            onPressed: window_stuff.resetWindowSize,
            child: Text("Reset Window Size"),
          ),
        ],
        child: IconButton(
          iconSize: 32,
          padding: const EdgeInsets.all(0),
          icon: const Icon(Icons.more_horiz),
          onPressed: _toggleSettingsMenu,
        ),
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText(this.text, {super.key,});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(
          indent: 8,
          endIndent: 8,
          color: Colors.grey,
        )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(text),
        ),
        Expanded(child: Divider(
          indent: 8,
          endIndent: 8,
          color: Colors.grey,
        )),
      ],
    );
  }
}

class CheckableText extends StatelessWidget {
  final String text;
  final bool checked;
  const CheckableText({super.key, required this.text, required this.checked});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: checked? const Icon(Icons.check) : null,
        ),
        Text(text),
      ],
    );
  }
}

class StreamSourceItem extends StatelessWidget {
  final StreamEndpoint endpoint;

  const StreamSourceItem(this.endpoint, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioAppState>(
      builder: (BuildContext _, AudioAppState audioState, Widget? child) {
        return MenuItemButton(
          onPressed: () => audioState.endpoint = endpoint,
          child: CheckableText(
            text: endpoint.name, 
            checked: endpoint == audioState.endpoint
          ),
        );
      }
    );
  }
}