import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppButton extends StatelessWidget {
  final String text;
  final double? height, width;
  final bool hasRadius;
  final bool hasBorder;
  final Color background;
  final Color foreground;
  final Function()? pressed;
  AppButton(
      {required this.text,
        required this.pressed,
        this.height ,
        this.foreground=Colors.white,
        this.hasBorder=false,
        this.width,
        required this.hasRadius ,
        this.background = Colors.deepPurple});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: background,
            foregroundColor: foreground,
            shape: RoundedRectangleBorder(
                side:hasBorder? BorderSide(color: Colors.black):BorderSide(color: Colors.transparent),
                borderRadius: hasRadius
                    ? BorderRadius.circular(30)
                    : BorderRadius.circular(0)),
            minimumSize: Size(width??150, height??40)),
        onPressed: pressed,
        icon: Icon(FontAwesomeIcons.moneyBill),
        label: Text(text, style: TextStyle(fontSize: 16,color: foreground)));
  }
}
