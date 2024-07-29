import 'package:flutter/material.dart';

class AppTextWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final bool isPassword;
  final VoidCallback? onTap;

  AppTextWidget({
    required this.controller,
    required this.hintText,
    this.icon,
    this.isPassword = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      ),
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
      onTap: onTap,
      readOnly: onTap != null,
    );
  }
}

class AppTextWidget1 extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final bool isPassword;
  final VoidCallback? onTap;

  AppTextWidget1({
    required this.controller,
    required this.hintText,
    this.icon,
    this.isPassword = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        filled: true,
        fillColor: Colors.grey,
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      ),
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
      onTap: onTap,
      readOnly: onTap != null,
    );
  }
}
