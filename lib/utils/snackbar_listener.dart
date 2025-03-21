import 'package:flutter/material.dart';
import 'package:snuz_app/providers/snackbar_service.dart';

class SnackbarListener extends StatefulWidget {
  final Widget child;

  const SnackbarListener({super.key, required this.child});

  @override
  State<SnackbarListener> createState() => _SnackbarListenerState();
}

class _SnackbarListenerState extends State<SnackbarListener> {
  @override
  void initState() {
    super.initState();
    SnackbarService.instance.addListener(_onSnackbarChanged);
  }

  @override
  void dispose() {
    SnackbarService.instance.removeListener(_onSnackbarChanged);
    super.dispose();
  }

  void _onSnackbarChanged() {
    final SnackBar? snackBar = SnackbarService.instance.snackbarNotification;
    if (snackBar == null) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    SnackbarService.instance.reset();
  }

  @override
  Widget build(_) => widget.child;
}
