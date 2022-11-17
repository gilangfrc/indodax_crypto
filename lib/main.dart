import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indodax_trading/home.dart';
import 'package:indodax_trading/loading.dart';
// import 'loading.dart';
// import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: const Loading(),
      theme: ThemeData(fontFamily: 'Poppins'),
      initialRoute: '/',
      routes: {
        '/': (context) => const Loading(),
        '/home': (context) => const Home(),
      },
    ),
  );
}
