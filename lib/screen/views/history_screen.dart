import 'package:flutter/material.dart';
import 'package:google_map/model/http/history_response.dart';
import 'package:google_map/screen/widgets/header_card.dart';
import 'package:google_map/screen/widgets/history_list_tile.dart';
import 'package:google_map/service/http_service.dart';
import 'package:google_map/service/local_storage.dart';

import '../notification_screen.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isLoading = true;
  bool _isInit = true;
  List<HistoryResponse> dataList = [];
  late int totalAmount = 0;
  late int totalOrder;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _loadData();
    }
    _isInit = false;
  }

  void _loadData() async {
    dataList = await HttpService.getHistoryFromDriver(
      /*   (await LocalStorage.getVehicleId())! */ '254',
    );
    _calculateAmountAndOrder();
    setState(() {
      _isLoading = false;
    });
  }

  void _calculateAmountAndOrder() {
    totalOrder = dataList.length;
    totalAmount = dataList.fold<int>(
        0, (previousValue, element) => element.costRoute + previousValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            NotificationScreen()));
              },
              icon: const Icon(Icons.notifications)),
        ],
        centerTitle: true,
        title: Text(
          "History",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                HeaderCard(
                  amount: totalAmount.toString(),
                  orderNum: totalOrder.toString(),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: MediaQuery.of(context).size.height - 150 - 16,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return HistoryListTile(
                          leading: index + 1,
                          amount: dataList[index].costRoute.toString(),
                          date: dataList[index].time,
                          weight: dataList[index].loadingRoute.toString(),
                        );
                      },
                      itemCount: dataList.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
