import 'dart:io';
import 'dart:ui';

import 'package:dms/screens/indexing.dart';
import 'package:dms/utils/dimensions.dart';
import 'package:dms/widgets/apptextwidget.dart';
import 'package:dms/widgets/custombutton.dart';
import 'package:dms/widgets/custombuttonnew.dart';
import 'package:flutter/material.dart';
import 'package:dms/service/apiservice.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class FileUpload extends StatefulWidget {
  const FileUpload({Key? key}) : super(key: key);

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  var attributeController = TextEditingController();
  var valueController = TextEditingController();

  int? empid;
  int? _selectedDocId;
  int? _selectedDocGroupId;

  final ImagePicker _picker = ImagePicker();
  File? _scannedDocument;

  Future<void> _loadEmpid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      empid = prefs.getInt('Emp_Id');
      print("Employee ID : $empid");
    });
  }

  String? _selectedDocItem;
  List<String> docgroupitem = [];
  List<int> docgroupid = [];
  var documentNameController = TextEditingController();

  String? _selectedDocGroupItem;
  List<String> gitems = [];
  List<String> finalgitems = [];
  List<int> finalgids = [];
  var documentGroupController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEmpid().then((_) {
      _loaddocname();
      _loaddocgroupname();
    });
  }

  Future<void> _onUpload() async {
    // Request permissions
    await Permission.camera.request();
    await Permission.storage.request();

    // Check if permissions are granted
    if (await Permission.camera.isGranted &&
        await Permission.storage.isGranted) {
      // Pick an image from the camera
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        // Get the external directory
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          // Create a file path
          final filePath =
              '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
          final File file = File(filePath);

          // Save the image to the file path
          await file.writeAsBytes(await image.readAsBytes());

          setState(() {
            _scannedDocument = file;
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Document saved to $filePath')));
        }
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Permissions are required')));
    }
  }

  void _onSubmit() async {
    if (_scannedDocument != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Indexing(imageFile: _scannedDocument!)));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No document to submit')));
    }
  }

  void _loaddocname() async {
    if (empid != null) {
      try {
        final response = await ApiService.docnames(empid!);
        print("Docname Response: $response");
        setState(() {
          docgroupitem =
              response.map<String>((item) => item['Dname_Name']).toList();
          docgroupid = response.map<int>((item) => item['Dname_Id']).toList();
        });
      } catch (error) {
        print("Error loading docname: $error");
      }
    } else {
      print("Employee ID is null. Cannot load doc names.");
    }
  }

  void _loaddocgroupname() async {
    if (empid != null) {
      try {
        final response = await ApiService.docgroupsnames(empid!);
        print("Docgroupname Response: $response");
        setState(() {
          gitems = response.map<String>((item) => item['Dgroup_Name']).toList();
        });
      } catch (error) {
        print("Error loading docgroupname: $error");
      }
    } else {
      print("Employee ID or parent code is null. Cannot load docgroupname.");
    }
  }

  void _loadnamegroup(int docgroupid) async {
    if (empid != null) {
      try {
        final response =
            await ApiService.namegroup(empid!, "getdocname", docgroupid);
        setState(() {
          finalgitems = response
              .map<String>((item) => item['Dgroup_Name'] as String)
              .toList();
          finalgids = response.map<int>((item) => item['Dgroup_Id']).toList();
          if (finalgitems.isNotEmpty) {
            _selectedDocGroupItem = finalgitems[0];
            documentGroupController.text = _selectedDocGroupItem!;
            _selectedDocGroupId = finalgids[0];
            print("Auto-selected Doc Group ID: $_selectedDocGroupId");
          } else {
            finalgitems = ["No data"];
            _selectedDocGroupItem = null;
            documentGroupController.clear();
          }
        });
      } catch (error) {
        print("Error loading group names: $error");
        setState(() {
          finalgitems = ["No data"];
        });
      } finally {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "File Upload",
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
          Padding(
            padding: EdgeInsets.all(Dimensions.radius20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: Dimensions.height65,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.note),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              width: double.infinity,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(
                                  "Document Name",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                                value: _selectedDocItem,
                                icon: Icon(Icons.arrow_drop_down_sharp),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.black),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedDocItem = newValue!;
                                    documentNameController.text =
                                        _selectedDocItem!;
                                    int selectedIndex =
                                        docgroupitem.indexOf(_selectedDocItem!);
                                    _selectedDocId = docgroupid[selectedIndex];
                                    print("Selected Doc.ID : $_selectedDocId");
                                    _loadnamegroup(_selectedDocId!);
                                  });
                                },
                                items: docgroupitem
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: Dimensions.height65,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.note),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              width: double.infinity,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(
                                  "Document Group",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                                value: _selectedDocGroupItem,
                                icon: Icon(Icons.arrow_drop_down_sharp),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.black),
                                onChanged: finalgitems.length == 1 &&
                                        finalgitems.contains("No data")
                                    ? null
                                    : (String? newValue) {
                                        setState(() {
                                          _selectedDocGroupItem = newValue!;
                                          documentGroupController.text =
                                              _selectedDocGroupItem!;
                                          int selectedIndex = finalgitems
                                              .indexOf(_selectedDocGroupItem!);
                                          _selectedDocGroupId =
                                              finalgids[selectedIndex];
                                          print(
                                              "Selected Doc. Group.ID : $_selectedDocGroupId");
                                        });
                                      },
                                items: finalgitems
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.8, // 80% of screen width
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _scannedDocument != null
                                ? Image.file(_scannedDocument!)
                                : Text(
                                    'No document scanned',
                                    style: TextStyle(fontSize: 2.0),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      text: "File Upload",
                      onPressed: _onUpload,
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      height: Dimensions.height30,
                      width: Dimensions.height30 * 4,
                      borderRadius: Dimensions.radius30,
                    ),
                    SizedBox(width: Dimensions.height20),
                    CustomButton(
                      text: "Submit",
                      onPressed: _onSubmit,
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      height: Dimensions.height30,
                      width: Dimensions.height30 * 4,
                      borderRadius: Dimensions.radius30,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
