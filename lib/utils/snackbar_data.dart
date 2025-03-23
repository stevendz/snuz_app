import 'package:flutter/material.dart';
import 'package:snuz_app/main.dart';

class SnackbarData {
  SnackBar get error => SnackBar(
        backgroundColor: const Color(0xffb63b45),
        content: Text(l10n.errorTryAgainLater),
      );
  SnackBar get noInternet => SnackBar(
        backgroundColor: const Color(0xffe29247),
        content: Text(l10n.noInternetWarning),
      );
  SnackBar get downloadedSuccessfully => SnackBar(
        backgroundColor: const Color(0xff5d8b7d),
        content: Text(l10n.downloadedSuccessfully),
      );
}
