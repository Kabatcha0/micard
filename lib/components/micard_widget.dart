import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:micard/shared/const.dart';

class MicardWidget extends StatelessWidget {
  String type;
  String content;
  String assetName;
  bool check;

  MicardWidget(
      {required this.content,
      required this.type,
      required this.assetName,
      required this.check});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.03,
      height: 56,
      padding: const EdgeInsetsDirectional.only(start: 10),
      decoration: BoxDecoration(
          color: check ? Colors.white : Colors.deepPurple,
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: TextStyle(
                    color: check ? Colors.black : Colors.white,
                    fontSize: Const.fontOne,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: check ? Colors.black : Colors.grey[300],
                    fontSize: Const.fontTwo,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage(assetName),
          )
        ],
      ),
    );
  }
}
