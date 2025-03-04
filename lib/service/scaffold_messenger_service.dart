import 'package:calories_app/widget/snackbar/error.dart';
import 'package:calories_app/widget/snackbar/success.dart';
import 'package:flutter/material.dart';

class ScaffoldMessengerService {
  static final instance = ScaffoldMessengerService._();

  ScaffoldMessengerService._();

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      _scaffoldMessengerKey;

  void displayError(String message) {
    _scaffoldMessengerKey.currentState?.removeCurrentSnackBar(
      reason: SnackBarClosedReason.dismiss,
    );
    _scaffoldMessengerKey.currentState?.showSnackBar(
      ErrorSnackbar(
        text: message,
      ),
    );
  }

  void displaySuccess(String message) {
    _scaffoldMessengerKey.currentState?.removeCurrentSnackBar(
      reason: SnackBarClosedReason.dismiss,
    );
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SuccessSnackbar(
        text: message,
      ),
    );
  }
}
