import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Auth/user_model.dart';

import '../../common/widgets/LiquidSnackBar.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //errors ui

  //signup
  Future<UserModel?> signup(
    BuildContext context,
    String email,
    String password,
    String displayName,
    String imageUrl,
  ) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user!;
      final userModel = UserModel(
        uid: user.uid,
        email: user.email ?? "",
        name: displayName,
        imageUrl: imageUrl,
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
      LiquidSnackBar.show(context, message: "Account created successfully 🎉");
      return userModel;
      //navigation to signin page
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "weak-password":
          LiquidSnackBar.show(context, message: 'weak-password');
          break;
        case 'email-already-in-use':
          LiquidSnackBar.show(context, message: 'email-already-in-use');
          break;
        case 'invalid-email':
          LiquidSnackBar.show(context, message: 'invalid-email');
          break;
        default:
          LiquidSnackBar.show(
            context,
            message: ' faild to signin please try again : ${e.message}',
          );
      }
      LiquidSnackBar.show(context, message: "$e");
      return null;
    } catch (e) {
      LiquidSnackBar.show(context, message: "$e");
      return null;
    }
  } //signup fun

  //signin
  Future<UserModel?> signin(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user!;
      final doc = await _firestore.collection("users").doc(user.uid).get();

      if (!doc.exists) {
        LiquidSnackBar.show(context, message: "user-not-found");
        return null;
      }
      return UserModel.frommap(doc.data()!);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case "user-not-found":
          errorMessage = "user-not-found";
          break;
        case 'wrong-password':
          errorMessage = 'wrong-password';
          break;
        case 'invalid-email':
          errorMessage = 'invalid-email';
          break;
        default:
          errorMessage = 'faild to login please try again : ${e.message}';
      }
    } catch (e) {
      LiquidSnackBar.show(context, message: "$e");
    }
    return null;
  }

  //signout
  Future<void> signout(BuildContext context) async {
    try {
      await _auth.signOut();
    } catch (e) {
      LiquidSnackBar.show(context, message: "faild to logout try again : $e");
    }
  }

  //currentuser
  Future<UserModel?> getCurrentUser(BuildContext context) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return null;
      }
      final doc = await _firestore.collection("users").doc(user.uid).get();
      if (!doc.exists) {
        LiquidSnackBar.show(
          context,
          message: 'بيانات المستخدم غير موجودة في Firestore.',
        );
        return null;
      }
      return UserModel.frommap(doc.data()!);
    } catch (e) {
      LiquidSnackBar.show(context, message: 'فشل جلب بيانات المستخدم: $e');
      return null;
    }
  }
}
