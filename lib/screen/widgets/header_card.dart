import 'package:flutter/material.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({Key? key, required this.amount, required this.orderNum})
      : super(key: key);
  final String amount;
  final String orderNum;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 5,
        child: Row(
          children: [
            Flexible(
              flex: 5,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total amount',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.monetization_on),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          amount,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: VerticalDivider(
                thickness: 2,
                color: Colors.black,
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total orders',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_box),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          orderNum,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
