import 'dart:async';

import 'package:dms/screens/loginscreen.dart';
import 'package:dms/widgets/customcolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(dmsapp());
}

class dmsapp extends StatefulWidget {
  const dmsapp({Key? key}) : super(key: key);

  @override
  State<dmsapp> createState() => _dmsappState();
}

class _dmsappState extends State<dmsapp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme:
              ThemeData().colorScheme.copyWith(primary: dms.customcolor),
          useMaterial3: true),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/dmsbgimages.png"),
                  fit: BoxFit.cover)),
        ),
        Column(
          children: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/newdms.png"),
                )),
              ),
            ),
          ],
        )
      ],
    );
  }
}
