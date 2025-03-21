import 'package:flutter/material.dart';

class SnackbarService extends ChangeNotifier {
  static final SnackbarService _instance = SnackbarService._();

  SnackbarService._();

  static SnackbarService get instance => _instance;

  SnackBar? _snackbarNotification;

  SnackBar? get snackbarNotification => _snackbarNotification;

  void reset() => _snackbarNotification = null;

  void showSnackbar(SnackBar notification) {
    _snackbarNotification = notification;
    notifyListeners();
  }
}
