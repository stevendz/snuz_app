import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snuz_app/main.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _emailLinkSent = false;

  AuthProvider() {
    _init();
  }

  void _init() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  bool get emailLinkSent => _emailLinkSent;

  Future<bool> sendSignInLink(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _emailLinkSent = false;
      notifyListeners();

      final actionCodeSettings = ActionCodeSettings(
        url: 'https://snuz.app',
        handleCodeInApp: true,
        androidPackageName: 'app.snuz.mobile',
        androidInstallApp: true,
        androidMinimumVersion: '21',
        iOSBundleId: 'app.snuz.webrabbits',
      );

      await _auth.sendSignInLinkToEmail(
        email: email.trim(),
        actionCodeSettings: actionCodeSettings,
      );

      // Store email for later use when handling the link
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('emailForSignIn', email.trim());

      _isLoading = false;
      _emailLinkSent = true;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = l10n.unexpectedError;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithEmailLink(String emailLink) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Retrieve the email from storage
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('emailForSignIn');

      if (email == null) {
        _isLoading = false;
        _errorMessage = l10n.unexpectedError;
        notifyListeners();
        return false;
      }

      // Verify the link is valid
      if (!_auth.isSignInWithEmailLink(emailLink)) {
        _isLoading = false;
        _errorMessage = l10n.invalidCredential;
        notifyListeners();
        return false;
      }

      // Sign in with the email link
      await _auth.signInWithEmailLink(
        email: email,
        emailLink: emailLink,
      );

      // Clear the stored email
      await prefs.remove('emailForSignIn');

      _isLoading = false;
      _emailLinkSent = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = l10n.unexpectedError;
      notifyListeners();
      return false;
    }
  }

  void resetEmailLinkSent() {
    _emailLinkSent = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _emailLinkSent = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = l10n.unexpectedError;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return l10n.userNotFound;
      case 'wrong-password':
        return l10n.wrongPassword;
      case 'invalid-email':
        return l10n.invalidEmail;
      case 'user-disabled':
        return l10n.userDisabled;
      case 'email-already-in-use':
        return l10n.emailAlreadyInUse;
      case 'weak-password':
        return l10n.weakPassword;
      case 'operation-not-allowed':
        return l10n.operationNotAllowed;
      case 'invalid-credential':
        return l10n.invalidCredential;
      default:
        return e.message ?? l10n.unexpectedError;
    }
  }
}
