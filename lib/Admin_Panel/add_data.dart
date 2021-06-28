import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dti_hw_v2/Screens/home_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  DateTime _selectedDate;
  var isHw = false;
  var _assOrLab = '';
  var _homeWork = '';
  var _subject = '';
  var _selestedGroup = "";
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  List<String> listOfGroup = ['A1', 'A2', 'B'];
  List<String> assOrlav = ['Assginment', 'Lab'];

  void _selectDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void snakBarMsg() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Successfully Data Added"),
      backgroundColor: Colors.green[900],
    ));
  }

  void enterData() async {
    final isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();

    if (isValid && !isHw) {
      _formKey.currentState.save();
      if (_selectedDate == null &&
          _selectedDate == null &&
          _subject == null &&
          _assOrLab == null &&
          _homeWork == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Fill Up Every Field"),
          backgroundColor: Colors.red[900],
        ));
        return;
      } else {
        // final user =  FirebaseAuth.instance.currentUser;

        FirebaseFirestore.instance.collection("/ald").add({
          "grp": _selestedGroup.trim(),
          "subject": _subject.trim(),
          "title": _assOrLab.trim(),
          "hw": _homeWork.trim(),
          "dates": DateFormat.yMMMd().format(_selectedDate),
        });
        print(_selectedDate);
        // SnackBar(content: Text("Successfully Data Added"))
        snakBarMsg();
      }
      _controller.clear();
    }
    if (isValid && isHw) {
      _formKey.currentState.save();
      if (_selectedDate == null) {
        return;
      } else {
        FirebaseFirestore.instance.collection("/hw").add({
          "grp": _selestedGroup,
          "dates": DateFormat.yMMMd().format(_selectedDate),
          "hw": _homeWork
        });
        snakBarMsg();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigoAccent,
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.pink,
          title: Text("Admin Panel"),
          actions: [
            DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).iconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: TextButton.icon(
                              onLongPress: () {
                                FirebaseAuth.instance.signOut();
                              },
                              onPressed: () {},
                              icon: Icon(Icons.logout_outlined),
                              label: Text("Log out")),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          child: TextButton.icon(
                              onLongPress: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MyHome()));
                              },
                              onPressed: () {},
                              icon: Icon(Icons.home),
                              label: Text("Home")),
                        )
                      ],
                    ),
                  ),
                  value: "Log out",
                )
              ],
              onChanged: (itemdefinder) {
                if (itemdefinder == "Log out") {
                  FirebaseAuth.instance.signOut();
                }
              },
            )
          ],
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
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isHw = !isHw;
                            print(isHw);
                          });
                        },
                        child: Text(isHw
                            ? "Add Assignment/Lab Report"
                            : "Add Home Work"),
                      ),
                      DropdownButtonFormField(
                        key: ValueKey("Group"),
                        hint: Text(
                          'Choose Group',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selestedGroup = value;
                          });
                        },
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "can't empty";
                          } else {
                            return null;
                          }
                        },
                        items: listOfGroup.map((String val) {
                          return DropdownMenuItem(
                            value: val,
                            child: Text(
                              val,
                            ),
                          );
                        }).toList(),
                      ),
                      if (!isHw)
                        TextFormField(
                          key: ValueKey("subject"),
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(labelText: "Subject"),
                          // obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Enter subject ";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _subject = value;
                          },
                        ),
                      if (!isHw)
                        DropdownButtonFormField(
                          key: ValueKey("Assginment/lab"),
                          hint: Text(
                            'Choose Assginment/lab',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _assOrLab = value;
                            });
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Can't empty Assginment/lab";
                            } else {
                              return null;
                            }
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
                          if (value.isEmpty) {
                            return "Please Enter Data";
                          }
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                              onPressed: _selectDate,
                              icon: Icon(Icons.date_range),
                              label: Text(_selectedDate == null
                                  ? "Choose Date"
                                  : DateFormat.yMMMd().format(_selectedDate))),
                          ElevatedButton.icon(
                              onPressed: enterData,
                              icon: Icon(Icons.add),
                              label: Text("Add"))
                        ],
                      ),
                    ],
                  )),
            ),
          ),
        ));
  }
}
