import 'package:flutter/material.dart';

class Messenger {
  static final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar({
    String message = 'An unexpected error occurred, please try again!',
    double snackBarWidth = 300.0,
  }) {
    scaffoldKey.currentState!.clearSnackBars();
    scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        duration: const Duration(milliseconds: 4000),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(right: 20, left: 20, top: 30, bottom: 20),
        content: SizedBox(
          child: Row(
            children: [
              Text(
                message,
                style: TextStyle(
                  color: Colors.white.withOpacity(.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
