import 'dart:io';

import 'package:dms/screens/dashboard.dart';
import 'package:dms/screens/forgotpassword.dart';
import 'package:dms/utils/dimensions.dart';
import 'package:dms/widgets/apptextwidget.dart';
import 'package:dms/widgets/custombutton.dart';
import 'package:dms/widgets/customdialog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dms/service/apiservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  bool _isHidden = true;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.location,
      Permission.storage,
    ].request();

    statuses.forEach((permission, status) {
      print('$permission: $status');
    });

    if (statuses[Permission.storage]!.isGranted) {
      print("Storage permission granted");
    } else if (statuses[Permission.storage]!.isPermanentlyDenied) {
      print("Storage permission permanently denied");
      openAppSettings();
    } else {
      print("Storage permission denied");
      // _showPermissionDeniedDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/dmsbgimages.png"),
                    fit: BoxFit.cover)),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.radius16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppTextWidget(
                      controller: usernameController,
                      hintText: "Username",
                      icon: Icons.person,
                    ),
                    SizedBox(
                        height: Dimensions
                            .height30), // Use a specific value instead of Dimensions.height30
                    AppTextWidget(
                      controller: passwordController,
                      hintText: "Password",
                      icon: Icons.lock,
                      isPassword: true,
                    ),
                    SizedBox(height: Dimensions.height30),
                    Container(
                      width: Dimensions.width350,
                      height: Dimensions.height10 * 6,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius30),
                        //color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                            text: "Login",
                            onPressed: () async {
                              _login();
                            },
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            width: Dimensions.width20 * 6,
                            borderRadius: Dimensions.radius30,
                          ),
                          // Adding space between buttons
                          CustomButton(
                            text: "Forgot Password",
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword()));
                            },
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            width: Dimensions.width190,
                            borderRadius: Dimensions.radius30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _login() async {
    String username = usernameController.text;
    String password = passwordController.text;
    String iv = "dms";
    if (username.isEmpty && password.isEmpty) {
      showErrorDialog(context, "Please enter username & password");
    } else if (username.isEmpty) {
      showErrorDialog(context, "Please enter username");
    } else if (password.isEmpty) {
      showErrorDialog(context, "Please enter password");
    } else {
      try {
        final response = await ApiService.login(username, password, iv);
        print('Login Success : $response');
        List<dynamic> tableData = response['Table'];
        print('Table Data: $tableData');
        if (tableData.isNotEmpty) {
          var firstItem = tableData[0];
          int empId = firstItem['Emp_Id'];
          print("Emp.ID : $empId");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('Emp_Id', empId);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        } else {
          showErrorDialog(context, "Incorrect Username / Password");
        }
      } catch (error) {
        print('Login Error: $error');
        showErrorDialog(context, "Failed to login");
      }
    }
  }
}
