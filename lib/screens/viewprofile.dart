import 'package:dms/service/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({Key? key}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  int? empid;
  String? emplid;
  String? empname;
  String? empmobno;
  String? empemail;
  String? emprole;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmpid().then((_) {
      _loadProfile();
    });
  }

  Future<void> _loadEmpid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      empid = prefs.getInt('Emp_Id');
      print("Employee ID : $empid");
    });
  }

  Future<void> _loadProfile() async {
    if (empid != null) {
      try {
        final response = await ApiService.profile(empid!);
        print("Profile Response : $response");
        Map<String, dynamic> tableData = response;
        if (tableData.isNotEmpty) {
          setState(() {
            emplid = tableData['EmpCode'];
            empname = tableData['EmpName'];
            empmobno = tableData['EmpMobileNo'];
            empemail = tableData['EmpEmailId'];
            emprole = tableData['EmpRole'];
          });
        }
      } catch (error) {
        print("Error loading profile: $error");
        // Handle error
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "View Profile",
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
          Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white70,
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Emp. ID : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${emplid ?? 'No data'}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Emp. Name : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${empname ?? 'No data'}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Mobile No : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${empmobno ?? 'No data'}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Email : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${empemail ?? 'No data'}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Role : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${emprole ?? 'No data'}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    Visibility(
                        visible: _isLoading,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
