import 'package:flutter/material.dart';
import 'package:tevo/utils/theme_constants.dart';

class CenteredText extends StatelessWidget {
  final String text;

  const CenteredText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: kFontFamily,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
