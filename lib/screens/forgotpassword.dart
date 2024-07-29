import 'dart:convert';

import 'package:dms/screens/dashboard.dart';
import 'package:dms/service/apiservice.dart';
import 'package:dms/utils/dimensions.dart';
import 'package:dms/widgets/apptextwidget.dart';
import 'package:dms/widgets/custombutton.dart';
import 'package:dms/widgets/customdialog.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var empcodeController = TextEditingController();
  var emailidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/dmsbgimages.png"),
                    fit: BoxFit.cover)),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.radius10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppTextWidget(
                        controller: empcodeController,
                        hintText: "Employee Code",
                        icon: Icons.person),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextWidget(
                              controller: emailidController,
                              hintText: "Email ID",
                              icon: Icons.person),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Dimensions.height30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          text: "Submit",
                          onPressed: () async {
                            _forgotPassword();
                          },
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          width: Dimensions.width190,
                          borderRadius: Dimensions.radius30,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _forgotPassword() async {
    String empcode = empcodeController.text;
    String email = emailidController.text;
    if (empcode.isEmpty || email.isEmpty) {
      showErrorDialog(context, 'Emp. Code / Email should not be blank');
    } else {
      try {
        final result = await ApiService.forgotpassword(empcode, email);
        String trimmedResult = result.trim();
        print('Response: $trimmedResult');

        if (trimmedResult.contains("Invalid")) {
          showErrorDialog(context, 'Emp. code / Email is incorrect');
        } else {
          var jsonResponse = jsonDecode(trimmedResult);
          int EmpId = jsonResponse['Table'][0]['Emp_Id'];
          showSuccessDialogs(
              context,
              "Please enter OTP received in your registered email address",
              EmpId);
        }
      } catch (e) {
        print('Failed to request password reset: $e');
        showErrorDialog(
            context, 'Failed to request password reset. Please try again.');
      }
    }
  }
}
