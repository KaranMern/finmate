import 'package:finmate/Presentation/Screens/Dashbaord.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Constants/Image_Constants.dart';
import '../../Constants/String_Constant.dart';
import '../../base/Firebase/Firebase_Authentication.dart';
import '../widgets/CustomButton.dart';
import '../widgets/CustomTextfield.dart';
import 'HomeScreen.dart';

class LoginAndSignUpScreen extends StatefulWidget {
  const LoginAndSignUpScreen({super.key});

  @override
  State<LoginAndSignUpScreen> createState() => _LoginAndSignUpScreenState();
}

class _LoginAndSignUpScreenState extends State<LoginAndSignUpScreen> {
  bool isSelected = false;
  bool isLogin = true;
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 42).r,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isLogin?Constants.login_text:Constants.signUp_text,style: TextStyle(fontSize: 20.h,fontWeight: FontWeight.bold,letterSpacing: 2),),
                      SizedBox(height: 5.h),
                      Text(Constants.login_subText,style: TextStyle(fontSize: 10.h),),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 29.h),
              Text("Enter via Social Networks",style: TextStyle(fontSize: 12.sp,letterSpacing: 2,fontWeight: FontWeight.bold),),
              SizedBox(height: 22.h),
              !isLogin?CustomTextField(
                name: 'UserEmail',placeHolder:'Enter your name',
              ):SizedBox(),
              SizedBox(height: 9.h),
              CustomTextField(
                name: 'UserEmail',placeHolder:'Enter your email',
                textEditingController: Email,
              ),
              SizedBox(height: 9.h),
              CustomTextField(
                name: 'UserPassword',placeHolder:'Enter your password',
                textEditingController: Password,
                isPasswordField: true,
              ),
              SizedBox(height: 9.h),
              !isLogin?Row(
                children: [
                  SizedBox(
                    height: 12,
                    child: Checkbox(value: isSelected, onChanged: (val){
                      setState(() {
                        isSelected = val!;
                      });
                    }),
                  ),
                  Text(Constants.policy_text,style: TextStyle(fontSize: 12.sp,),)
                ],
              ):SizedBox(),
              SizedBox(height: 12.h),
              CustomElevatedButton(
               width: double.infinity,
                height: 36.h,
                text: isLogin?Constants.login_text:Constants.signUp_text,
                onPressed: ()async{
                 if(!isLogin){
                   final user = await FirestoreService().createUserWithEmailAndPassword(Email.text.trim(), Password.text.trim());
                   setState(() {
                     isLogin=!isLogin;
                   });
                   print('successfully created');
                 }else{
                   final user = await FirestoreService().signInWithEmailAndPassword(Email.text.trim(), Password.text.trim());
                   print(user.user!.email);
                   await navigation(user!);
                 }
                },
              ),
              SizedBox(height: 9.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(isLogin?Constants.textB:Constants.textA),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isLogin=!isLogin;
                      });
                    },
                      child: Text(isLogin?Constants.signUp_text:Constants.login_text,style: TextStyle(fontWeight: FontWeight.bold),))
                ],
              ),
              SizedBox(height: 29.h),
              Row(children: <Widget>[
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                        color: Colors.black,
                        height: 26,
                      )),
                ),
                Text("OR"),
                Expanded(
                  child:  Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: Divider(
                        color: Colors.black,
                        height: 26,
                      )),
                ),
              ]),
              SizedBox(height: 9.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final user = await FirestoreService().signInWithGoogle();
                      if(user!=null){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Homescreen()));
                      }
                      else{
                        Fluttertoast.showToast(msg: "Sign in Failed");
                        return;
                      }
                    },
                    child: Container(
                      height: 50.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3), // soft shadow
                            blurRadius: 8,
                            offset: Offset(2, 4), // shadow direction
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          ImageConstants.Gmail,
                          height: 24,
                          width: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w,),
                  Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3), // soft shadow
                          blurRadius: 8,
                          offset: Offset(2, 4), // shadow direction
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        ImageConstants.Gmail,
                        height: 24,
                        width: 24,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 9.h),
            ],
          ),
        ),
      ),
    );
  }

   navigation(UserCredential? user){
    if(user!=null){
       Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Homescreen()));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>LoginAndSignUpScreen()));
    }
  }
}
