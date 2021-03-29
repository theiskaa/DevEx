import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_button/flutter_button.dart';

import '../../screens/home/training/view/custom/custom_categories.dart';
import '../components/widgets.dart';

class ProfileItemCard extends DevExamStatelessWidget {
  final Stream<QuerySnapshot> stream;
  final String type;
  final Function onTap;
  final bool minVal;
  final userID;

  ProfileItemCard({
    this.stream,
    this.type,
    this.onTap,
    this.userID,
    this.minVal,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return OpacityButton(
          onTap: onTap ?? () => navigateToCustomCategories(context, snapshot),
          opacityValue: .5,
          child: Column(
            children: [
              snapshot.hasData
                  ? buildDataTitle(snapshot)
                  : buildInvisibleData(),
              SizedBox(height: 5),
              buildTypeTitle(),
            ],
          ),
        );
      },
    );
  }

  Text buildDataTitle(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Text(
      "${snapshot.data.docs.length}",
      style: TextStyle(
        color: minVal == true
            ? snapshot.data.docs.length != 10
                ? Colors.black
                : Colors.red[700]
            : Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Opacity buildInvisibleData() => Opacity(
        opacity: 0,
        child: Text(
          "0",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Text buildTypeTitle() => Text(
        type,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black.withOpacity(.8),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      );

  void navigateToCustomCategories(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (
          BuildContext context,
          _,
          __,
        ) =>
            CustomTestCategories(
          userID: userID,
          snapshot: snapshot,
          commingFromProfile: true,
        ),
      ),
    );
  }
}
