import 'package:flutter/material.dart';
import 'package:snuz_app/main.dart';

class SnackbarData {
  SnackBar get error => SnackBar(
        backgroundColor: Colors.red,
        content: Text(l10n.errorTryAgainLater),
      );
  SnackBar get noInternet => SnackBar(
        backgroundColor: Colors.yellow,
        content: Text(l10n.noInternetWarning),
      );
  SnackBar get downloadedSuccessfully => SnackBar(
        backgroundColor: Colors.green,
        content: Text(l10n.downloadedSuccessfully),
      );
}
