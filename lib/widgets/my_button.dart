import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;

  final String text;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color disableColor;
  final TextAlign textAlign;

  const MyButton(
    this.text, {
    Key key,
    this.onPressed,
    this.backgroundColor,
    this.disableColor,
    this.textAlign,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 23,
      minWidth: 20,
      elevation: 3,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(top: 0), //todo remove
        child: Text(
          text.toUpperCase(),
          textAlign: textAlign ?? TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.black,
          ).merge(textStyle),
        ),
      ),
      disabledColor: disableColor ?? Colors.grey.withOpacity(0.3),
      disabledTextColor: Colors.black12,
      color: backgroundColor,
    );
  }
}
