import 'package:flutter/material.dart';

Widget EmptyDataWidget({required String Label}) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/no_data_photo.jpg'),
        Text(
          Label,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black26),
        )
      ],
    ),
  );
}
