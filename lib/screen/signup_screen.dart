import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map/common/AppColors.dart';
import 'package:google_map/model/register_request_model.dart';
import 'package:google_map/service/http_service.dart';
import 'package:google_map/service/local_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../component/Loading.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showPass = false; // Tạo 1 biến showPass = false (Ko Show Pass)
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _fullNameController = new TextEditingController();
  TextEditingController _ageController = new TextEditingController();
  TextEditingController _phoneNumController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  var _userError = "Invalid";
  var _passError = "Invalid";
  var _userInvalid = false; // Tài khoản hợp lệ
  var _passInvalid = false; // Mật khẩu hợp lệ
  String vehicleValue = 'Medium Struck';
  var items = {
    'Medium Struck': '1',
    'Large Truck': '2',
  };

  final prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Sign Up",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25),
        ),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Color(0xFFFFFFFF),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          iconSize: 25,
          color: Colors.black,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0), // Căn chỉnh lề
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: TextField(
                  controller: _usernameController,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.person),
                      labelText: "Username",
                      errorText: _userInvalid ? _userError : null,
                      labelStyle: TextStyle(
                          color: Color(AppColors.PRIMARY), fontSize: 15)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    TextField(
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      obscureText: !showPass,
                      //  phủ định của !showPass = true ( Ẩn mật khẩu)
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.lock),
                          labelText: "PassWord",
                          errorText: _passInvalid ? _passError : null,
                          suffixIcon: IconButton(
                              icon: Icon(showPass
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: onToggleShowPass),
                          labelStyle: TextStyle(
                              color: Color(AppColors.PRIMARY), fontSize: 15)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: TextField(
                  controller: _fullNameController,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.person),
                      labelText: "Full name",
                      errorText: _userInvalid ? _userError : null,
                      labelStyle: TextStyle(
                          color: Color(AppColors.PRIMARY), fontSize: 15)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: TextField(
                  controller: _ageController,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.person),
                      labelText: "Your Age",
                      errorText: _userInvalid ? _userError : null,
                      labelStyle: TextStyle(
                          color: Color(AppColors.PRIMARY), fontSize: 15)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: TextField(
                  controller: _phoneNumController,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.phone),
                      labelText: "Phone Number",
                      errorText: _passInvalid ? _passError : null,
                      labelStyle: TextStyle(
                          color: Color(AppColors.PRIMARY), fontSize: 15)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: TextField(
                  controller: _addressController,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.location_on),
                      labelText: "Address",
                      errorText: _userInvalid ? _userError : null,
                      labelStyle: TextStyle(
                          color: Color(AppColors.PRIMARY), fontSize: 15)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: DropdownButton(
                  value: vehicleValue,
                  items: items.keys.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        vehicleValue = newValue!;
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    height: 50,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.blue,
                    onPressed: () async {
                      try {
                        await _signUp(
                          RegisterRequestModel(
                            username: _usernameController.text,
                            password: _passwordController.text,
                            fullname: _fullNameController.text,
                            age: _ageController.text,
                            address: _addressController.text,
                            phoneNumber: int.parse(_phoneNumController.text),
                            vehicle: RegisteringVehicle(
                              idVehicle: items[vehicleValue]!,
                            ),
                          ),
                        );
                        await LocalStorage.saveVehicleId(items[vehicleValue]!);
                        print(
                            '>>>id is ' + (await LocalStorage.getVehicleId())!);
                        await _showSuccessDialog(_usernameController.text);
                      } catch (e) {
                        await _showErrorDialog(e.toString());
                      }
                    },
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signUp(RegisterRequestModel info) async {
    showDialog(
      // The user CANNOT close this dialog  by pressing outsite it
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          // The background color
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                // The loading indicator
                CircularProgressIndicator(),
                SizedBox(
                  height: 15,
                ),
                // Some text
                Text('Signing you up...')
              ],
            ),
          ),
        );
      },
    );

    await HttpService.registerUser(info);
    Navigator.of(context).pop();
  }

  Future<void> _showErrorDialog(String msg) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
                Text('Retry or contact admin for help!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSuccessDialog(String username) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Sucessfully created $username\'s account!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onToggleShowPass() {
    setState(() {
      showPass = !showPass;
    });
  }
  // URL RESGISTER = "https://localsearch-vrp.herokuapp.com/api/auth/register"
}
