import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/LiquidSnackBar.dart';
import 'package:flutter_application_1/features/Auth/services.dart';
import 'package:flutter_application_1/features/Auth/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';

final authController = Provider((ref) => AuthController(ref));
final currentUser = StateProvider<UserModel?>((ref) => null);

final userStreamProvider = StreamProvider<UserModel?>((ref) {
  return firebase_auth.FirebaseAuth.instance.authStateChanges().switchMap((
    firebaseUser,
  ) {
    if (firebaseUser == null) {
      return Stream.value(null);
    } else {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .snapshots()
          .map((snapshot) {
            if (snapshot.exists && snapshot.data() != null) {
              return UserModel.frommap(snapshot.data()!);
            } else {
              return null;
            }
          });
    }
  });
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

  Future<void> updateUserProfile(
    BuildContext context, {
    required String name,
    String? imageUrl,
  }) async {
    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    try {
      await firebaseUser.updateDisplayName(name);

      final updateData = <String, dynamic>{'displayName': name};
      if (imageUrl != null) {
        await firebaseUser.updatePhotoURL(imageUrl);
        updateData['imageUrl'] = imageUrl;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .update(updateData);

      LiquidSnackBar.show(context, message: "Profile updated successfully!");
    } catch (e) {
      LiquidSnackBar.show(context, message: "Error updating profile: $e");
    }
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
