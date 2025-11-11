import 'package:finmate/Constants/Image_Constants.dart';
import 'package:finmate/Presentation/Screens/Dashbaord.dart';
import 'package:finmate/Presentation/Screens/Login_Screen.dart';
import 'package:finmate/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../base/CRUD/User_CRUD.dart';
import 'HomeScreen.dart';

class Autologin extends StatefulWidget {
  const Autologin({super.key});

  @override
  State<Autologin> createState() => _AutologinState();
}

class _AutologinState extends State<Autologin> {
  bool islogin = false;
  @override
  void initState() {
    super.initState();
    Autologin();
  }

  Widget build(BuildContext context) {
    return Center(child: Image.asset('assets/Images/AppLogo.png'));
  }

  Autologin() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      final data = await UserModel().getUser(localDB);
      if (user!=null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Homescreen(),
          ),
        );
      }
      else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginAndSignUpScreen(),
          ),
        );
      }
    });
  }
}
