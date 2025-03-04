import 'package:flutter/material.dart';

class SuccessSnackbar extends SnackBar {
  final String text;

  SuccessSnackbar({
    Key? key,
    required this.text,
  }) : super(
          key: key,
          content: Text(
            text,
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        );
}
