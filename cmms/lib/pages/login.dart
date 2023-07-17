import 'dart:convert';
import 'package:cmms/util/util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    final String apiUrl = '${MyGlobals.server}/api-token-auth/';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Login successful, handle the response here
      final responseData = json.decode(response.body);
      // Store the authentication token or session information as needed
      // For example, you can save the token using shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', responseData['token']);
      await prefs.setString('isLoggedIn', 'true');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigation()),
      );

      // Redirect the user to the home screen or perform any other desired actions
    } else {
      // Login failed, handle the error here
      final errorData = json.decode(response.body);
      if (errorData['non_field_errors'][0] ==
          'Unable to log in with provided credentials.') {
        final errorMessage = "رمز و نام کاربری نامعتبر";
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'خطا',
              style: TextStyle(fontFamily: 'Vazir'),
            ),
            content: Text(errorMessage, style: TextStyle(fontFamily: 'Vazir')),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ورود'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'نام کاربری',
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'رمز',
                ),
                obscureText: true,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    // FirebaseMessaging _firebaseMessaging =
    //     FirebaseMessaging.instance; // Change here
    //     _firebaseMessaging.getToken()
    // // _firebaseMessaging.getToken().then((token) {
    // //   // print("token is $token");
    // // });
  }

  Future<void> _login() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    final String apiUrl = '${MyGlobals.server}/api-token-auth/';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Login successful, handle the response here
      final responseData = json.decode(response.body);
      _sendFCMTOKEN();
      // Store the authentication token or session information as needed
      // For example, you can save the token using shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', responseData['token']);
      await prefs.setString('fcmtoken', fcmToken!);
      await prefs.setBool('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigation()),
      );

      // Redirect the user to the home screen or perform any other desired actions
    } else {
      // Login failed, handle the error here
      final errorData = json.decode(response.body);
      if (errorData['non_field_errors'][0] ==
          'Unable to log in with provided credentials.') {
        final errorMessage = "رمز و نام کاربری نامعتبر";
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'خطا',
              style: TextStyle(fontFamily: 'Vazir'),
            ),
            content: Text(errorMessage, style: TextStyle(fontFamily: 'Vazir')),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _sendFCMTOKEN() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    final String apiUrl = '${MyGlobals.server}/fcm/';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fcm': fcmToken,
      }),
    );

    if (response.statusCode == 200) {
      // Login successful, handle the response here
      final responseData = json.decode(response.body);
      // Store the authentication token or session information as needed
      // For example, you can save the token using shared preferences

      // Redirect the user to the home screen or perform any other desired actions
    } else {
      // Login failed, handle the error here
      final errorData = json.decode(response.body);
      if (errorData['non_field_errors'][0] ==
          'Unable to log in with provided credentials.') {
        final errorMessage = "رمز و نام کاربری نامعتبر";
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'خطا',
              style: TextStyle(fontFamily: 'Vazir'),
            ),
            content: Text(errorMessage, style: TextStyle(fontFamily: 'Vazir')),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(""),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('images/logo21.jpg')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'نام کاربری',
                  // hintText: 'Enter valid email id as abc@gmail.com'
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  // hintText: 'Enter secure password'
                ),
              ),
            ),

            SizedBox(
              height: 100,
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     //TODO FORGOT PASSWORD SCREEN GOES HERE
            //   },
            //   child: Text(
            //     'Forgot Password',
            //     style: TextStyle(color: Colors.blue, fontSize: 15),
            //   ),
            // ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: _login,
                child: Text(
                  'ورود',
                  style: TextStyle(
                      color: Colors.white, fontSize: 25, fontFamily: 'Vazir'),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            // Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}
