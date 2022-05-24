import 'package:flutter/material.dart';
import 'package:flutter_paint_web_app/constants.dart';
import 'package:flutter_paint_web_app/models/room.dart';
import 'package:flutter_paint_web_app/screens/game/game_screen.dart';
import 'package:flutter_paint_web_app/screens/login/login_screen.dart';
import 'package:flutter_paint_web_app/screens/room_list/room_list_screen.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  @override
  void initState(){
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint("app in resumed");
        break;
      case AppLifecycleState.inactive:
        debugPrint("app in inactive");
        break;
      case AppLifecycleState.paused:
        debugPrint("app in paused");
        break;
      case AppLifecycleState.detached:
        debugPrint("app in detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Catch Mind',
      theme: ThemeData(
        primaryColor: kColorOrange,
        scaffoldBackgroundColor: kColorLightDark,
      ),
      initialRoute: '/LoginScreen',
      getPages: [
        GetPage(name: '/LoginScreen', page: () => LoginScreen()),
        GetPage(name: '/RoomListScreen', page: () => const RoomListScreen()),
        GetPage(name: '/GameScreen', page: () => GameScreen(room: Room())),
      ],
      home: LoginScreen(),
    );
  }
}
