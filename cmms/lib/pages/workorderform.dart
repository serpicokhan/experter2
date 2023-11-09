import 'dart:io';

import 'package:cmms/main.dart';
import 'package:cmms/pages/woformwidgets.dart';
import 'package:cmms/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linear_datepicker/flutter_datepicker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shamsi_date/shamsi_date.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_picker/image_picker.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  String input1Value = '';
  String input2Value = '';
  String UserValue = '';
  String UserId = '';
  String input2id = '';
  String label = '';
  String seletedDate = '';
  List<File> _images = [];
  List<File> _files = [];
  late Gregorian g1;
  late Jalali j1;
  TextEditingController input1Controller = TextEditingController();
  void initState() {
    super.initState();
    label = 'انتخاب تاریخ زمان';
    var a = DateTime.now();
    g1 = Gregorian(a.year, a.month, a.day);
    j1 = g1.toJalali();
    int year = j1.year;
    int month = j1.month;
    int day = j1.day;

    setState(() {
      input1Controller.text = "$year-$month-$day";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('فرم دستور کار جدید',
            style: TextStyle(
              fontFamily: 'Vazir',
              overflow: TextOverflow.ellipsis,

              // Add more text styles as needed
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              onTap: () {
                showDateDialog(context);
              },
              controller: input1Controller,
              decoration: InputDecoration(labelText: 'تاریخ'),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  input1Value = value;
                });
              },
              decoration: InputDecoration(labelText: 'مشکل'),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _openModal(context);
              },
              child: TextFormField(
                enabled: false,
                controller: TextEditingController(text: input2Value),
                decoration: InputDecoration(
                  labelText: 'مکان',
                  suffixIcon: Icon(Icons.edit),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _openModal2(context);
              },
              child: TextFormField(
                enabled: false,
                controller: TextEditingController(text: UserValue),
                decoration: InputDecoration(
                  labelText: 'نام کاربر',
                  suffixIcon: Icon(Icons.edit),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Display the taken pictures as thumbnails
            Card(
              elevation: 4, // Customize the card elevation as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    title: Text(
                      'عکسهای پیوست شده',
                      style: TextStyle(fontFamily: 'Vazir'),
                    ), // Add your legend title here
                  ),
                  // Display the taken pictures as thumbnails in a horizontal row
                  if (_images.isNotEmpty)
                    Row(
                      children: _images.asMap().entries.map((entry) {
                        final index = entry.key;
                        final image = entry.value;
                        return Dismissible(
                          key: ValueKey<int>(index),
                          onDismissed: (direction) {
                            setState(() {
                              _images.removeAt(
                                  index); // Remove the image when dismissed
                            });
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return LargeImageDialog(
                                              image); // Pass the selected image to the dialog
                                        },
                                      );
                                    },
                                    child: Image.file(image,
                                        height: 100, width: 100),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _images.removeAt(
                                              index); // Remove the image when tapped
                                        });
                                      },
                                      child:
                                          Icon(Icons.close, color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),

            ElevatedButton(
              onPressed: () {
                _saveForm();
              },
              child: Text('ذخیره',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 12.0, overflow: TextOverflow.ellipsis,

                    // Add more text styles as needed
                  )),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _takePicture,
            tooltip: 'Take Picture',
            child: Icon(Icons.camera),
          ),
          SizedBox(height: 16), // Add some spacing between the buttons
          FloatingActionButton(
            tooltip: 'Attach File',
            onPressed: () {},
            child: Icon(Icons.attach_file),
          ),
        ],
      ),
    );
  }

  void showDateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('انتخاب کنید',
            style: TextStyle(
              fontFamily: 'Vazir',
              fontSize: 12.0, overflow: TextOverflow.ellipsis,

              // Add more text styles as needed
            )),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearDatePicker(
              dateChangeListener: (String selectedDate) {
                setState(() {
                  input1Controller.text = selectedDate.replaceAll('/', '-');
                  var dates = input1Controller.text.split('-');
                  j1 = Jalali(int.parse(dates[0]), int.parse(dates[1]),
                      int.parse(dates[2]));
                });
              },
              showMonthName: true,
              isJalaali: true,
              labelStyle: TextStyle(
                fontFamily: 'Vazir',
                color: Colors.black,
              ),
              selectedRowStyle: TextStyle(
                fontFamily: 'Vazir',
                color: Colors.deepOrange,
              ),
              unselectedRowStyle: TextStyle(
                fontFamily: 'Vazir',
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('بستن',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 12.0, overflow: TextOverflow.ellipsis,

                    // Add more text styles as needed
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _openModal(BuildContext context) async {
    final selectedAsset = await showModalBottomSheet<Location>(
      context: context,
      builder: (context) => YourModalWidget(),
    );

    if (selectedAsset != null) {
      setState(() {
        input2Value = '${selectedAsset.name} (ID: ${selectedAsset.id})';
        input2id = selectedAsset.id.toString();
      });
    }
  }

  void _openModal2(BuildContext context) async {
    final selectedAsset = await showModalBottomSheet<SysUser>(
      context: context,
      builder: (context) => UserModalWidget(),
    );

    if (selectedAsset != null) {
      setState(() {
        UserValue = '${selectedAsset.fullName} (ID: ${selectedAsset.id})';
        UserId = selectedAsset.id.toString();
      });
    }
  }

  void _showSnackBar(BuildContext context, String error) {
    final snackBar = SnackBar(
      content: Text(error),
      duration: Duration(
          seconds:
              3), // Set the duration for how long the SnackBar should be visible.
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          // Code to be executed when the 'Dismiss' action is pressed.
          // You can add any functionality here.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _saveForm() async {
    // Replace 'your_url' with the actual URL to which you want to post the data.
    // final url = Uri.parse(${MyGlobals.server2}'/api/v1/RegMini/');
    DateTime currentDateTime = DateTime.now();

    // j1 = Jalali(1402, 10, 21);
    int year = j1.toGregorian().year;
    int month = j1.toGregorian().month;

    int day = j1.toGregorian().day;

    final Map<String, dynamic> data = {
      'summaryofIssue': input1Value,
      'woAsset': input2id,
      'maintenanceType': 18,
      'assignedToUser': UserId,
      'datecreated': "$year-$month-$day",
      'woStatus': 1,
      // 'timecreated':
      //     '${currentDateTime.hour}:${currentDateTime.minute}:${currentDateTime.second}'
    };

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Read a string value
      final token = prefs.getString('token');
      final response = await http.post(
        Uri.parse('${MyGlobals.server}/api/v1/RegMini/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode(data),
      );
      // final response = await http.post(url, body: json.encode(data));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle successful response here, if needed.
        // For example, show a success message or navigate to another page.

      } else {
        // Handle error response here, if needed.
        // For example, show an error message.
        _showSnackBar(
            context, 'خطایی به وجود آمده است' + response.statusCode.toString());
      }
    } catch (error) {
      // Handle exceptions here, if needed.
      // For example, show an error message.
      _showSnackBar(context, error.toString());
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BottomNavigation()));
  }

  Future<void> _takePicture() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _images.add(File(image.path)); // Add the image to the list
      });
    }
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      // You now have a list of selected files in the 'files' variable.
      // You can store the file paths or perform any other action.
    }
  }
}
