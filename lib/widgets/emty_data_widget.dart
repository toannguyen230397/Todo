import 'package:flutter/material.dart';

Widget EmptyDataWidget({required String Label}) {
  return Column(
    children: [
      Image.asset('assets/images/no_data_photo.jpg'),
      Text(
        Label,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black26),
      )
    ],
  );
}
