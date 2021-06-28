import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  //AuthForm({Key key}) : super(key: key);
  final bool iloading;
  AuthForm(this.submitfm, this.iloading);
  final void Function(String email, String username, String password,
      bool islogin, BuildContext ctx, String masterkey) submitfm;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var isLogIn = false;
  var _userEmail = '';
  var _userPass = '';
  var _userUsername = '';
  var _masterKey = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void _trySubmit() {
      final isValid = _formKey.currentState.validate();

      FocusScope.of(context).unfocus();

      if (isValid) {
        _formKey.currentState.save();

        widget.submitfm(_userEmail.trim(), _userUsername.trim(),
            _userPass.trim(), isLogIn, context, _masterKey.trim());
      }
    }

    return Center(
      child: Card(
        shadowColor: Colors.black,
        elevation: 20,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: ValueKey("email"),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Email"),
                    validator: (value) {
                      if (value.isEmpty || !value.contains("@dti")) {
                        return "Log in With Your Dti Gmail";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!isLogIn)
                    TextFormField(
                      key: ValueKey("username"),
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(labelText: "User Name"),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return "Please Enter Atleast 4 Charecter";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userUsername = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey("password"),
                    keyboardType: TextInputType.visiblePassword,
                    decoration: isLogIn
                        ? InputDecoration(labelText: "Password")
                        : InputDecoration(labelText: "Any Password"),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return "Please Enter Atleast 7 Charecter";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPass = value;
                    },
                  ),
                  if (!isLogIn)
                    TextFormField(
                      key: ValueKey("masterkey"),
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          labelText: "Master Key Only Admin Access"),
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty || value.length < 8) {
                          return "Who Are You.???? You Are Not Admin";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _masterKey = value;
                      },
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (widget.iloading) CircularProgressIndicator(),
                  if (!widget.iloading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          isLogIn ? "Log In" : "Sign Up",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  if (!widget.iloading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogIn = !isLogIn;
                          print(isLogIn);
                        });
                      },
                      child: Text(isLogIn
                          ? "Create New Account"
                          : "I Already have a Account"),
                    ),
                ],
              )),
        ),
      ),
    );
  }
}
