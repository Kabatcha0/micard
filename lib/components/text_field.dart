import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:micard/shared/const.dart';

class TextFromFieldWidget extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();
  String text;
  String hint;
  String? Function(String?)? validator;
  TextInputType textInputType;
  int maxLine = 1;
  bool check;
  TextFromFieldWidget(
      {required this.text,
      required this.check,
      required this.hint,
      required this.textEditingController,
      required this.validator,
      required this.maxLine,
      required this.textInputType});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
              color: check ? Colors.white : Colors.black,
              fontSize: Const.fontTwo,
              fontWeight: FontWeight.bold),
        ),
        TextFormField(
          validator: validator,
          controller: textEditingController,
          keyboardType: textInputType,
          maxLines: maxLine,
          decoration: InputDecoration(
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide:
                      BorderSide(color: Colors.grey.shade600, width: 0.4)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              hintText: hint,
              hintStyle: TextStyle(
                  fontSize: Const.fontTwo,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600])),
          style: TextStyle(
            fontSize: Const.fontTwo,
            fontWeight: FontWeight.bold,
            color: check ? Colors.white : Colors.black,
          ),
        )
      ],
    );
  }
}
