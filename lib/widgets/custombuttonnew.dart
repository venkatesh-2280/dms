import 'package:flutter/material.dart';

class CustomButtonNew extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? height;
  final double? borderRadius;

  const CustomButtonNew(
      {super.key,
      required this.text,
      required this.onPressed,
      this.color,
      this.textColor,
      this.height,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.0,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              primary: color ?? Theme.of(context).primaryColor,
              onPrimary: textColor ?? Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 8.0))),
          child: Text(
            text,
            style: TextStyle(color: textColor ?? Colors.white),
          )),
    );
  }
}
