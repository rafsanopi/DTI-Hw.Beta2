import '../widget/ass_lab.dart';
import 'package:dti_hw_v2/Screens/home_Screen.dart';
import 'package:flutter/material.dart';
import '../widget/dragableSheet.dart';

class GrpData extends StatelessWidget {
  final String grpname;
  final bool islogin;

  GrpData(this.grpname, this.islogin);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        body: Stack(
          children: [
            SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => MyHome()));
                        },
                        icon: Icon(Icons.arrow_back),
                        label: Text(
                          "Back",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        )),
                    Text(
                      "Hey Its Group " + grpname,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Text(
                  "Assginments/Lab Report",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.50,
                    width: MediaQuery.of(context).size.width * 1,
                    //
                    //GrpData Screen are Here//
                    ///
                    child: AssORlab(grpname, islogin)),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text(
                  "Swip Up For Home Works",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w800),
                ),
              ],
            )),
            DragableSheet(grpname)
          ],
        ));
  }
}
