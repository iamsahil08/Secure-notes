import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Check if Firebase is initialized properly
  bool get isFirebaseInitialized => Firebase.apps.isNotEmpty;

  // Get current user
  Stream<UserModel?> get userStream {
    return _auth.authStateChanges().map((User? user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }

  // Get current user once (not as stream)
  UserModel? get currentUser {
    final user = _auth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  // Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final User? user = result.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'null-user',
          message: 'Sign in failed: User is null',
        );
      }
      
      return UserModel.fromFirebaseUser(user);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Register with email and password
  Future<UserModel> registerWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final User? user = result.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'null-user',
          message: 'Registration failed: User is null',
        );
      }
      
      return UserModel.fromFirebaseUser(user);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions and provide user-friendly messages
  Exception _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return FirebaseAuthException(
            code: e.code,
            message: 'No user found with this email.',
          );
        case 'wrong-password':
          return FirebaseAuthException(
            code: e.code,
            message: 'Wrong password provided.',
          );
        case 'email-already-in-use':
          return FirebaseAuthException(
            code: e.code,
            message: 'This email is already in use.',
          );
        case 'invalid-email':
          return FirebaseAuthException(
            code: e.code,
            message: 'The email address is not valid.',
          );
        case 'weak-password':
          return FirebaseAuthException(
            code: e.code,
            message: 'The password is too weak.',
          );
        case 'operation-not-allowed':
          return FirebaseAuthException(
            code: e.code,
            message: 'Email/password accounts are not enabled.',
          );
        default:
          return FirebaseAuthException(
            code: e.code,
            message: e.message ?? 'An unknown error occurred.',
          );
      }
    }
    return Exception('An unexpected error occurred: ${e.toString()}');
  }
}
