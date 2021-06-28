import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateHw extends StatefulWidget {
  final uid;
  UpdateHw(this.uid);

  @override
  _UpdateHwState createState() => _UpdateHwState();
}

class _UpdateHwState extends State<UpdateHw> {
  var _homeWork = '';
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void snakBarMsg(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
    ));
  }

  void enterData() async {
    final isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();

      if (_homeWork.isEmpty) {
        snakBarMsg("Please Fill Up Every Filed", Colors.red);
      } else {
        FirebaseFirestore.instance.collection("/hw").doc(widget.uid).update({
          "hw": _homeWork.trim(),
        });
        snakBarMsg("Successfully Data Updated", Colors.green);
      }

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.pink,
        title: Text("Update HomeWork"),
      ),
      body: Center(
        child: Card(
          shadowColor: Colors.black,
          elevation: 20,
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      maxLines: 3,
                      minLines: 2,
                      key: ValueKey("HomeWork"),
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(labelText: "Home Work"),
                      validator: (value) {
                        return null;
                      },
                      onSaved: (value) {
                        _homeWork = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                            onPressed: enterData,
                            icon: Icon(Icons.update),
                            label: Text("Update"))
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
