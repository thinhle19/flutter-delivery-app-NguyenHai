class RegisterRequestModel {
  RegisterRequestModel({
    required this.username,
    required this.password,
    required this.fullname,
    required this.age,
    required this.address,
    required this.phoneNumber,
    required this.vehicle,
  });
  late final String username;
  late final String password;
  late final String fullname;
  late final String age;
  late final String address;
  late final int phoneNumber;
  late final RegisteringVehicle vehicle;

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    fullname = json['fullname'];
    age = json['age'];
    address = json['address'];
    phoneNumber = json['phonenumber'];
    vehicle = RegisteringVehicle.fromJson(json['vehicle']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['password'] = password;
    _data['fullname'] = fullname;
    _data['age'] = age.toString();
    _data['address'] = address;
    _data['phonenumber'] = phoneNumber;
    _data['vehicle'] = vehicle.toJson();
    return _data;
  }
}

class RegisteringVehicle {
  RegisteringVehicle({
    required this.idVehicle,
  });
  late final String idVehicle;

  RegisteringVehicle.fromJson(Map<String, dynamic> json) {
    idVehicle = json['id_vehicle'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id_vehicle'] = idVehicle.toString();
    return _data;
  }
}
