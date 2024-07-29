import 'dart:ui';

import 'package:dms/utils/dimensions.dart';
import 'package:dms/widgets/apptextwidget.dart';
import 'package:dms/widgets/custombutton.dart';
import 'package:dms/widgets/custombuttonnew.dart';
import 'package:flutter/material.dart';
import 'package:dms/service/apiservice.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SearchReterival extends StatefulWidget {
  const SearchReterival({Key? key}) : super(key: key);

  @override
  State<SearchReterival> createState() => _SearchReterivalState();
}

class _SearchReterivalState extends State<SearchReterival> {
  var attributeController = TextEditingController();
  var valueController = TextEditingController();
  bool _showCardList = false;

  int? empid;

  int? _selectedDocId;
  int? _selectedDocGroupId;

  int? _finalselectedDocId;
  int? _finalselectedDocGroupId;

  Future<void> _loadEmpid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      empid = prefs.getInt('Emp_Id');
      print("Employee ID : $empid");
    });
  }

  Future<void> _openPDF(String url) async {
    try {
      final dir = await getExternalStorageDirectory();
      final filePath = '${dir!.path}/${url.split('/').last}';
      print('Downloading to: $filePath');

      // Download the file
      await Dio().download(url, filePath);

      // Open the downloaded file
      OpenFile.open(filePath);
    } catch (e) {
      print('Error opening PDF: $e');
    }
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

  List<String> labels = [];
  String? selectedLabel;
  var labelsController = TextEditingController();

  String? constraints;
  final List<String> cons = [
    'is equal to',
    'contains',
    'Begins with',
    'Ends with'
  ];
  var consController = TextEditingController();

  String? amountconstraints;
  final List<String> amountcons = [
    'equals',
    'not equals',
    'is greater than',
    'is less than',
    'is less than or equal to',
    'is greater than or equal to'
  ];
  var consAmountController = TextEditingController();

  String? dateconstraints;
  final List<String> datecons = [
    'equals',
    'not equals',
    'is greater than',
    'is less than',
    'is less than or equal to',
    'is greater than or equal to'
  ];
  var consDateController = TextEditingController();
  String? dates;

  DateTime _selectedDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  var dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        dateController.text = dateFormat.format(picked);
        dates = dateController.text;
        print("Selected Date : $dates"); // Format date as needed
      });
    }
  }

  late Future<List<dynamic>> _futureUsers;
  late Future<List<dynamic>> _futureUsersFilter;
  bool _useFilter = false;
  String _errorMessage = '';
  bool _isLoading = false;
  bool _isDateConstraint = false;

  @override
  void initState() {
    super.initState();
    _loadEmpid().then((_) {
      _loaddocname();
      _loaddocgroupname();
      _loadLabels();
    });
  }

  void _onSubmit() {
    _fetchUsers();
    _loadLabels();
    setState(() {
      _showCardList = true; // Update state to show card list
    });
  }

  void _fetchUsers() {
    if (_selectedDocId != null && _selectedDocGroupId != null) {
      _futureUsers = ApiService.getUser(_selectedDocId!, _selectedDocGroupId!)
          .then((data) {
        print('Data fetched successfully: $data');
        return data;
      }).catchError((error) {
        setState(() {
          _errorMessage = 'Failed to load users: $error';
        });
        print('Error fetching users: $error');
        throw error;
      });
    } else {
      setState(() {
        _useFilter = false;
        _errorMessage = 'Please select both document ID and group ID.';
      });
      print('Error: Document ID or Group ID is null');
    }
  }

  void _loadFilterData() async {
    setState(() {
      _useFilter = true; // Set to true before making the second API call
    });
    if (_selectedDocId != null && _selectedDocGroupId != null) {
      if (constraints == "is equal to") {
        _futureUsersFilter = ApiService.filterequals(_selectedDocId!,
                _selectedDocGroupId!, selectedLabel!, valueController.text)
            .then((Table) {
          setState(() {
            _showCardList = true;
            _useFilter = true; // Switch to use filter data
          });
          print('Filter Data fetched successfully: $Table');
          return Table;
        }).catchError((error) {
          setState(() {
            _errorMessage = 'Failed to load filter: $error';
          });
          print('Error fetching filter: $error');
          throw error;
        });
      }
      if (constraints == "Begins with") {
        _futureUsersFilter = ApiService.filterbeginswith(_selectedDocId!,
                _selectedDocGroupId!, selectedLabel!, valueController.text)
            .then((Table) {
          setState(() {
            _showCardList = true;
            _useFilter = true; // Switch to use filter data
          });
          print('Filter Data fetched successfully: $Table');
          return Table;
        }).catchError((error) {
          setState(() {
            _errorMessage = 'Failed to load filter: $error';
          });
          print('Error fetching filter: $error');
          throw error;
        });
      }
      if (constraints == "Ends with") {
        _futureUsersFilter = ApiService.filterendswith(_selectedDocId!,
                _selectedDocGroupId!, selectedLabel!, valueController.text)
            .then((Table) {
          setState(() {
            _showCardList = true;
            _useFilter = true; // Switch to use filter data
          });
          print('Filter Data fetched successfully: $Table');
          return Table;
        }).catchError((error) {
          setState(() {
            _errorMessage = 'Failed to load filter: $error';
          });
          print('Error fetching filter: $error');
          throw error;
        });
      }
      if (constraints == "contains") {
        _futureUsersFilter = ApiService.filtercontains(_selectedDocId!,
                _selectedDocGroupId!, selectedLabel!, valueController.text)
            .then((Table) {
          setState(() {
            _showCardList = true;
            _useFilter = true; // Switch to use filter data
          });
          print('Filter Data fetched successfully: $Table');
          return Table;
        }).catchError((error) {
          setState(() {
            _errorMessage = 'Failed to load filter: $error';
          });
          print('Error fetching filter: $error');
          throw error;
        });
      }
      if (amountconstraints == "equals") {
        _futureUsersFilter = ApiService.amountfilterequals(_selectedDocId!,
                _selectedDocGroupId!, selectedLabel!, valueController.text)
            .then((Table) {
          setState(() {
            _showCardList = true;
            _useFilter = true; // Switch to use filter data
          });
          print('Filter Data fetched successfully: $Table');
          return Table;
        }).catchError((error) {
          setState(() {
            _errorMessage = 'Failed to load filter: $error';
          });
          print('Error fetching filter: $error');
          throw error;
        });
      }
      if (amountconstraints == "is greater than") {
        _futureUsersFilter = ApiService.amountfiltergreater(_selectedDocId!,
                _selectedDocGroupId!, selectedLabel!, valueController.text)
            .then((Table) {
          setState(() {
            _showCardList = true;
            _useFilter = true; // Switch to use filter data
          });
          print('Filter Data fetched successfully: $Table');
          return Table;
        }).catchError((error) {
          setState(() {
            _errorMessage = 'Failed to load filter: $error';
          });
          print('Error fetching filter: $error');
          throw error;
        });
      }
      if (amountconstraints == "is less than") {
        _futureUsersFilter = ApiService.amountfilterlesser(_selectedDocId!,
                _selectedDocGroupId!, selectedLabel!, valueController.text)
            .then((Table) {
          setState(() {
            _showCardList = true;
            _useFilter = true; // Switch to use filter data
          });
          print('Filter Data fetched successfully: $Table');
          return Table;
        }).catchError((error) {
          setState(() {
            _errorMessage = 'Failed to load filter: $error';
          });
          print('Error fetching filter: $error');
          throw error;
        });
      }
      if (amountconstraints == "is greater than or equal to") {
        _futureUsersFilter = ApiService.amountfiltergreaterthanorequals(
                _selectedDocId!,
                _selectedDocGroupId!,
                selectedLabel!,
                valueController.text)
            .then((Table) {
          setState(() {
            _showCardList = true;
            _useFilter = true; // Switch to use filter data
          });
          print('Filter Data fetched successfully: $Table');
          return Table;
        }).catchError((error) {
          setState(() {
            _errorMessage = 'Failed to load filter: $error';
          });
          print('Error fetching filter: $error');
          throw error;
        });
      }
      if (amountconstraints == "is less than or equal to") {
        _futureUsersFilter = ApiService.amountfilterlesserorequals(
                _selectedDocId!,
                _selectedDocGroupId!,
                selectedLabel!,
                valueController.text)
            .then((Table) {
          setState(() {
            _showCardList = true;
            _useFilter = true; // Switch to use filter data
          });
          print('Filter Data fetched successfully: $Table');
          return Table;
        }).catchError((error) {
          setState(() {
            _errorMessage = 'Failed to load filter: $error';
          });
          print('Error fetching filter: $error');
          throw error;
        });
      }
      if (dateconstraints == "equals") {
        _futureUsersFilter = ApiService.datefilterequals(_selectedDocId!,
                _selectedDocGroupId!, selectedLabel!, dateController.text)
            .then((Table) {
          setState(() {
            _showCardList = true;
            _useFilter = true; // Switch to use filter data
          });
          print('Filter Data fetched successfully: $Table');
          return Table;
        }).catchError((error) {
          setState(() {
            _errorMessage = 'Failed to load filter: $error';
          });
          print('Error fetching filter: $error');
          throw error;
        });
      }
      if (dateconstraints == "is greater than") {
        _futureUsersFilter = ApiService.datefiltergreater(_selectedDocId!,
                _selectedDocGroupId!, selectedLabel!, dateController.text)
            .then((Table) {
          setState(() {
            _showCardList = true;
            _useFilter = true; // Switch to use filter data
          });
          print('Filter Data fetched successfully: $Table');
          return Table;
        }).catchError((error) {
          setState(() {
            _errorMessage = 'Failed to load filter: $error';
          });
          print('Error fetching filter: $error');
          throw error;
        });
      }
      if (dateconstraints == "is greater than or equal to") {
        _futureUsersFilter = ApiService.datefiltergreaterorequals(
                _selectedDocId!,
                _selectedDocGroupId!,
                selectedLabel!,
                dateController.text)
            .then((Table) {
          setState(() {
            _showCardList = true;
            _useFilter = true; // Switch to use filter data
          });
          print('Filter Data fetched successfully: $Table');
          return Table;
        }).catchError((error) {
          setState(() {
            _errorMessage = 'Failed to load filter: $error';
          });
          print('Error fetching filter: $error');
          throw error;
        });
      }
      if (dateconstraints == "is less than") {
        _futureUsersFilter = ApiService.datefilterlesser(_selectedDocId!,
                _selectedDocGroupId!, selectedLabel!, dateController.text)
            .then((Table) {
          setState(() {
            _showCardList = true;
            _useFilter = true; // Switch to use filter data
          });
          print('Filter Data fetched successfully: $Table');
          return Table;
        }).catchError((error) {
          setState(() {
            _errorMessage = 'Failed to load filter: $error';
          });
          print('Error fetching filter: $error');
          throw error;
        });
      }
      if (dateconstraints == "is less than or equal to") {
        _futureUsersFilter = ApiService.datefilterlesserorequals(
                _selectedDocId!,
                _selectedDocGroupId!,
                selectedLabel!,
                dateController.text)
            .then((Table) {
          setState(() {
            _showCardList = true;
            _useFilter = true; // Switch to use filter data
          });
          print('Filter Data fetched successfully: $Table');
          return Table;
        }).catchError((error) {
          setState(() {
            _errorMessage = 'Failed to load filter: $error';
          });
          print('Error fetching filter: $error');
          throw error;
        });
      }
    }
  }

  void _loadLabels() async {
    print('Selected Doc ID: $_selectedDocId');
    print('Selected Doc Group ID: $_selectedDocGroupId');

    try {
      List<String> fetchedLabels = await ApiService.labels(_selectedDocId!,
          _selectedDocGroupId!); // Replace with actual dgroup and dname
      setState(() {
        labels = fetchedLabels;
      });
    } catch (e) {
      print('Failed to load labels: $e');
    }
  }

  void _onFilter(BuildContext context) {
    _loadLabels();
    bool _showTextBox = false; // Flag to control text box visibility
    //_loadFilterDate();
    setState(() {
      _showCardList = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              title: Center(
                child: Text(
                  "Search Filter",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<String>(
                          hint: Text('Select Label'),
                          value: selectedLabel,
                          items: labels.map((String label) {
                            return DropdownMenuItem<String>(
                              value: label,
                              child: Text(label),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedLabel = newValue;
                              labelsController.text = selectedLabel!;
                              attributeController.text = selectedLabel ?? '';
                              print("Selected Value: $selectedLabel");
                            });
                          },
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _showTextBox = true;
                                attributeController.text = selectedLabel ?? '';
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    if (_showTextBox) ...[
                      SizedBox(
                        height: Dimensions.height10,
                      ), // Add some space between widgets
                      AppTextWidget(
                        controller: attributeController,
                        hintText: "Attributes",
                        icon: Icons.star,
                      ),
                      if (selectedLabel == "Invoice No" ||
                          selectedLabel == "GI No" ||
                          selectedLabel == "Payment Advice No" ||
                          selectedLabel == "Vendor Name" ||
                          selectedLabel == "Pay Mode" ||
                          selectedLabel == "Remarks") ...[
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
                                    prefixIcon: Icon(
                                      Icons.star,
                                      color: Colors.blueAccent,
                                    ),
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
                                          "Constraints",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0),
                                        ),
                                        value: constraints,
                                        icon: Icon(Icons.arrow_drop_down_sharp),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(color: Colors.black),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            constraints = newValue!;
                                            consController.text = constraints!;
                                            print("Constraints : $constraints");
                                          });
                                        },
                                        items: cons
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
                        AppTextWidget(
                          controller: valueController,
                          hintText: "Value",
                          icon: Icons.star,
                        ),
                      ],
                      if (selectedLabel == "Invoice Amount" ||
                          selectedLabel == "Payment Amount") ...[
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
                                    prefixIcon: Icon(
                                      Icons.star,
                                      color: Colors.blueAccent,
                                    ),
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
                                          "Constraints",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0),
                                        ),
                                        value: amountconstraints,
                                        icon: Icon(Icons.arrow_drop_down_sharp),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(color: Colors.black),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            amountconstraints = newValue!;
                                            consAmountController.text =
                                                amountconstraints!;
                                          });
                                        },
                                        items: amountcons
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
                        AppTextWidget(
                          controller: valueController,
                          hintText: "Value",
                          icon: Icons.star,
                        ),
                      ],
                      if (selectedLabel == "Invoice Date" ||
                          selectedLabel == "Payment Date") ...[
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
                                    prefixIcon: Icon(
                                      Icons.star,
                                      color: Colors.blueAccent,
                                    ),
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
                                          "Constraints",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0),
                                        ),
                                        value: dateconstraints,
                                        icon: Icon(Icons.arrow_drop_down_sharp),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(color: Colors.black),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dateconstraints = newValue!;
                                            consDateController.text =
                                                dateconstraints!;
                                          });
                                        },
                                        items: datecons
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
                              child: AppTextWidget(
                                controller: dateController,
                                hintText: "Date",
                                icon: Icons.calendar_month,
                                onTap: () => _selectDate(context),
                              ),
                            )
                          ],
                        ),
                      ],

                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      CustomButton(
                          text: "Apply & Search",
                          onPressed: () {
                            _loadFilterData();
                            Navigator.of(context).pop();
                            // _showCardList = true;
                          })
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
      setState(() {
        _isLoading = true;
      });
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
            _fetchUsers();
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
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search & Reterival",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      text: "Search",
                      onPressed: _onSubmit,
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      height: 30,
                      width: 120,
                      borderRadius: Dimensions.radius30,
                    ),
                    CustomButton(
                      text: "Apply Filter",
                      onPressed: () {
                        _onFilter(context);
                      },
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      width: 150,
                      borderRadius: Dimensions.radius30,
                    )
                  ],
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                if (_showCardList)
                  Expanded(
                    child: _errorMessage.isNotEmpty
                        ? Center(child: Text(_errorMessage))
                        : FutureBuilder<List<dynamic>>(
                            future:
                                _useFilter ? _futureUsersFilter : _futureUsers,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (snapshot.hasData) {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final user = snapshot.data![index];

                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      elevation: 10,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 16.0),
                                      child: ExpansionPanelList(
                                        elevation: 1,
                                        expandedHeaderPadding:
                                            EdgeInsets.all(0),
                                        expansionCallback:
                                            (int panelIndex, bool isExpanded) {
                                          setState(() {
                                            user['isExpanded'] = !isExpanded;
                                          });
                                        },
                                        children: [
                                          ExpansionPanel(
                                            headerBuilder:
                                                (BuildContext context,
                                                    bool isExpanded) {
                                              return ListTile(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                title: Text(
                                                  'Invoice No: ${user['Invoice No']}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              );
                                            },
                                            body: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Table(
                                                    border: TableBorder.all(
                                                      color: Colors.grey,
                                                      width: 1,
                                                      style: BorderStyle.solid,
                                                    ),
                                                    children: [
                                                      buildTableRow(
                                                          'Client Name',
                                                          user['Vendor Name']),
                                                      buildTableRow('Inv. Date',
                                                          user['Invoice Date']),
                                                      buildTableRow(
                                                          'Inv. Amt.',
                                                          user[
                                                              'Invoice Amount']),
                                                      buildTableRow(
                                                          'Pay. Adv. No',
                                                          user[
                                                              'Payment Advice No']),
                                                      buildTableRow('Pay. Date',
                                                          user['Payment Date']),
                                                      buildTableRow(
                                                          'Pay. Amt.',
                                                          user[
                                                              'Payment Amount']),
                                                      buildTableRow('GI No',
                                                          user['GI No']),
                                                      buildTableRow('Linked',
                                                          user['Linked']),
                                                      buildTableRow('History',
                                                          user['History']),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          16), // Space between table and buttons
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CustomButtonNew(
                                                        text: "View",
                                                        onPressed: () {
                                                          _openPDF(user[
                                                              'File Path']);
                                                        },
                                                        color:
                                                            Colors.blueAccent,
                                                        textColor: Colors.white,
                                                        borderRadius:
                                                            Dimensions.radius30,
                                                      ),
                                                      SizedBox(width: 16),
                                                      CustomButtonNew(
                                                        text: "Linked Docs",
                                                        onPressed: () {
                                                          // Handle Linked Docs action
                                                        },
                                                        color:
                                                            Colors.blueAccent,
                                                        textColor: Colors.white,
                                                        borderRadius:
                                                            Dimensions.radius30,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            isExpanded:
                                                user['isExpanded'] ?? false,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(child: Text('No users found.'));
                              }
                            },
                          ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  TableRow buildTableRow(String label, String? value) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value ?? 'N/A',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
