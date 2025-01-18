import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:siet_incampus_map/widgets/WebViewScreen.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  await Future.delayed(const Duration(seconds: 1));
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: true, home: WebViewScreen()));
  FlutterNativeSplash.remove();
}
