import 'dart:developer';

import 'package:google_map/model/http/register_response_model.dart';

class AddHistoryRequestModel {
  final String time;
  final String costRoute;
  final String loadingRoute;
  final String capacityRoute;
  final bool statusRoute;
  final Vehicle vehicle;

  AddHistoryRequestModel({
    required this.time,
    required this.costRoute,
    required this.capacityRoute,
    required this.statusRoute,
    required this.vehicle,
    required this.loadingRoute,
  });

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'cost_route': costRoute,
      'loading_route': loadingRoute,
      'capacity_route': capacityRoute,
      'status_route': true,
      'vehicle': vehicle.toJson(),
    };
  }
}
