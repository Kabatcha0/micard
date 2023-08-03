import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:micard/shared/const.dart';

class SocialWidget extends StatelessWidget {
  String assetName;
  SocialWidget({required this.assetName});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: Const.raduisOfSocial,
      backgroundImage: AssetImage(assetName),
    );
  }
}
