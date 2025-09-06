import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/styles/colors.dart';
import 'package:flutter_application_1/features/Auth/user_model.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //errors ui
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: LiquidGlassLayer(
          settings: LiquidGlassSettings(
            thickness: 8,
            glassColor: AppColors.pink,
            blur: 6.0,
          ),
          child: Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.transparent,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
        name: displayName ?? "",
        imageUrl: imageUrl ?? "",
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
      return userModel;
      //navigation to signin page
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case "weak-password":
          errorMessage = 'weak-password';
          break;
        case 'email-already-in-use':
          errorMessage = 'email-already-in-use';
          break;
        case 'invalid-email':
          errorMessage = 'invalid-email';
          break;
        default:
          errorMessage = ' faild to signin please try again : ${e.message}';
      }
      showSnackBar(context, errorMessage);
      return null;
    } catch (e) {
      showSnackBar(context, "$e");
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
        showSnackBar(context, "user-not-found");
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
      showSnackBar(context, "$e");
    }
  }

  //signout
  Future<void> signout(BuildContext context) async {
    try {
      await _auth.signOut();
    } catch (e) {
      showSnackBar(context, "faild to logout try again : $e");
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
        showSnackBar(context, 'بيانات المستخدم غير موجودة في Firestore.');
        return null;
      }
      return UserModel.frommap(doc.data()!);
    } catch (e) {
      showSnackBar(context, 'فشل جلب بيانات المستخدم: $e');
      return null;
    }
  }
}
