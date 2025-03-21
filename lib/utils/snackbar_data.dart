import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SnackbarData {
  SnackbarData(this.l10n);
  final AppLocalizations l10n;

  SnackBar get error => SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        showCloseIcon: true,
        content: Text(l10n.dreamJourneyQuestion),
      );
}
