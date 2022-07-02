import 'dart:convert';

RegisterResponseModel regiserResponseModel (String str) => RegisterResponseModel.fromJson(json.decode(str));
class RegisterResponseModel {
  RegisterResponseModel({
    required this.iduser,
    required this.username,
    required this.password,
    required this.fullname,
    required this.age,
    required this.address,
    required this.phonenumber,
    required this.role,
    required this.vehicle,
  });
  late final int iduser;
  late final String username;
  late final String password;
  late final String fullname;
  late final int age;
  late final String address;
  late final int phonenumber;
  late final Role role;
  late final Vehicle vehicle;

  RegisterResponseModel.fromJson(Map<String, dynamic> json){
    iduser = json['iduser'];
    username = json['username'];
    password = json['password'];
    fullname = json['fullname'];
    age = json['age'];
    address = json['address'];
    phonenumber = json['phonenumber'];
    role = Role.fromJson(json['role']);
    vehicle = Vehicle.fromJson(json['vehicle']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['iduser'] = iduser;
    _data['username'] = username;
    _data['password'] = password;
    _data['fullname'] = fullname;
    _data['age'] = age;
    _data['address'] = address;
    _data['phonenumber'] = phonenumber;
    _data['role'] = role.toJson();
    _data['vehicle'] = vehicle.toJson();
    return _data;
  }
}

class Role {
  Role({
    required this.idRole,
    required this.nameRole,
  });
  late final int idRole;
  late final String nameRole;

  Role.fromJson(Map<String, dynamic> json){
    idRole = json['id_role'];
    nameRole = json['name_role'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id_role'] = idRole;
    _data['name_role'] = nameRole;
    return _data;
  }
}

class Vehicle {
  Vehicle({
    required this.idVehicle,
    required this.capacity,
    required this.cost,
    required this.loading,
    required this.status,
    required this.nodes,
  });
  late final int idVehicle;
  late final int capacity;
  late final int cost;
  late final int loading;
  late final bool status;
  late final List<dynamic> nodes;

  Vehicle.fromJson(Map<String, dynamic> json){
    idVehicle = json['id_vehicle'];
    capacity = json['capacity'];
    cost = json['cost'];
    loading = json['loading'];
    status = json['status'];
    nodes = List.castFrom<dynamic, dynamic>(json['nodes']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id_vehicle'] = idVehicle;
    _data['capacity'] = capacity;
    _data['cost'] = cost;
    _data['loading'] = loading;
    _data['status'] = status;
    _data['nodes'] = nodes;
    return _data;
  }
}
