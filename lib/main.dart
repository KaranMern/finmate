import 'package:background_fetch/background_fetch.dart' as bg;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as PermissionManager;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'Notification/LocalNotification.dart';
import 'Notification/PushNotification.dart';
import 'Presentation/Screens/Login_Screen.dart';
import 'firebase_options.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
final GlobalKey<NavigatorState> navigatorsKey = GlobalKey<NavigatorState>();
@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(bg.HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;

  if (isTimeout) {
    await LocalNotification.showInstantNotification(
      title: "Background Fetch Timeout",
      body: "Task $taskId timed out",
    );
    bg.BackgroundFetch.finish(taskId);
    return;
  }
  try {
    WidgetsFlutterBinding.ensureInitialized();
    tz.initializeTimeZones();
    await LocalNotification.showInstantNotification(
      title: "Background Fetch",
      body: "Success",
    );
  } catch (e) {
    await LocalNotification.showInstantNotification(
      title: "Background Fetch Error",
      body: "$e",
    );
  }

  bg.BackgroundFetch.finish(taskId);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp();
  auth = FirebaseAuth.instanceFor(app: app);
  await LocalNotification.localInit();
  await PushNotificationService().init();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  print("Tokennnnnnnnnnnnnnnnnnnn");
  print(token);
  bg.BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  await bg.BackgroundFetch.configure(
    bg.BackgroundFetchConfig(
      minimumFetchInterval: 2,
      stopOnTerminate: false,
      startOnBoot: true,
      enableHeadless: true,
      forceAlarmManager: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: bg.NetworkType.NONE,
    ),
    (String taskId) async {
      print("[FOREGROUND] Event received: $taskId");
      try {
        // await BudgetCRUD().checkBudget(localDB, auth.currentUser!.uid);
      } catch (e) {
        print("[FOREGROUND] Error: $e");
      }
      bg.BackgroundFetch.finish(taskId);
    },
    (String taskId) async {
      print("[TIMEOUT] $taskId");
      // await BudgetCRUD().checkBudget(localDB, auth.currentUser!.uid);
      bg.BackgroundFetch.finish(taskId);
    },
  );
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
