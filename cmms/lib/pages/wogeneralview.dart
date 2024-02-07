import 'dart:convert';

import 'package:cmms/util/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeneralView extends StatefulWidget {
  late final int woId;
  GeneralView({required this.woId});
  @override
  _GeneralViewState createState() => _GeneralViewState();
}

class _GeneralViewState extends State<GeneralView> {
  TextEditingController summaryController = TextEditingController();
  String selectedRequestStatus = 'تکمیل شده';
  String selectedMaintenanceType = 'پیشگیرانه';
  String selectedPriority = 'بالا';
  TextEditingController assetController = TextEditingController();

  TextEditingController dateCreatedController = TextEditingController();
  TextEditingController dateCompletedController = TextEditingController();
  TextEditingController timeCreatedController = TextEditingController();
  TextEditingController timeCompletedController = TextEditingController();
  DateTime selectedRequiredDate = DateTime.now();
  TimeOfDay selectedRequiredTime = TimeOfDay.now();
  String? dropdownValue = 'تکمیل شده';
  int? selectedMaintenanceTypeKey = 10;
  int? selectedPriorityKey = 1;
  Map<String, dynamic>? workOrderData;

  // Map of the key-value pairs
  final Map<int, String> priorities = {
    1: 'خیلی زیاد',
    2: 'بالا',
    3: 'متوسط',
    4: 'پایین',
  };

  // Map of the key-value pairs
  final Map<int, String> maintenanceTypes = {
    10: 'سرویس',
    11: 'پروژه',
    12: 'تعمیر',
  };

  // List of items in our dropdown menu
  final reqitems = [
    'تکمیل شده',
    'در حال پیشرفت',
    'درخواست شده',
  ];

  // New fields
  TextEditingController assignUserController = TextEditingController();
  String selectedProblemCode = 'Code1'; // Default value
  void initState() {
    super.initState();
    fetchWorkOrder(widget.woId);
  }

  Future<void> fetchWorkOrder(int id) async {
    final response = await http
        .get(Uri.parse('${MyGlobals.server}/api/v1/WorkOrder/$id/Details'));

    if (response.statusCode == 200) {
      setState(() {
        workOrderData = json.decode(response.body);
        summaryController.text = workOrderData!['summaryofIssue'] ?? '';
        // assetController.text = workOrderData!['woAsset']['assetName'] ?? '';
      });
    } else {
      // Handle the error
      print('Failed to load WorkOrder');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedRequiredDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedRequiredDate) {
      setState(() {
        selectedRequiredDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedRequiredTime,
    );
    if (picked != null && picked != selectedRequiredTime) {
      setState(() {
        selectedRequiredTime = picked;
      });
    }
  }

  @override
  void dispose() {
    // Don't forget to dispose of the controller when the widget is disposed.
    timeCompletedController.dispose();
    timeCreatedController.dispose();
    dateCompletedController.dispose();
    dateCreatedController.dispose();
    assetController.dispose();
    summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Existing fields
              TextFormField(
                controller: summaryController,
                style: TextStyle(fontFamily: 'Vazir'),
                decoration: InputDecoration(labelText: 'خلاصه مشکل'),
              ),
              DropdownButtonFormField<String>(
                value: dropdownValue,
                iconSize: 24,
                elevation: 16,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontFamily: 'Vazir', // Set the font family here
                ),
                items: reqitems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButtonFormField<int>(
                value: selectedMaintenanceTypeKey,
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontFamily: 'Vazir', // Set the font family here
                ),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedMaintenanceTypeKey = newValue;
                  });
                },
                items: maintenanceTypes.entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
              ),

              DropdownButtonFormField<int>(
                value: selectedPriorityKey,
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontFamily: 'Vazir', // Set the font family here
                ),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedPriorityKey = newValue;
                  });
                },
                items: priorities.entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
              ),

              TextFormField(
                controller: assetController,
                decoration: InputDecoration(
                  labelText: 'تجهیز',
                  labelStyle: TextStyle(
                    fontFamily: 'Vazir', // Set the font for the label
                  ),
                ),
              ),
              // TextFormField(
              //   controller: projectController,
              //   decoration: InputDecoration(labelText: 'Project'),
              // ),
              TextFormField(
                controller: dateCreatedController,
                decoration: InputDecoration(
                  labelText: 'تاریخ ایجاد',
                  labelStyle: TextStyle(
                    fontFamily: 'Vazir', // Set the font for the label
                  ),
                ),
              ),
              TextFormField(
                controller: timeCreatedController,
                decoration: InputDecoration(
                  labelText: 'زمان ایجاد',
                  labelStyle: TextStyle(
                    fontFamily: 'Vazir', // Set the font for the label
                  ),
                ),
              ),
              TextFormField(
                controller: dateCompletedController,
                decoration: InputDecoration(
                  labelText: 'تاریخ تکمیل',
                  labelStyle: TextStyle(
                    fontFamily: 'Vazir', // Set the font for the label
                  ),
                ),
              ),
              TextFormField(
                controller: timeCompletedController,
                decoration: InputDecoration(
                  labelText: 'زمان تکمیل',
                  labelStyle: TextStyle(
                    fontFamily: 'Vazir', // Set the font for the label
                  ),
                ),
              ),
              // Editable Date and Time Pickers
              // GestureDetector(
              //   onTap: () => _selectDate(context),
              //   child: AbsorbPointer(
              //     child: TextFormField(
              //       controller: TextEditingController(
              //         text: selectedRequiredDate
              //             .toLocal()
              //             .toString()
              //             .split(" ")[0],
              //       ),
              //       decoration: InputDecoration(labelText: 'Required Date'),
              //     ),
              //   ),
              // ),
              // GestureDetector(
              //   onTap: () => _selectTime(context),
              //   child: AbsorbPointer(
              //     child: TextFormField(
              //       controller: TextEditingController(
              //         text: selectedRequiredTime.format(context),
              //       ),
              //       decoration: InputDecoration(labelText: 'Required Time'),
              //     ),
              //   ),
              // ),
              // New fields
              TextFormField(
                controller: assignUserController,
                decoration: InputDecoration(
                    labelText: 'کاربر',
                    labelStyle: TextStyle(
                      fontFamily: 'Vazir', // Set the font for the label
                    )),
              ),
              // DropdownButtonFormField(
              //   value: selectedProblemCode,
              //   items: [
              //     'Code1',
              //     'Code2', /* Add other problem codes */
              //   ].map((code) {
              //     return DropdownMenuItem(
              //       value: code,
              //       child: Text(code),
              //     );
              //   }).toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       selectedProblemCode = value.toString();
              //     });
              //   },
              //   decoration: InputDecoration(labelText: 'Problem Code'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
