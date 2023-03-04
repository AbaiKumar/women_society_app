// ignore_for_file: prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:society_app_for_women/customer_home/customer_home.dart';
import 'package:society_app_for_women/seller_home/seller_home.dart';
import 'login module/login.dart';
import 'model/data.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

late final prefs;
Future frontTime() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  prefs = await SharedPreferences.getInstance(); //cookie
  return;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MaterialApp(
      title: 'Women Innovation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: "Roboto"),
        ),
        primarySwatch: Colors.yellow,
      ),
      home: StretchingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        child: FutureBuilder(
          builder: ((context, snapshot) {
            final size = MediaQuery.of(context).size;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView(
                children: [
                  SizedBox(
                    width: size.width * 0.6,
                    height: size.height * 0.3,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(size.width * 0.3),
                        ),
                        child: Image.asset(
                          "assets/images/society.jpeg",
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                  const CircularProgressIndicator(
                    color: Colors.red,
                  ),
                ],
              );
            } else {
              return ChangeNotifierProvider(
                create: (BuildContext context) => Data(),
                child: const MyApp(),
              );
            }
          }),
          future: frontTime(),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String? action, type;
  @override
  void initState() {
    super.initState();
    // Try reading data from the 'phone' key. If it doesn't exist, returns null.
    action = prefs.getString('phone');
    type = prefs.getString('type');

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      await showDialog(
        useSafeArea: true,
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            event.notification!.title.toString(),
            style: const TextStyle(
              color: Colors.orange,
            ),
          ),
          content: Text(
            event.notification!.body.toString(),
            overflow: TextOverflow.visible,
            maxLines: 4,
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("ok"),
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var a = Provider.of<Data>(context, listen: true);
    action = a.phone ?? action;
    type = a.type ?? type;
    return (type == null)
        ? MyLogScreen()
        : (type == "Seller")
            ? SellerHomeScreen()
            : CustomerHomeScreen();
  }
}
