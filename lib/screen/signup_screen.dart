import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map/common/AppColors.dart';
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
  TextEditingController _userController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _fullnameController = new TextEditingController();
  TextEditingController _ageController = new TextEditingController();
  TextEditingController _phonenumberController = new TextEditingController();
  TextEditingController _addresspassController = new TextEditingController();
  var _userError = "Invalid";
  var _passError = "Invalid";
  var _userInvalid = false; // Tài khoản hợp lệ
  var _passInvalid = false; // Mật khẩu hợp lệ
  String dropdownvalue = 'Medium Struck';
  var items = [
    'Medium Struck',
    'Large Truck'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sign Up",style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 25), ),
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
                  controller: _userController,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
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
                      controller: _passController,
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
                  controller: _fullnameController,
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
                  keyboardType: TextInputType.streetAddress,
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
                  controller: _phonenumberController,
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
                  controller: _addresspassController,
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
                  value: dropdownvalue,
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        dropdownvalue = newValue!;
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
                    onPressed: () {  },
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

  void onToggleShowPass() {
    setState(() {
      showPass = !showPass;
    });
  }


  // URL RESGISTER = "https://localsearch-vrp.herokuapp.com/api/auth/register"
}
