import 'package:flutter/material.dart';

class ErrorSnackbar extends SnackBar {
  final String text;

  ErrorSnackbar({
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
