import 'dart:io';

import 'package:dms/utils/dimensions.dart';
import 'package:dms/widgets/apptextwidget.dart';
import 'package:dms/widgets/custombutton.dart';
import 'package:dms/widgets/custombuttonnew.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Indexing extends StatefulWidget {
  final File imageFile;
  const Indexing({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<Indexing> createState() => _IndexingState();
}

class _IndexingState extends State<Indexing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Indexing",
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
                        Tab(text: "Scanned Image"),
                        Tab(text: "Attributes"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                  Expanded(
                      child: TabBarView(
                    children: [
                      Center(
                          child: Tab1(
                        imageFile: widget.imageFile,
                      )),
                      Center(child: Tab2()),
                    ],
                  ))
                ],
              )),
        ],
      ),
    );
  }
}

class Tab1 extends StatefulWidget {
  final File imageFile;
  const Tab1({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.file(widget.imageFile),
      ),
    );
  }
}

class Tab2 extends StatefulWidget {
  const Tab2({Key? key}) : super(key: key);

  @override
  State<Tab2> createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> {
  var invnoController = TextEditingController();
  var invamtController = TextEditingController();
  var giController = TextEditingController();
  var payadviceController = TextEditingController();
  var payamtController = TextEditingController();
  var vendornameController = TextEditingController();
  var paymodeController = TextEditingController();
  var remarksController = TextEditingController();

  String? dates;
  DateTime _selectedDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  var dateController = TextEditingController();

  String? paydates;
  DateTime _selectedPayDate = DateTime.now();
  final DateFormat paydateFormat = DateFormat('dd-MM-yyyy');
  var paydateController = TextEditingController();

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

  Future<void> _selectPayDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedPayDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null && picked != _selectedPayDate) {
      setState(() {
        paydateController.text = dateFormat.format(picked);
        paydates = paydateController.text;
        print("Selected Date : $paydates"); // Format date as needed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align items to the start
          children: [
            AppTextWidget(
              controller: invnoController,
              hintText: "Invoice No.",
              icon: Icons.numbers_rounded,
            ),
            SizedBox(height: Dimensions.height10),
            AppTextWidget(
              controller: dateController,
              hintText: "Invoice Date",
              icon: Icons.calendar_month,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: Dimensions.height10),
            AppTextWidget(
              controller: invamtController,
              hintText: "Invoice Amount",
              icon: Icons.currency_rupee,
            ),
            SizedBox(height: Dimensions.height10),
            AppTextWidget(
              controller: giController,
              hintText: "GI No.",
              icon: Icons.numbers_rounded,
            ),
            SizedBox(height: Dimensions.height10),
            AppTextWidget(
              controller: payadviceController,
              hintText: "Payment Advice No.",
              icon: Icons.numbers_rounded,
            ),
            SizedBox(height: Dimensions.height10),
            AppTextWidget(
              controller: paydateController,
              hintText: "Payment Date",
              icon: Icons.calendar_month,
              onTap: () => _selectPayDate(context),
            ),
            SizedBox(height: Dimensions.height10),
            AppTextWidget(
              controller: payamtController,
              hintText: "Payment Amount",
              icon: Icons.currency_rupee,
            ),
            SizedBox(height: Dimensions.height10),
            AppTextWidget(
              controller: vendornameController,
              hintText: "Vendor Name",
              icon: Icons.person,
            ),
            SizedBox(height: Dimensions.height10),
            AppTextWidget(
              controller: paymodeController,
              hintText: "Paymode",
              icon: Icons.note_outlined,
            ),
            SizedBox(height: Dimensions.height10),
            AppTextWidget(
              controller: remarksController,
              hintText: "Remarks",
              icon: Icons.note,
            ),
            SizedBox(height: Dimensions.height20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButtonNew(
                  text: "Save",
                  onPressed: () {},
                  color: Colors.lightBlue[900],
                ),
                CustomButtonNew(
                  text: "Map Attribute",
                  onPressed: () {},
                  color: Colors.lightBlue[900],
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),
          ],
        ),
      ),
    );
  }
}
