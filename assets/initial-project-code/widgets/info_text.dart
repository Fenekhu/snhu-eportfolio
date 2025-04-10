import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

String _constructBottomText(String? album, String? circle) {
  album ??= "(unknown album)";
  circle ??= "(unknown circle)";
  return "$album    —    $circle";
}

bool _willTextOverflow({required String text, required TextStyle style, required double maxWidth}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: maxWidth);

  return textPainter.didExceedMaxLines;
}

class _MyMarquee extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double maxWidth;
  const _MyMarquee({required this.text, required this.style, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return _willTextOverflow(text: text, style: style, maxWidth: maxWidth)?
      Marquee(
        text: text,
        blankSpace: 48,
        pauseAfterRound: const Duration(seconds: 10),
        startAfter: const Duration(seconds: 10),
        showFadingOnlyWhenScrolling: false,
        velocity: 16,
        style: style,
      )
      :
      Text(text, style: style, maxLines: 1);
  }
}

class InfoText extends StatelessWidget {
  final TextStyle _songTitleStyle = const TextStyle(fontWeight: FontWeight.bold);
  final TextStyle _otherInfoStyle = const TextStyle(color: Colors.grey);
  const InfoText({super.key});

  @override
  Widget build(BuildContext context) {
    final String songTitle = "Song Title";
    final String bottomText = _constructBottomText(null, null);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
              child: _MyMarquee(
                text: songTitle, 
                style: _songTitleStyle, 
                maxWidth: constraints.maxWidth,
              ),
            ),
            SizedBox(
              height: 20,
              child: _MyMarquee(
                text: bottomText, 
                style: _otherInfoStyle, 
                maxWidth: constraints.maxWidth,
              ),
            ),
          ],
        );
      },
    );
  }
}