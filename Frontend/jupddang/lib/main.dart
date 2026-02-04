import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'features/auth/presentation/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jupddang',
      theme: flutterNesTheme(brightness: Brightness.light),
      darkTheme: flutterNesTheme(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
