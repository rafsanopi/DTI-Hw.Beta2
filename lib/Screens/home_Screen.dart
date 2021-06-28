import 'package:dti_hw_v2/Admin_Panel/add_data.dart';
import 'package:dti_hw_v2/Admin_Panel/auth_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Screens/grpdata_Screen.dart';

import 'package:dti_hw_v2/model%20and%20data/m_and_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var islogin = false;
    return Scaffold(
        backgroundColor: Colors.deepOrange,
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.20,
              child: Center(
                child: InkWell(
                  onLongPress: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => StreamBuilder(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (ctx, hasadmindata) {
                                if (hasadmindata.hasData) {
                                  islogin = true;
                                  print(islogin);
                                  return AdminPanel();
                                }
                                return AuthScreen();
                              },
                            )));
                  },
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'D',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 60)),
                        TextSpan(
                            text: 'TI 5th ', style: TextStyle(fontSize: 30)),
                        TextSpan(
                            text: 'S',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 40)),
                        TextSpan(
                            text: 'emester', style: TextStyle(fontSize: 30)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.80,
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(100))),
              child: Swiper(
                itemWidth: MediaQuery.of(context).size.height * 0.40,
                itemHeight: MediaQuery.of(context).size.height * 0.55,
                itemCount: grpdata.length,
                // autoplay: true,
                // pagination: SwiperPagination(),
                scrollDirection: Axis.horizontal,

                layout: SwiperLayout.STACK,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              grpdata[index].grpname,
                              style: TextStyle(
                                  fontSize: 60, color: Colors.black54),
                            ),
                          ],
                        ))),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GrpData(grpdata[index].grpname, islogin)),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}
