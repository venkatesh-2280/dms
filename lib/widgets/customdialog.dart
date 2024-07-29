import 'package:dms/screens/dashboard.dart';
import 'package:dms/screens/loginscreen.dart';
import 'package:dms/screens/otpscreen.dart';
import 'package:flutter/material.dart';

void showSuccessDialogs(BuildContext context, String message, int empId) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[900],
          title: Text(
            'Success',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OtpScreen(
                                empId: empId,
                              )));
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        );
      });
}

void showSuccessDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[900],
          title: Text(
            'Success',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        );
      });
}

void showSuccessDialog1(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[900],
          title: Text(
            'Success',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        );
      });
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[900],
          title: Text(
            'Alert',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        );
      });
}
