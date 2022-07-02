class Vehicle {
  Vehicle({
    required this.idVehicle,
    required this.status,

  });

  int idVehicle;
  bool status;

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    idVehicle: json["id_vehicle"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id_vehicle": idVehicle,
    "status": status,
  };
}

