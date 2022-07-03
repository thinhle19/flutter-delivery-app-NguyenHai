import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryListTile extends StatelessWidget {
  final int leading;
  late String date;
  final String amount;
  final String weight;

  HistoryListTile({
    Key? key,
    required this.leading,
    required this.date,
    required this.amount,
    required this.weight,
  }) : super(key: key) {
    _formatDateString();
  }

  void _formatDateString() {
    final f = new DateFormat('yyyy-MM-dd HH:mm');
    date = f.format(DateTime.parse(date));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        height: 90,
        child: Card(
          elevation: 1,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 40,
              child: Text(
                leading.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                date,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: Text('Amount: $amount'),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Column(
                children: [
                  Icon(Icons.scale),
                  SizedBox(
                    height: 5,
                  ),
                  Text('$weight kg'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
