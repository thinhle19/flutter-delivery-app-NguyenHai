class RegisterRequestModel {
  RegisterRequestModel({
    required this.username,
    required this.password,
    required this.fullname,
    required this.age,
    required this.address,
    required this.phonenumber,
    required this.vehicle,
  });
  late final String username;
  late final String password;
  late final String fullname;
  late final int age;
  late final String address;
  late final int phonenumber;
  late final Vehicle vehicle;

  RegisterRequestModel.fromJson(Map<String, dynamic> json){
    username = json['username'];
    password = json['password'];
    fullname = json['fullname'];
    age = json['age'];
    address = json['address'];
    phonenumber = json['phonenumber'];
    vehicle = Vehicle.fromJson(json['vehicle']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['password'] = password;
    _data['fullname'] = fullname;
    _data['age'] = age;
    _data['address'] = address;
    _data['phonenumber'] = phonenumber;
    _data['vehicle'] = vehicle.toJson();
    return _data;
  }
}

class Vehicle {
  Vehicle({
    required this.idVehicle,
  });
  late final String idVehicle;

  Vehicle.fromJson(Map<String, dynamic> json){
    idVehicle = json['id_vehicle'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id_vehicle'] = idVehicle;
    return _data;
  }
}
