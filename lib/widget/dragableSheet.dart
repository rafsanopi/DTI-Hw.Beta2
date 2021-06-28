import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dti_hw_v2/model%20and%20data/m_and_data.dart';
import 'package:dti_hw_v2/widget/update_Hw.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';

Widget text(String txt, double fontsize) {
  return AutoSizeText(
    txt,
    style: TextStyle(fontSize: fontsize, color: Colors.white),
    maxLines: 3,
  );
}

Widget row(Widget child1, Widget child2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [child1, child2],
  );
}

class DragableSheet extends StatefulWidget {
  final String grpname;

  DragableSheet(
    this.grpname,
  );
  @override
  _DragableSheetState createState() => _DragableSheetState();
}

class _DragableSheetState extends State<DragableSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.12,
      minChildSize: 0.12,
      builder: (context, scrollController) {
        return Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF162A49),
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("/hw")
                  .where("grp", isEqualTo: widget.grpname)
                  .orderBy("dates", descending: true)
                  .snapshots(),
              builder: (ctx, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return Center(
                //     child: CircularProgressIndicator(),
                //   );
                //
                return snapshot.data == null
                    ? Center(
                        child: text("No data", 40),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (ctx, index) {
                          var uid = snapshot.data.docs[index].id;
                          return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      color: Colors.deepPurple,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40))),
                                  child: snapshot.data.docs[index]["grp"] ==
                                          grpdata
                                      ? Center(
                                          child: text("No data", 40),
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                TextButton.icon(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  UpdateHw(
                                                                      uid)));
                                                    },
                                                    icon: Icon(Icons.update),
                                                    label: Text("Update")),
                                                text(
                                                    snapshot.data.docs[index]
                                                        ["dates"],
                                                    35),
                                                if (FirebaseAuth
                                                        .instance.currentUser !=
                                                    null)
                                                  TextButton.icon(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                true,
                                                            // barrierColor: Colors.red,

                                                            builder:
                                                                (_) =>
                                                                    AlertDialog(
                                                                      title: Text(
                                                                          "Delete?"),
                                                                      content: Text(
                                                                          "Are You Sure?"),
                                                                      elevation:
                                                                          10,
                                                                      actions: [
                                                                        TextButton.icon(
                                                                            icon: Icon(Icons.circle),
                                                                            onPressed: () {
                                                                              FirebaseFirestore.instance.collection("/hw").doc(uid).delete();
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                content: Text("Successfully Deleted Data"),
                                                                                backgroundColor: Colors.red[900],
                                                                              ));
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            label: Text("Yes")),
                                                                        TextButton.icon(
                                                                            onPressed: () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            icon: Icon(Icons.cancel),
                                                                            label: Text("Cancle"))
                                                                      ],
                                                                    ));
                                                      },
                                                      icon: Icon(Icons.delete),
                                                      label: Text("Delete")),
                                              ],
                                            ),
                                            row(text("Subjects", 25),
                                                text("HomeWorks", 25)),
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              width: double.infinity,
                                              child: Card(
                                                elevation: 20,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 15,
                                                      horizontal: 25),
                                                  child: AutoSizeText(
                                                    snapshot.data.docs[index]
                                                        ["hw"],
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.black),
                                                    maxLines: 7,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )));
                        },
                      );
              },
            ));
      },
    );
  }
}
