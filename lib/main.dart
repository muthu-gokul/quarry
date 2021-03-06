import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quarry/login.dart';
import 'package:quarry/notifier/loginNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/homePage.dart';

import 'testing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<QuarryNotifier>(create:(_)=>QuarryNotifier()),
        ChangeNotifierProvider<LoginNotifier>(create:(_)=>LoginNotifier()),
      ],
      child: MaterialApp(
        title: 'Quarry Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        // home: MyHomePage(),
      ),
    );
  }
}

