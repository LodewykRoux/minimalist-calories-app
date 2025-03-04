import 'package:flutter/material.dart';

class CustomOutlinedButton extends ElevatedButton {
  CustomOutlinedButton({
    super.key,
    required void Function()? onPressed,
    required Widget? child,
  }) : super(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Colors.white,
              ),
            ),
          ),
          onPressed: onPressed,
          child: child,
        );
}
