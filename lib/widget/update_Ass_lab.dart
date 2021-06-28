import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateAssLabData extends StatefulWidget {
  final uid;
  UpdateAssLabData(this.uid);

  @override
  _UpdateAssLabDataState createState() => _UpdateAssLabDataState();
}

class _UpdateAssLabDataState extends State<UpdateAssLabData> {
  var _assOrLab = '';
  var _homeWork = '';
  var _subject = '';

  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  List<String> listOfGroup = ['A1', 'A2', 'B'];
  List<String> assOrlav = ['Assginment', 'Lab'];

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

      if (_subject.isEmpty || _assOrLab.isEmpty || _homeWork.isEmpty) {
        snakBarMsg("Please Fill Up Every Filed", Colors.red);
      } else {
        FirebaseFirestore.instance.collection("/ald").doc(widget.uid).update({
          "hw": _homeWork.trim(),
          "subject": _subject.trim(),
          "title": _assOrLab.trim()
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
          title: Text("Update Assignment?Lab"),
        ),
        body: Center(
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
                        key: ValueKey("subject"),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(labelText: "Subject"),
                        // obscureText: true,
                        validator: (value) {
                          return null;
                        },
                        onSaved: (value) {
                          _subject = value;
                        },
                      ),
                      DropdownButtonFormField(
                        key: ValueKey("Assignment/Lab"),
                        hint: Text(
                          'Choose Assginment/lab',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _assOrLab = value;
                          });
                        },
                        validator: (String value) {
                          return null;
                        },
                        items: assOrlav.map((String val) {
                          return DropdownMenuItem(
                            value: val,
                            child: Text(
                              val,
                            ),
                          );
                        }).toList(),
                      ),
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
        ));
  }
}
