import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:micard/shared/const.dart';

class WelcomePageButton extends StatelessWidget {
  Color color;
  String text;
  WelcomePageButton({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: AlignmentDirectional.center,
      height: 60,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(15), color: color),
      child: Text(text,
          style: TextStyle(
              fontSize: Const.fontTwo,
              fontWeight: FontWeight.bold,
              color: Colors.white)),
    );
  }
}
