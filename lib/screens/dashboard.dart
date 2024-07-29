import 'package:dms/screens/changepassword.dart';
import 'package:dms/screens/fileupload.dart';
import 'package:dms/screens/loginscreen.dart';
import 'package:dms/screens/searchreterival.dart';
import 'package:dms/screens/viewprofile.dart';
import 'package:dms/service/apiservice.dart';
import 'package:dms/utils/dimensions.dart';
import 'package:dms/widgets/apptextwidget.dart';
import 'package:dms/widgets/custombutton.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int? empid;
  int? DD;
  int? DT;
  int? DG;
  int? ORG1;
  int? ORG2;
  int? doconlycount;
  int? dataonlycount;
  List<String> orgNames = [];
  List<String> orgCodes = [];
  String? orgName;
  String? orgCode;
  String? deptHint;
  String? unitHint;
  String? parentcode;
  String? dependcode;
  String? barchartname;
  bool _isForm = false;
  bool _isLoading = false;
  double _formHeight = 400.0; // Initial height of the form

  var level3Controller = TextEditingController();
  var level4Controller = TextEditingController();

  int? _selectedDocId;
  int? _selectedUnitId;

  String? finance;
  String? accounts;
  List<PieChartSectionData> pieChartData = [];
  List<Map<String, dynamic>> legends = [];

  String? selectedDeptId;
  String _floatingButtonText = "Set Context";

  String? _selectedDept;
  List<String> dept = [];
  List<String> deptId = [];
  var deptController = TextEditingController();

  String? _selectedUnit;
  List<String> unit = [];
  List<String> unitId = [];
  List<String> finalunitids = [];
  var unitController = TextEditingController();

  void _toggleForm() {
    setState(() {
      _isForm = !_isForm;
      if (_selectedDept != null && _selectedUnit != null) {
        _floatingButtonText = "$_selectedDept / $_selectedUnit";
      } else {
        _floatingButtonText = "Set Context";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadEmpid().then((_) {
      _loadLabels();
      _loadDashboard();
      //_loadPieChart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.blueGrey[700]),
                child: Container(
                  height: Dimensions.height15 * 10,
                  child: Text(
                    "DMS",
                    style: TextStyle(color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/newdms.png"))),
                )),
            ExpansionTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("View Profile"),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ViewProfile()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text("Change Password"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePassword()));
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.document_scanner),
              title: Text("Digitize Documents"),
              children: [
                ListTile(
                  leading: Icon(Icons.note_outlined),
                  title: Text("Indexing"),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FileUpload()));
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.note_rounded),
              title: Text("Manage Documents"),
              children: [
                ListTile(
                  leading: Icon(Icons.search),
                  title: Text("Search & Reterival"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchReterival()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.storage),
                  title: Text("Physical Storage"),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Dashboard()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.event_note),
                  title: Text("Physical Reterival"),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Dashboard()));
                  },
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text("Logout"),
              onTap: () async {
                await clearSharedPreferences();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/dmsbgimages.png"),
                    fit: BoxFit.cover)),
          ),
          DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    color: Colors.blue[700],
                    child: TabBar(
                      labelColor:
                          Colors.white, // Color of the selected tab text
                      unselectedLabelColor:
                          Colors.black, // Color of the unselected tab text
                      indicatorColor: Colors.white, // Color of the indicator
                      indicatorWeight: 4.0, // Thickness of the indicator
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        // Font size for the selected tab
                      ),
                      unselectedLabelStyle:
                          TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500
                              // Font size for the unselected tab
                              ),
                      tabs: [
                        Tab(text: "Workbench"),
                        Tab(text: "Dashboard"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.height10 * 4,
                  ),
                  Expanded(
                      child: TabBarView(
                    children: [
                      Center(
                          child: Tab1(
                        doon: doconlycount,
                        doc: dataonlycount,
                        dd: DD,
                        dt: DT,
                        dg: DG,
                        org1: ORG1,
                        org2: ORG2,
                        isLoading: _isLoading,
                      )),
                      Center(child: Tab2(emplid: empid)),
                    ],
                  ))
                ],
              )),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            bottom: _isForm ? 0 : -_formHeight, // Adjust based on visibility
            left: 0,
            right: 0,
            height: _formHeight, // Set the height of the form
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear,
              opacity: _isForm ? 1 : 0,
              child: Container(
                width: Dimensions.height30 * 10,
                color: Colors.white60,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: Dimensions.height65,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      //prefixIcon: Icon(Icons.house),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: Container(
                                        width: double.infinity,
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            "$deptHint",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0),
                                          ),
                                          value: _selectedDept,
                                          icon:
                                              Icon(Icons.arrow_drop_down_sharp),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(color: Colors.black),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedDept = newValue!;
                                              deptController.text =
                                                  _selectedDept!;
                                              int selectedIndex =
                                                  dept.indexOf(_selectedDept!);
                                              if (selectedIndex != -1) {
                                                // Get the corresponding ID from deptId list
                                                selectedDeptId =
                                                    deptId[selectedIndex];
                                                print(
                                                    "Selected Dept ID: $selectedDeptId");
                                                _loadDeptUnit(selectedDeptId!);
                                              } else {
                                                print(
                                                    "Selected department not found in the list.");
                                              }
                                            });
                                          },
                                          items: dept
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
                              )
                            ],
                          ),
                          SizedBox(
                            height: Dimensions.height20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: Dimensions.height65,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      //prefixIcon: Icon(Icons.house),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: Container(
                                        width: double.infinity,
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            "$unitHint",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0),
                                          ),
                                          value: _selectedUnit,
                                          icon:
                                              Icon(Icons.arrow_drop_down_sharp),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(color: Colors.black),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedUnit = newValue!;
                                              unitController.text =
                                                  _selectedUnit!;
                                              int selectedIndex =
                                                  unit.indexOf(_selectedUnit!);
                                              if (selectedIndex != -1) {
                                                // Get the corresponding ID from deptId list
                                                String _selectedUnitId =
                                                    unitId[selectedIndex];
                                                print(
                                                    "Selected Dept ID: $_selectedUnitId");
                                              } else {
                                                print(
                                                    "Selected department not found in the list.");
                                              }
                                            });
                                          },
                                          items: unit
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
                              )
                            ],
                          ),
                          SizedBox(
                            height: Dimensions.height20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextWidget1(
                                    controller: level3Controller,
                                    hintText: "Level 3",
                                    onTap: () {}
                                    //icon: Icons.lock
                                    ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: Dimensions.height20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextWidget1(
                                  controller: level4Controller,
                                  hintText: "Level 4", onTap: () {},
                                  //icon: Icons.lock
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: Dimensions.height20,
                          ),
                        ],
                      ),
                      CustomButton(
                          text: "Apply",
                          width: 130,
                          onPressed: () {
                            _toggleForm();
                            print("Selected Dept ID: $_selectedDept");
                            print("Selected Dept ID: $_selectedUnit");
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: Dimensions.height45 + 10,
              left: Dimensions.height10,
              child: SizedBox(
                width: Dimensions.height15 * 10,
                height: Dimensions.height45,
                child: FloatingActionButton(
                  onPressed: _toggleForm,
                  child: Text(_floatingButtonText),
                ),
              ))
        ],
      ),
    );
  }

  Future<void> _loadEmpid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      empid = prefs.getInt('Emp_Id');
      print("Employee ID : $empid");
    });
  }

  Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> _loadLabels() async {
    if (empid != null) {
      try {
        final response = await ApiService.doclabels(empid!);
        print("Label response : $response");
        // Clear the list before populating it
        orgNames.clear();
        if (response is List) {
          for (var item in response) {
            if (item is Map<String, dynamic>) {
              orgCode = item['orghierarchy_code'];
              orgCodes.add(orgCode!);
              orgName = item['orghierarchy_name'];
              orgNames.add(orgName!);
              print("Org Hierarchy Name: $orgCode");
              print("Org Hierarchy Name: $orgName");
              if (orgCode == "QCD_ORG_tDepartment") {
                parentcode = orgCode;
              } else if (orgCode == "QCD_ORG_tUnit") {
                parentcode = orgCode;
              }
              if (orgName == "Department") {
                deptHint = orgName;
              } else if (orgName == "Unit") {
                unitHint = orgName;
              }
            }
          }
        } else {
          print("Unexpected response format: $response");
        }
        //  Update the state to reflect changes in the UI
        setState(() {
          _loadDept();
        });
      } catch (error) {
        print("Error loading labels: $error");
      }
    } else {
      print("Employee ID is null. Cannot load labels.");
    }
  }

  Future<void> _loadDept() async {
    if (empid != null) {
      try {
        final response =
            await ApiService.docgroupnames(empid!, "QCD_ORG_tDepartment", "");
        print("Dept Response: $response");
        setState(() {
          dept = response.map<String>((item) => item['master_name']).toList();
          deptId = response.map<String>((item) => item['master_code']).toList();
          _loadDashboard();
        });
      } catch (error) {
        print("Error loading department: $error");
      }
    } else {
      print("Employee ID or parent code is null. Cannot load department.");
    }
  }

  void _loadDeptUnit(String selectedDeptId) async {
    if (empid != null) {
      try {
        final response = await ApiService.deptunit(selectedDeptId);
        print("Dept Response: $response");
        setState(() {
          unit = response.map<String>((item) => item['unit_name']).toList();
          unitId = response.map<String>((item) => item['unit_id']).toList();
          if (unit.isNotEmpty) {
            _selectedUnit = unit[0];
            unitController.text = _selectedUnit!;
            print("Auto-selected Unit: $_selectedUnit");
          } else {
            _selectedUnit = null;
            unitController.clear();
            print("No units available for the selected department.");
          }
        });
      } catch (error) {
        print("Error loading unit: $error");
      }
    }
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
    });
    if (empid != null) {
      try {
        final response = await ApiService.dashboard(
            empid!, "QCD_mst_tfinance_", "QCD_mst_taccounts");
        print("Dashboard Response : $response");
        List<dynamic> tableData = response['Table3'];
        if (tableData.isNotEmpty) {
          var firstItem = tableData[0];
          DD = firstItem['DD'];
          DT = firstItem['DT'];
          DG = firstItem['DG'];
          ORG1 = firstItem['ORG1'];
          ORG2 = firstItem['ORG2'];
          doconlycount = firstItem['doconlycount'];
          dataonlycount = firstItem['dataonlycount'];
        }
      } catch (error) {
        print("Error loading dashboard: $error");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class Tab1 extends StatefulWidget {
  final int? doon;
  final int? doc;
  final int? dd;
  final int? dt;
  final int? dg;
  final int? org1;
  final int? org2;
  final bool isLoading;
  const Tab1({
    Key? key,
    required this.doon,
    required this.doc,
    required this.dd,
    required this.dt,
    required this.dg,
    required this.org1,
    required this.org2,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Ensures equal spacing
                        children: [
                          Container(
                            height: Dimensions.height15 * 10,
                            width: Dimensions.height180,
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to the start
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center text vertically
                                children: [
                                  Center(
                                      child: Text(
                                    "${widget.doon ?? 'No data'}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25.0),
                                  )),
                                  Center(
                                      child: Text("Only Doc",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0)))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: Dimensions.height15 * 10,
                            width: Dimensions.height180,
                            decoration: BoxDecoration(
                              color: Colors.blue[900],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to the start
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center text vertically
                                children: [
                                  Center(
                                      child: Text(
                                    "${widget.doc ?? 'No data'}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25.0),
                                  )),
                                  Center(
                                      child: Text("Only Data",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0)))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Ensures equal spacing
                        children: [
                          Container(
                            height: Dimensions.height15 * 10,
                            width: Dimensions.height180,
                            decoration: BoxDecoration(
                              color: Colors.blue[400],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to the start
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center text vertically
                                children: [
                                  Center(
                                      child: Text(
                                    "${widget.dd ?? 'No data'}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25.0),
                                  )),
                                  Center(
                                      child: Text("Doc Digitized",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0)))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: Dimensions.height15 * 10,
                            width: Dimensions.height180,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to the start
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center text vertically
                                children: [
                                  Center(
                                      child: Text(
                                    "${widget.dt ?? 'No data'}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25.0),
                                  )),
                                  Center(
                                      child: Text("Document Name",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0)))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Ensures equal spacing
                        children: [
                          Container(
                            height: Dimensions.height15 * 10,
                            width: Dimensions.height180,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to the start
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center text vertically
                                children: [
                                  Center(
                                      child: Text(
                                    "${widget.dg ?? 'No data'}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25.0),
                                  )),
                                  Center(
                                      child: Text("Document Groups",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0)))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: Dimensions.height15 * 10,
                            width: Dimensions.height180,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to the start
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center text vertically
                                children: [
                                  Center(
                                      child: Text(
                                    "${widget.org1 ?? 'No data'}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25.0),
                                  )),
                                  Center(
                                      child: Text("Department",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0)))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: Dimensions.height15 * 10,
                            width: Dimensions.height180,
                            decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to the start
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center text vertically
                                children: [
                                  Center(
                                      child: Text(
                                    "${widget.org2 ?? 'No data'}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25.0),
                                  )),
                                  Center(
                                      child: Text("Unit",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0)))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class Tab2 extends StatefulWidget {
  final int? emplid;
  const Tab2({
    Key? key,
    required this.emplid,
  }) : super(key: key);

  @override
  State<Tab2> createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> {
  late Future<List<SalesData>> _futureSalesData;
  String? finance;
  String? accounts;
  List<PieChartSectionData> _sections = [];
  List<String> _legendNames = [];
  String touchedValue = '';

  String barcodename =
      'Loading......'; // Declare at class level with a default value

  @override
  void initState() {
    super.initState();
    _futureSalesData = _fetchSalesData();
    _loadPieChart();
  }

  Future<List<SalesData>> _fetchSalesData() async {
    Map<String, dynamic> data = await ApiService.getBarChart(
        widget.emplid!, "QCD_mst_tfinance_", "QCD_mst_taccounts");

    List<SalesData> salesData = [];

    if (data.containsKey('Table2')) {
      List<dynamic> barChartlist = data['Table2'];
      for (var item in barChartlist) {
        String period = item['period'];
        String shortPeriod =
            period.length >= 3 ? period.substring(0, 3) : period;
        salesData.add(SalesData(shortPeriod, item['archid']));
      }
    }

    return salesData;
  }

  Future<void> _loadPieChart() async {
    try {
      final response = await ApiService.dashboard(
          widget.emplid!, "QCD_mst_tfinance_", "QCD_mst_taccounts");
      List<dynamic> tableData = response['Table1'];
      double total = tableData.fold(
          0, (sum, item) => sum + (item['archid'] ?? 0).toDouble());

      setState(() {
        _sections = getSections(tableData, total);
        _legendNames = tableData
            .map<String>((item) => item['master_name']?.toString() ?? 'Unknown')
            .toList();
      });
    } catch (error) {
      print("Error loading dashboard: $error");
    }
  }

  List<PieChartSectionData> getSections(List<dynamic> tableData, double total) {
    List<PieChartSectionData> sections = [];
    List<Color> colors = [
      Colors.green,
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.purple,
    ]; // Example colors

    for (int i = 0; i < tableData.length; i++) {
      var item = tableData[i];
      double percentage = (item['archid'] / total) * 100;

      sections.add(PieChartSectionData(
        color: colors[i % colors.length],
        value: percentage,
        title:
            '${percentage.toStringAsFixed(1)}%', // Display only percentage here
        radius: 60,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0,
      ));
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Document Digitized By Department",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                Center(
                  child: SizedBox(
                    width: Dimensions.height15 *
                        10, // Ensure width and height are equal
                    height: Dimensions.height15 * 10,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: const Offset(
                                5.0,
                                5.0,
                              ),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.green,
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //BoxShadow
                          ],
                        ),
                        child: _sections.isEmpty
                            ? Center(child: CircularProgressIndicator())
                            : Column(
                                children: [
                                  Expanded(
                                    child: PieChart(
                                      PieChartData(
                                        sectionsSpace: 0,
                                        centerSpaceRadius: 0,
                                        sections: _sections,
                                        startDegreeOffset: 270,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                        children: List.generate(
                      _legendNames.length,
                      (index) {
                        Color color = _sections[index].color!;
                        String masterName = _legendNames[index];

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: Dimensions.height10,
                              height: Dimensions.height10,
                              color: color,
                            ),
                            SizedBox(width: Dimensions.height10),
                            Text(
                              '$masterName',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        );
                      },
                    ))
                  ],
                ),
                SizedBox(
                  height: Dimensions.height20 * 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Document Digitized By Timeline",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500))
                  ],
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                Container(
                  height: 300, // Adjust height as needed
                  child: FutureBuilder<List<SalesData>>(
                    future: _futureSalesData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No data available'));
                      } else {
                        List<SalesData> data = snapshot.data!;
                        List<charts.Series<SalesData, String>> seriesList = [
                          charts.Series<SalesData, String>(
                            id: 'Sales',
                            domainFn: (SalesData sales, _) => sales.period,
                            measureFn: (SalesData sales, _) =>
                                sales.count.toDouble(),
                            data: data,
                            labelAccessorFn: (SalesData sales, _) =>
                                '${sales.count.toString()}',
                            colorFn: (_, __) =>
                                charts.ColorUtil.fromDartColor(Colors.red),
                          ),
                        ];
                        return SalesChart(seriesList, animate: true);
                      }
                    },
                  ),
                ),
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Department")
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(List<SalesData> data) {
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < data.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: data[i].count.toDouble(),
              colors: [Colors.red],
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }
    return barGroups;
  }
}

class SalesData {
  final String period;
  final int count;

  SalesData(this.period, this.count);
}

class SalesChart extends StatefulWidget {
  final List<charts.Series<SalesData, String>> seriesList;
  final bool animate;

  SalesChart(this.seriesList, {required this.animate});

  @override
  State<SalesChart> createState() => _SalesChartState();
}

class _SalesChartState extends State<SalesChart> {
  SalesData? _selectedData;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        charts.BarChart(
          widget.seriesList,
          animate: widget.animate,
          behaviors: [
            charts.SelectNearest(
                eventTrigger: charts.SelectionTrigger.tapAndDrag),
            charts.DomainHighlighter(),
          ],
          selectionModels: [
            charts.SelectionModelConfig(
              type: charts.SelectionModelType.info,
              changedListener: (charts.SelectionModel model) {
                if (model.hasDatumSelection) {
                  final selectedDatum =
                      model.selectedDatum.first.datum as SalesData;
                  setState(() {
                    _selectedData = selectedDatum;
                  });
                }
              },
            ),
          ],
        ),
        if (_selectedData != null) ...[
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.white,
              child: Text(
                '${_selectedData!.period}: ${_selectedData!.count}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
