import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowControls extends StatelessWidget {
  const WindowControls({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: IconButton(
              icon: Icon(Icons.minimize),
              iconSize: 16,
              padding: const EdgeInsets.all(0),
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(),
                ),
              ),
              onPressed: () => windowManager.minimize(),
            ),
          ),
          SizedBox(
            width: 24,
            height: 24,
            child: IconButton(
              icon: Icon(Icons.close),
              iconSize: 16,
              padding: const EdgeInsets.all(0),
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(),
                ),
              ),
              onPressed: () => windowManager.close(),
            ),
          ),
        ],
      )
    );
  }
}