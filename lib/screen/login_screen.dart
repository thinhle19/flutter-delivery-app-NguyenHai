import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_map/common/AppColors.dart';
import 'package:google_map/component/Loading.dart';
import 'package:google_map/model/login_model.dart';
import 'package:google_map/model/token.dart';
import 'package:google_map/screen/map_screen.dart';
import 'package:google_map/screen/signup_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  late LoginRequestModel requestModel;
  late Token token;
  bool showPass = false; // Tạo 1 biến showPass = false (Ko Show Pass)
  TextEditingController _userController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  var _userError = "Tài khoản không hợp lệ";
  var _passError = "Mật khẩu không hợp lệ";
  var _userInvalid = false; // Tài khoản hợp lệ
  var _passInvalid = false;

  @override
  void initState() {
    super.initState();
    requestModel = new LoginRequestModel(username: '', password: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.white,
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
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Center(
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: TextFormField(
                  onSaved: (input) => requestModel.username = input!,
                  controller: _userController,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      prefixIcon: Icon(Icons.email),
                      labelText: "Email",
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
                    TextFormField(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passController,
                      obscureText: !showPass,
                      onSaved: (input) => requestModel.password = input!,
                      //  phủ định của !showPass = true ( Ẩn mật khẩu)
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
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
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    height: 50,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "SIGN IN",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    onPressed: () {
                      login();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, //Tạo khoảng cách 2 bên
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                          text: "NEW USER ? ",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          children: <TextSpan>[
                            TextSpan(
                                text: "SIGN UP",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    onSignUpClicked();
                                  }, // chưa hành động onTap
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 15))
                          ]),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Image.asset('assets/screen/Screen.png',
                    height: 140, width: 140),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    setState(() {
      if (_userController.text.length < 5) {
        _userInvalid = true;
      } else {
        _userInvalid = false;
      }

      if (_passController.text.length < 3) {
        _passInvalid = true;
      } else {
        _passInvalid = false;
      }
    });
    if (_passController.text.isNotEmpty && _userController.text.isNotEmpty) {
      Loading.showLoading(context, 'Loading....');
      print(_userController.text);
      print(_passController.text);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var jsonResponse;
      var res = await http.post(
        Uri.parse('https://localsearch-vrp.herokuapp.com/api/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': _userController.text,
          'password': _passController.text,
        }),
      );
      // need to check the api status
      if (res.statusCode == 200) {
        jsonResponse = json.decode(res.body);
        print("Response status: ${res.statusCode}");

        print("Response status: ${res.body}");

        if (jsonResponse != null) {
          setState(() {
            Loading.hideLoadingDialog(context);
          });

          sharedPreferences.setString("token", jsonResponse["token"]);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => MapScreen()),
              (Route<dynamic> route) => false);
        }
      }else{
        setState((){
          Loading.hideLoadingDialog(context);
        });

        print("Response status: ${res.body}");
      }
      // var response = await http.post
      //   Uri.parse('https://localsearch-vrp.herokuapp.com/api/auth/login'),
      //   // body: ({
      //   //   'username': _userController.text,
      //   //   'password': _passController.text,
      //   // }));
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: jsonEncode(<String, String>{
      //     'username': _userController.text,
      //     'password': _passController.text,
      //   }),
      // );
      // if (response.statusCode == 200) {
      //   print(Token.fromJson(jsonDecode(response.body)));
      //   Loading.hideLoadingDialog(context);
      //   Navigator.pushAndRemoveUntil(
      //     context,
      //       MaterialPageRoute(
      //           builder: (BuildContext context) => MapScreen()),
      //       ModalRoute.withName('/first'));
      //   print("Response status: ${response.statusCode}");
      //
      //   print("Response status: ${response.body}");
      // } else {
      //   Loading.hideLoadingDialog(context);
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(SnackBar(content: const Text("Invalid Credentials")));
      //   print("Unsuccessfull");
      // }
    }
  }

  void onToggleShowPass() {
    setState(() {
      showPass = !showPass;
    });
  }

  void onSignUpClicked() {
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: gotoSignUp));
    });
  }

  Widget gotoSignUp(BuildContext context) {
    return SignUpScreen();
  }
}
