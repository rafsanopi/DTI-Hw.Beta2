import 'package:dti_hw_v2/widget/update_Ass_lab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:auto_size_text/auto_size_text.dart';

Widget texts(String text, double contaiHeight, double fontsize) {
  return Container(
      height: contaiHeight,
      child: AutoSizeText(
        text,
        style: TextStyle(fontSize: fontsize),
        maxLines: 3,
      ));
}

class AssORlab extends StatelessWidget {
  final String grpname;
  final bool islogin;

  AssORlab(this.grpname, this.islogin);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("/ald")
            .where("grp", isEqualTo: grpname)
            .orderBy("dates", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return snapshot.data == null
              ? Center(
                  child: Text(
                    "No data",
                    style: TextStyle(color: Colors.white70, fontSize: 30),
                  ),
                )
              : Swiper(
                  // pagination: Expanded(),
                  itemCount: snapshot.data.docs.length,
                  scrollDirection: Axis.horizontal,
                  viewportFraction: 0.7,
                  scale: 0.9,
                  layout: SwiperLayout.DEFAULT,
                  itemBuilder: (ctx, index) {
                    var docId = snapshot.data.docs[index].id;
                    return Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          texts(snapshot.data.docs[index]["dates"],
                              MediaQuery.of(context).size.height * 0.07, 40),
                          texts(snapshot.data.docs[index]["subject"],
                              MediaQuery.of(context).size.height * 0.07, 40),
                          texts(snapshot.data.docs[index]["title"],
                              MediaQuery.of(context).size.height * 0.07, 40),
                          texts(snapshot.data.docs[index]["hw"],
                              MediaQuery.of(context).size.height * 0.04, 30),
                          if (FirebaseAuth.instance.currentUser != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton.icon(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          // barrierColor: Colors.red,

                                          builder: (_) => AlertDialog(
                                                title: Text("Delete?"),
                                                content: Text("Are You Sure?"),
                                                elevation: 10,
                                                actions: [
                                                  TextButton.icon(
                                                      icon: Icon(Icons.circle),
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection("/ald")
                                                            .doc(docId)
                                                            .delete();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              "Successfully Deleted Data"),
                                                          backgroundColor:
                                                              Colors.red[900],
                                                        ));
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      label: Text("Yes")),
                                                  TextButton.icon(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      icon: Icon(Icons.cancel),
                                                      label: Text("Cancle"))
                                                ],
                                              ));
                                    },
                                    icon: Icon(Icons.delete),
                                    label: Text("Delete")),
                                if (FirebaseAuth.instance.currentUser != null)
                                  TextButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    UpdateAssLabData(docId)));
                                      },
                                      icon: Icon(Icons.update),
                                      label: Text("Update"))
                              ],
                            )
                        ],
                      ),
                    );
                  },
                );
        });
  }
}
