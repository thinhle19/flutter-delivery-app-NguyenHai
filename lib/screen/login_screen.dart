import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:google_map/screen/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_map/common/AppColors.dart';
import 'package:google_map/component/Loading.dart';
import 'package:google_map/model/login_request_model.dart';
import 'package:http/http.dart' as http;
import 'home_page_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final scaffoldKey = GlobalKey<ScaffoldState>();
  // GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late LoginRequestModel requestModel;
  bool showPass = false; // Tạo 1 biến showPass = false (Ko Show Pass)
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final _userError = "Invalid Username";
  final _passError = "Invalid Password";
  var _userInvalid = false; // Tài khoản hợp lệ
  var _passInvalid = false;

  @override
  void initState() {
    super.initState();
    requestModel = LoginRequestModel(username: '', password: '');
    checklogin();
  }

  void checklogin() async {
    // Kiem tra thong tin dang nhap da co san hay chua
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? val = sharedPreferences.getString("login");
    if (val != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePageScreen()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFFFFFFF),
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 100, 30, 0), // Căn chỉnh lề
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
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
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: TextFormField(
                  onSaved: (input) => requestModel.username = input!,
                  controller: _userController,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.person),
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
                    TextFormField(
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passController,
                      obscureText: !showPass,
                      onSaved: (input) => requestModel.password = input!,
                      //  phủ định của !showPass = true ( Ẩn mật khẩu)
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.lock),
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
                child: SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    height: 50,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                SignUpScreen()));
                                  }, // chưa hành động onTap
                                style: const TextStyle(
                                    color: Colors.blue, fontSize: 15))
                          ]),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Image.asset('assets/screen/Screen.png',
                    height: 140, width: 140),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getUserToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get("token") as String;
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
      var jsonResponse;
      var res = await http.post(
        Uri.parse('https://localsearch-vrp.herokuapp.com/api/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "username": _userController.text,
          "password": _passController.text,
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
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          await sharedPreferences.setString("token", jsonResponse['token']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => const HomePageScreen()),
              (Route<dynamic> route) => false);
        }
      } else {
        setState(() {
          Loading.hideLoadingDialog(context);
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Error"),
                  content: const Text("Account does not exist!"),
                  actions: [
                    TextButton(
                      child: const Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
        print("Response status: ${res.body}");
      }
    }
  }

  void onToggleShowPass() {
    setState(() {
      showPass = !showPass;
    });
  }
}
