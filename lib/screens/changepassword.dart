import 'package:dms/screens/dashboard.dart';
import 'package:dms/service/apiservice.dart';
import 'package:dms/utils/dimensions.dart';
import 'package:dms/widgets/apptextwidget.dart';
import 'package:dms/widgets/custombutton.dart';
import 'package:dms/widgets/customdialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dms/service/apiservice.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var oldpasswordController = TextEditingController();
  var newpasswordController = TextEditingController();
  var confirmpasswordController = TextEditingController();
  String? oldpwd;
  String? newpwd;
  String? confpwd;
  int? empid;

  @override
  void initState() {
    super.initState();
    _loadEmpid();
  }

  Future<void> _loadEmpid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      empid = prefs.getInt('Emp_Id');
      print("Employee ID : $empid");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
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
                        controller: oldpasswordController,
                        hintText: "Old Password",
                        icon: Icons.lock),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextWidget(
                              controller: newpasswordController,
                              hintText: "New Password",
                              icon: Icons.lock),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextWidget(
                              controller: confirmpasswordController,
                              hintText: "Confirm Password",
                              icon: Icons.lock),
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
                          text: "Change Password",
                          onPressed: () async {
                            _changePassword();
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

  void _changePassword() async {
    oldpwd = oldpasswordController.text;
    newpwd = newpasswordController.text;
    confpwd = confirmpasswordController.text;
    if (oldpwd!.isEmpty || newpwd!.isEmpty || confpwd!.isEmpty) {
      showErrorDialog(context, "Please fill all the fields");
    } else if (newpwd! != confpwd!) {
      showErrorDialog(
          context, "New password and Confirm password are not matching");
    } else {
      try {
        final response = await ApiService.changePassword(
          userName: empid.toString(),
          password: '343434',
          iv: 'abcedf',
          oldPassword: oldpwd!,
          newPassword: newpwd!,
          cpassword: confpwd!,
        );
        if (response.toString() == "Password Changed Succesfully.!") {
          showSuccessDialog(context, response.toString());
        } else if (response.toString() == "Incorrect Old password.!") {
          showErrorDialog(context, response.toString());
        }
        print('Response: $response');
      } catch (e) {
        print('Failed to change password: $e');
      }
    }
  }
}
