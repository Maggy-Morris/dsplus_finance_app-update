// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; //Import intl in the file this is being done

// Future<void> _selectDate(BuildContext context) async {
//   DateFormat formatter =
//       DateFormat('dd/MM/yyyy'); //specifies day/month/year format

//   final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(1901, 1),
//       lastDate: DateTime(2100));
//   if (picked != null && picked != selectedDate)
//     setState(() {
//       selectedDate = picked;
//       _date.value = TextEditingValue(
//           text: formatter.format(
//               picked)); //Use formatter to format selected date and assign to text field
//     });
// }
