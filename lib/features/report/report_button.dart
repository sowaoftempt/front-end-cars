//features/report/report_button.dart
import 'package:flutter/material.dart';
import 'report_popup.dart';

class ReportButton extends StatelessWidget {
const ReportButton({super.key});

@override
Widget build(BuildContext context) {
return Container(
decoration: BoxDecoration(
boxShadow: [
BoxShadow(
color: Colors.red.withOpacity(0.3),
blurRadius: 12,
offset: const Offset(0, 4),
),
],
borderRadius: BorderRadius.circular(60),
),
child: ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFFFF0000),
minimumSize: const Size.fromHeight(56),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(60),
),
elevation: 0,
),
onPressed: () => showDialog(
context: context,
builder: (_) => const ReportPopup(),
),
child: const Text(
'REPORT',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
letterSpacing: 1.1,
color: Colors.white,
),
),
),
);
}
}