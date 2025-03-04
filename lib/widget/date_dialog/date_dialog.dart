import 'package:calories_app/theme/main.dart';
import 'package:flutter/material.dart';

Future<DateTime?> dateDialogBuilder(
    BuildContext context, DateTime? initialDate) {
  return showDatePicker(
    builder: (context, child) {
      return Theme(
        data: MainTheme().mainTheme.copyWith(
              colorScheme: const ColorScheme(
                brightness: Brightness.dark,
                primary: Colors.white,
                onPrimary: Colors.black,
                secondary: Colors.white,
                onSecondary: Colors.black,
                error: Colors.red,
                onError: Colors.white,
                background: Colors.black,
                onBackground: Colors.white,
                surface: Colors.black,
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: Colors.black,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
              ),
            ),
        child: child ?? Container(),
      );
    },
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2010),
    lastDate: DateTime.now(),
  );
}
