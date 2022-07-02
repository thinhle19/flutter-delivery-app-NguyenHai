
class UserInfo {
  UserInfo({
    required this.iduser,
    required this.username,
    required this.password,
    required this.fullname,
    required this.age,
    required this.address,
    required this.role,
    required this.vehicle,
  });

  String iduser;
  String username;
  String password;
  String fullname;
  int age;
  String address;
  Role role;
  Vehicle vehicle;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    iduser: json["iduser"],
    username: json["username"],
    password: json["password"],
    fullname: json["fullname"],
    age: json["age"],
    address: json["address"],
    role: Role.fromJson(json["role"]),
    vehicle: Vehicle.fromJson(json["vehicle"]),
  );

  Map<String, dynamic> toJson() => {
    "iduser": iduser,
    "username": username,
    "password": password,
    "fullname": fullname,
    "age": age,
    "address": address,
    "role": role.toJson(),
    "vehicle": vehicle.toJson(),
  };
}

class Role {
  Role({
    required this.idRole,
    required this.nameRole,
  });

  int idRole;
  String nameRole;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    idRole: json["id_role"],
    nameRole: json["name_role"],
  );

  Map<String, dynamic> toJson() => {
    "id_role": idRole,
    "name_role": nameRole,
  };
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

  int idVehicle;
  int capacity;
  int cost;
  int loading;
  bool status;
  List<dynamic> nodes;

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    idVehicle: json["id_vehicle"],
    capacity: json["capacity"],
    cost: json["cost"],
    loading: json["loading"],
    status: json["status"],
    nodes: List<dynamic>.from(json["nodes"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id_vehicle": idVehicle,
    "capacity": capacity,
    "cost": cost,
    "loading": loading,
    "status": status,
    "nodes": List<dynamic>.from(nodes.map((x) => x)),
  };
}
