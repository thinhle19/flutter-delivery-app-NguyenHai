import 'package:flutter/material.dart';
import 'package:google_map/blocs/place_bloc.dart';
import 'package:google_map/model/place_item_res.dart';

class RidePickerScreen extends StatefulWidget {
  final String selectedAddress;
  final Function(PlaceItemRes, bool) onSelected;
  final bool _FromAddress;
  const RidePickerScreen(
      this.selectedAddress, this.onSelected, this._FromAddress,);

  @override
  _RidePickerScreenState createState() => _RidePickerScreenState();
}

class _RidePickerScreenState extends State<RidePickerScreen> {
  var _addressController;
  var placeBloc = PlaceBloc();

  @override
  void initState() {
    _addressController = TextEditingController(text: "");
    super.initState();
  }

  @override
  void dispose() {
    placeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Color(0xfff8f8f8),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: <Widget>[
                      SizedBox(
                        width: 50,
                        height: 60,
                        child: Center(
                          child:
                              Image.asset('assets/icons/ic_location_black.png'),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 12,
                        height: 40,
                        width: 60,
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              _addressController.text = "";
                            },
                            child: Image.asset('assets/icons/ic_remove_x.png'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40, right: 50),
                        child: TextField(
                          controller: _addressController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (str) {
                            placeBloc.searchPlace(str);
                          },
                          style:
                              TextStyle(fontSize: 16, color: Color(0xff323643)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                child: StreamBuilder(
                    stream: placeBloc.placeStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot.data.toString());
                        if (snapshot.data == "start") {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } // Neu co dữ liệu sẽ tạo vòng loading...

                        print(snapshot.data.toString());
                        List<PlaceItemRes?> places =
                        snapshot.data as List<PlaceItemRes>;
                        return ListView.separated(
                          shrinkWrap: true,
                          // scrollDirection: ,
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                child: Icon(Icons.pin_drop, color: Colors.white),
                              ),
                              title: Text(places.elementAt(index)?.name ?? ""),
                              subtitle:
                              Text(places.elementAt(index)?.address ?? ""),
                              onTap: () {
                                print("on tap");
                                Navigator.of(context).pop();
                                widget.onSelected(places.elementAt(index)!,
                                    widget._FromAddress);
                              },
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            // Ngăn cách giữa các list
                            height: 1,
                            color: Color(0xfff5f5f5),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
