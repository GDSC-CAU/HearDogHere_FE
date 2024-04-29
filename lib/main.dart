import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:space_dog/screens/sign_in_screen.dart';
import 'package:space_dog/screens/splash_screen.dart';
import 'package:space_dog/screens/home_screen.dart';
import 'package:space_dog/screens/start_screen.dart';
import 'notification/notification_list.dart';
import 'screens/sign_up_screens/enter_dog_name_screen.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'notification/local_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationList()),
      ],
      builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: SplashScreen(),
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/signin': (context) => const SignIn(),
            '/home': (context) => const HomePage(),
          }),
    );
  }
}
