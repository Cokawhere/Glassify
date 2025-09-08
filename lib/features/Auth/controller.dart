import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Auth/services.dart';
import 'package:flutter_application_1/features/Auth/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authController = Provider((ref) => AuthController(ref));
final currentUser = StateProvider<UserModel?>((ref) => null);


final userStreamProvider = StreamProvider<UserModel?>((ref) async* {
  await for (final firebaseUser in firebase_auth.FirebaseAuth.instance.authStateChanges()) {
    if (firebaseUser == null) {
      yield null;
    } else {
      await Future.delayed(Duration(milliseconds: 100));
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .get();
      if (!doc.exists) {
        yield null;
      } else {
        yield UserModel.frommap(doc.data()!);
      }
    }
  }
});

class AuthController {
  final Ref ref;
  final AuthServices authServices;
  AuthController(this.ref) : authServices = AuthServices();

  
  Future<void> signup(
    BuildContext context, {
    required String email,
    required String password,
    required String displayName,
    required String? imageUrl,
  }) async {
    final user = await authServices.signup(
      context,
      email,
      password,
      displayName,
      imageUrl ?? "",
    );
    if (user != null) {
      ref.read(currentUser.notifier).state = user;
      context.go('/home');
    }
    
  }


  Future<UserModel?> signin(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    final user = await authServices.signin(context, email, password);
        context.go('/home');

    if (user != null) {
      ref.read(currentUser.notifier).state = user;
    }
    return user;
  }

  Future<void> signout(BuildContext context) async {
    await authServices.signout(context);
    ref.read(currentUser.notifier).state = null;
    // await Future.delayed(Duration(milliseconds: 100));
    // context.go('/login');
  }

  // //current user
  // Future<void> checkCurrentUser(BuildContext context) async {
  //   final user = await _authServices.getCurrentUser(context);
  //   ref.read(currentUser.notifier).state = user;
  // }
}
