import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth_form.dart';
import 'package:flutter/material.dart';

class AuthSceen extends StatefulWidget {
  @override
  _AuthSceenState createState() => _AuthSceenState();
}

class _AuthSceenState extends State<AuthSceen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  _submitAuthForm(
    String email,
    String username,
    String password,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // storage in backend Firebase_Storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + '.jpg');

        await ref.putFile(image).onComplete;
        // Stored in cloud_firestore  database back end
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'email': email,
          'username': username,
        });
      }
    } catch (err) {
      var massage = 'An error occured ,please check your credentials!';
      if (err.message != null) {
        massage = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(massage),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
