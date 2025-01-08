import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solutech_interview/domain/models/user.dart' as app_user;

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<app_user.User?> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      final userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) {
        // Create new user document if it doesn't exist
        final newUser = app_user.User(
          id: firebaseUser.uid,
          email: firebaseUser.email!,
          displayName: firebaseUser.displayName ?? firebaseUser.email!.split('@')[0],
          lastSyncTime: DateTime.now(),
        );
        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(_userToMap(newUser));
        return newUser;
      }

      return _mapToUser(userDoc.data()!, firebaseUser.uid);
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }



  Exception _handleAuthError(dynamic e) {
    if (e is firebase_auth.FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return Exception('No user found with this email.');
        case 'wrong-password':
          return Exception('Wrong password provided.');
        case 'email-already-in-use':
          return Exception('Email is already in use.');
        default:
          return Exception(e.message ?? 'Authentication failed.');
      }
    }
    return Exception('Something went wrong.');
  }

  Map<String, dynamic> _userToMap(app_user.User user) {
    return {
      'email': user.email,
      'displayName': user.displayName,
      'totalXp': user.totalXp,
      'level': user.level,
      'badges': user.badges,
      'lastSyncTime': user.lastSyncTime.toIso8601String(),
    };
  }

  app_user.User _mapToUser(Map<String, dynamic> map, String uid) {
    return app_user.User(
      id: uid,
      email: map['email'] as String,
      displayName: map['displayName'] as String,
      totalXp: map['totalXp'] as int? ?? 0,
      level: map['level'] as int? ?? 1,
      badges: List<String>.from(map['badges'] ?? []),
      lastSyncTime: DateTime.parse(map['lastSyncTime'] as String),
    );
  }
} 