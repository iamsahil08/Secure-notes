import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _user;
  String? _error;
  bool _isLoading = false;
  bool _isInitializing = true;
  
  // Getters
  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isInitializing => _isInitializing;
  
  AuthProvider() {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? firebaseUser) {
      if (firebaseUser != null) {
        _user = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email!,
          displayName: firebaseUser.displayName,
          photoUrl: firebaseUser.photoURL,
        );
      } else {
        _user = null;
      }
      _isInitializing = false;
      notifyListeners();
    });
    
    // Check initial auth state
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _user = UserModel(
        id: currentUser.uid,
        email: currentUser.email!,
        displayName: currentUser.displayName,
        photoUrl: currentUser.photoURL,
      );
    }
  }
  
  Future<bool> signIn({required String email, required String password}) async {
    try {
      _setLoading(true);
      _error = null;
      
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }
  
  Future<bool> signUp({required String email, required String password}) async {
    try {
      _setLoading(true);
      _error = null;
      
      // Create the user account
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update the user state immediately after successful registration
      final User? user = result.user;
      if (user != null) {
        _user = UserModel(
          id: user.uid,
          email: user.email!,
          displayName: user.displayName,
          photoUrl: user.photoURL,
        );
        notifyListeners();
      }
      
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }
  
  Future<void> signOut() async {
    _setLoading(true);
    await _auth.signOut();
    _setLoading(false);
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }
  
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'This email is already in use.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
