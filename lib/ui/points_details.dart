import 'package:flutter/material.dart';
import 'package:remember/model/points.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';
import '../app_utils.dart';

class PointsDetails extends StatefulWidget {
  Points points;

  PointsDetails({this.points});

  @override
  _PointsDetailsState createState() => _PointsDetailsState();
}

class _PointsDetailsState extends State<PointsDetails> {
  List<Points> pointListModel = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      pointListModel.add(widget.points);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor2,
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: backgroundColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).translate('result_details'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          )),
      body: SafeArea(
          child: Column(
        children: [
          pointList(context, pointListModel),
        ],
      )),
    );
  }

  Widget pointList(BuildContext context, List<Points> _list) {
    // backing data
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        width: size.width,
        height: size.height,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _list.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(5.0),
              child: customCardPoint(
                _list.elementAt(index),
                context,
              ),
            );
          },
        ),
      ),
    );
  }
}
