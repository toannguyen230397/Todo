import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class DateTimePickerHelper extends StatefulWidget {
  const DateTimePickerHelper({super.key});

  @override
  State<DateTimePickerHelper> createState() => _DateTimePickerHelperState();
}

class _DateTimePickerHelperState extends State<DateTimePickerHelper> {
  void dateTimePicker(TextEditingController dateController) {
  DatePicker.showDateTimePicker(context,
      showTitleActions: true, minTime: DateTime.now(), onChanged: (date) {
    print('change $date');
    }, onConfirm: (date) {
      setState(() {
        dateController.text = date.toString();
      });;
    }, currentTime: DateTime.now(), locale: LocaleType.vi);
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
