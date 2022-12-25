import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timetrackingapp_udemy/common_widgets/custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton(
      {required String text,
      required VoidCallback onPressed,
      required bool isDisabled})
      : super(
          child: Text(
            text,
            style: TextStyle(),
          ),
          height: 44,
          color: isDisabled ? Colors.indigo : Colors.grey,
          borderRadius: 4,
          onPressed: onPressed,
        );
}
