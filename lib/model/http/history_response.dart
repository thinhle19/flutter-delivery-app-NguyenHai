import 'package:google_map/model/http/register_response_model.dart';

class HistoryResponse {
  late final int idRoute;
  late final String time;
  late final int costRoute;
  late final int capacityRoute;
  late final int loadingRoute;
  late final bool statusRoute;
  late final List<dynamic> nodes;

  HistoryResponse({
    required this.idRoute,
    required this.time,
    required this.costRoute,
    required this.capacityRoute,
    required this.statusRoute,
    required this.loadingRoute,
    required this.nodes,
  });

  HistoryResponse.fromJson(Map<String, dynamic> json) {
    idRoute = json['id_route'];
    time = json['time'];
    costRoute = json['cost_route'];
    loadingRoute = json['loading_route'];
    capacityRoute = json['capacity_route'];
    statusRoute = json['status_route'];
  }
}
