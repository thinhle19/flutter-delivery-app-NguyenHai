// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../model/login_model.dart';
//
// class APIService {
//   Future<LoginResponseModel> login(LoginResponseModel loginResponseModel) async {
//     String url = "https://localsearch-vrp.herokuapp.com/api/auth/login";
//
//     final res = await http.post(Uri.parse(url), body:requestModel.toJson());
//     if (res.statusCode == 200 || res.statusCode == 400){
//       return LoginResponseModel.fromJson(jsonDecode(res.body));
//     }else{
//       throw Exception('Failed to load data');
//     }
//   }
// }