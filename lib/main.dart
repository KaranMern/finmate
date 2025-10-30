import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Notification/LocalNotification.dart';
import 'Notification/PushNotification.dart';
import 'Presentation/Screens/Login_Screen.dart';
import 'firebase_options.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
final GlobalKey<NavigatorState> navigatorsKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp();
  auth = FirebaseAuth.instanceFor(app: app);
  await LocalNotification.localInit();
  await PushNotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: LoginAndSignUpScreen(),
      ),
    );
  }
}
