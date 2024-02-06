import 'package:flutter/material.dart';

class GeneralView extends StatefulWidget {
  @override
  _GeneralViewState createState() => _GeneralViewState();
}

class _GeneralViewState extends State<GeneralView> {
  TextEditingController summaryController = TextEditingController();
  String selectedRequestStatus = 'Completed';
  String selectedMaintenanceType = 'Preventive';
  String selectedPriority = 'High';
  TextEditingController assetController = TextEditingController();
  TextEditingController projectController = TextEditingController();
  TextEditingController dateCreatedController = TextEditingController();
  TextEditingController timeCreatedController = TextEditingController();
  DateTime selectedRequiredDate = DateTime.now();
  TimeOfDay selectedRequiredTime = TimeOfDay.now();

  // New fields
  TextEditingController assignUserController = TextEditingController();
  String selectedProblemCode = 'Code1'; // Default value

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedRequiredDate,
      firstDate: DateTime(2000),
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
              DropdownButtonFormField(
                value: selectedRequestStatus,
                items: [
                  'Completed',
                  'Requested', /* Add other status options */
                ].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status,
                      style: TextStyle(fontFamily: 'Vazir'),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRequestStatus = value.toString();
                  });
                },
                decoration: InputDecoration(labelText: 'Request Status'),
              ),
              DropdownButtonFormField(
                value: selectedMaintenanceType,
                items: [
                  'Preventive',
                  'Corrective', /* Add other maintenance types */
                ].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMaintenanceType = value.toString();
                  });
                },
                decoration: InputDecoration(labelText: 'Maintenance Type'),
              ),
              DropdownButtonFormField(
                value: selectedPriority,
                items: [
                  'High',
                  'Medium',
                  'Low', /* Add other priority levels */
                ].map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPriority = value.toString();
                  });
                },
                decoration: InputDecoration(labelText: 'Priority'),
              ),
              TextFormField(
                controller: assetController,
                decoration: InputDecoration(labelText: 'Asset'),
              ),
              TextFormField(
                controller: projectController,
                decoration: InputDecoration(labelText: 'Project'),
              ),
              TextFormField(
                controller: dateCreatedController,
                decoration: InputDecoration(labelText: 'Date Created'),
              ),
              TextFormField(
                controller: timeCreatedController,
                decoration: InputDecoration(labelText: 'Time Created'),
              ),
              // Editable Date and Time Pickers
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: TextEditingController(
                      text:
                          selectedRequiredDate.toLocal().toString().split(" ")[0],
                    ),
                    decoration: InputDecoration(labelText: 'Required Date'),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: TextEditingController(
                      text: selectedRequiredTime.format(context),
                    ),
                    decoration: InputDecoration(labelText: 'Required Time'),
                  ),
                ),
              ),
              // New fields
              TextFormField(
                controller: assignUserController,
                decoration: InputDecoration(labelText: 'Assign User'),
              ),
              DropdownButtonFormField(
                value: selectedProblemCode,
                items: [
                  'Code1',
                  'Code2', /* Add other problem codes */
                ].map((code) {
                  return DropdownMenuItem(
                    value: code,
                    child: Text(code),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProblemCode = value.toString();
                  });
                },
                decoration: InputDecoration(labelText: 'Problem Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
