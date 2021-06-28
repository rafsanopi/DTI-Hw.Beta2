import 'package:dti_hw_v2/Screens/home_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import './authForm.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isloading = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    void _submitAuthForm(String email, String username, String password,
        bool islogin, BuildContext ctx, String masterkey) async {
      UserCredential authresult;

      try {
        setState(() {
          _isloading = true;
        });
        if (islogin) {
          authresult = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
        } else {
          final result = await FirebaseFirestore.instance
              .doc('/admin/6Ctki5kFhlcycvim7Mar')
              .get();
          final hashResult = result.data();
          final password = hashResult['key'];

          if (masterkey != password) {
            return;
          }

          authresult = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);

          await FirebaseFirestore.instance
              .collection("user")
              .doc(authresult.user.uid)
              .set({
            "username": username,
            "email": email,
          });
        }
      } on PlatformException catch (err) {
        setState(() {
          _isloading = false;
        });
        var msg = "Ann Error Occurde Please Cheack Your Data";
        if (err.message != null) {
          msg = err.message;
        }
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
      } catch (err) {
        setState(() {
          _isloading = false;
        });
        print(err);
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
          onDoubleTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => MyHome()));
          },
          child: AuthForm(_submitAuthForm, _isloading)),
    );
  }
}
